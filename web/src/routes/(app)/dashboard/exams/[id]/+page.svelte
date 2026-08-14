<script lang="ts">
	import { onDestroy, onMount } from 'svelte';
	import { page } from '$app/state';
	import {
		examsApi,
		importsApi,
		questionsApi,
		ApiError,
		type ExamDetail,
		type QuestionImport
	} from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	const examId = Number(page.params.id);

	// The API parses the spreadsheet in a background job, so the panel polls
	// the import record until it settles.
	const POLL_INTERVAL = 1500;
	const POLL_TIMEOUT = 120_000;

	let importFile = $state<File | null>(null);
	let importState: 'idle' | 'running' | 'done' | 'error' | 'timeout' = $state('idle');
	let importError = $state('');
	let importResult = $state<QuestionImport | null>(null);
	let fileInput = $state<HTMLInputElement | null>(null);
	let pollTimer: ReturnType<typeof setTimeout> | undefined;

	onDestroy(() => clearTimeout(pollTimer));

	let exam = $state<ExamDetail | null>(null);
	let loadState: 'loading' | 'ready' | 'error' = $state('loading');

	// Exams are readable by anyone but writable only by their author, so the
	// write panels are hidden rather than offered and then rejected.
	const isOwner = $derived(exam !== null && auth.user?.id === exam.user_id);

	let questionTitle = $state('');
	let options = $state<{ text: string }[]>([{ text: '' }, { text: '' }]);
	let correctIndex = $state(0);
	let createState: 'idle' | 'submitting' | 'error' = $state('idle');
	let createError = $state('');

	async function load() {
		loadState = 'loading';
		try {
			exam = await examsApi.get(examId);
			loadState = 'ready';
		} catch {
			loadState = 'error';
		}
	}

	onMount(load);

	function addOption() {
		if (options.length < 5) options = [...options, { text: '' }];
	}

	function removeOption(index: number) {
		if (options.length <= 2) return;
		options = options.filter((_, i) => i !== index);
		if (correctIndex >= options.length) correctIndex = options.length - 1;
	}

	function resetForm() {
		questionTitle = '';
		options = [{ text: '' }, { text: '' }];
		correctIndex = 0;
	}

	async function handleCreate(event: SubmitEvent) {
		event.preventDefault();
		if (!questionTitle.trim() || options.some((o) => !o.text.trim())) return;
		createState = 'submitting';
		createError = '';
		try {
			await questionsApi.create({
				title: questionTitle.trim(),
				exam_id: examId,
				options: options.map((o, i) => ({ text: o.text.trim(), correct: i === correctIndex }))
			});
			resetForm();
			createState = 'idle';
			await load();
		} catch (err) {
			createState = 'error';
			createError = err instanceof ApiError ? err.message : 'Could not create that question.';
		}
	}

	function pickFile(event: Event) {
		const input = event.currentTarget as HTMLInputElement;
		importFile = input.files?.[0] ?? null;
	}

	async function handleImport(event: SubmitEvent) {
		event.preventDefault();
		if (!importFile) return;
		importState = 'running';
		importError = '';
		importResult = null;
		try {
			const started = await importsApi.create(examId, importFile);
			pollImport(started.id, Date.now());
		} catch (err) {
			importState = 'error';
			importError = err instanceof ApiError ? err.message : 'Could not start that import.';
		}
	}

	function pollImport(id: number, startedAt: number) {
		pollTimer = setTimeout(async () => {
			try {
				const current = await importsApi.get(id);
				if (current.status === 'completed' || current.status === 'failed') {
					importResult = current;
					importState = 'done';
					resetImportForm();
					await load();
				} else if (Date.now() - startedAt > POLL_TIMEOUT) {
					importState = 'timeout';
				} else {
					pollImport(id, startedAt);
				}
			} catch (err) {
				importState = 'error';
				importError = err instanceof ApiError ? err.message : 'Lost track of that import.';
			}
		}, POLL_INTERVAL);
	}

	function resetImportForm() {
		importFile = null;
		if (fileInput) fileInput.value = '';
	}

	function summarize(result: QuestionImport) {
		const parts = [`${result.imported_count} imported`];
		if (result.skipped_count > 0) parts.push(`${result.skipped_count} already in this exam`);
		if (result.failed_count > 0) parts.push(`${result.failed_count} couldn't be read`);
		return `${parts.join(', ')}.`;
	}
</script>

<svelte:head>
	<title>{exam ? exam.title : 'Exam'} — Flashmemo</title>
</svelte:head>

{#if loadState === 'loading'}
	<div class="panel">
		<div class="skeleton-line" style="width: 50%; margin-bottom: 0.6rem;"></div>
		<div class="skeleton-line" style="width: 30%;"></div>
	</div>
{:else if loadState === 'error' || !exam}
	<p class="form-alert form-alert--error" role="alert">Couldn't load this exam.</p>
{:else}
	<header class="exam-header">
		<div>
			<a class="back-link" href="/dashboard/exams">← All exams</a>
			<h1 class="page-title">{exam.title}</h1>
			<div class="exam-meta">
				<span class="badge badge--{exam.level}">{exam.level}</span>
				{#if exam.category}<span class="exam-meta__item">{exam.category}</span>{/if}
				<span class="exam-meta__item">{exam.total} question{exam.total === 1 ? '' : 's'}</span>
			</div>
		</div>
		{#if exam.total > 0}
			<a class="button" href="/dashboard/exams/{exam.id}/take">Take exam</a>
		{/if}
	</header>

	{#if isOwner}
		<div class="panel">
			<div class="panel-head">
				<span class="panel-title">Add a question</span>
			</div>
			<form class="question-form" onsubmit={handleCreate}>
				<div class="field">
					<label for="q-title">Question</label>
					<input id="q-title" type="text" placeholder="e.g. What powers a cell?" required bind:value={questionTitle} />
				</div>

				<fieldset class="options-fieldset">
					<legend>Options — mark the correct one</legend>
					{#each options as option, i (i)}
						<div class="option-row">
							<input
								type="radio"
								name="correct"
								checked={correctIndex === i}
								onchange={() => (correctIndex = i)}
								aria-label={`Option ${i + 1} is correct`}
							/>
							<input type="text" placeholder={`Option ${i + 1}`} required bind:value={option.text} />
							{#if options.length > 2}
								<button type="button" class="remove-option" onclick={() => removeOption(i)} aria-label="Remove option">
									×
								</button>
							{/if}
						</div>
					{/each}
					{#if options.length < 5}
						<button type="button" class="button button--ghost button--small" onclick={addOption}>
							+ Add option
						</button>
					{/if}
				</fieldset>

				<button class="button" type="submit" disabled={createState === 'submitting'}>
					{createState === 'submitting' ? 'Adding…' : 'Add question'}
				</button>
			</form>
			{#if createState === 'error'}
				<p class="field-error">{createError}</p>
			{/if}
		</div>

		<div class="panel">
			<div class="panel-head">
				<span class="panel-title">Import a spreadsheet</span>
				<a class="template-link" href="/import-template.xlsx" download>Download template</a>
			</div>

			<p class="import-hint">
				One question per row: <code>title</code>, then <code>option_a</code> through <code>option_e</code>, and
				<code>correct</code> holding the letter of the right option. Leave unused option columns empty. .xlsx only, up
				to 500 questions at a time — questions already in this exam are skipped rather than duplicated.
			</p>

			<form class="import-form" onsubmit={handleImport}>
				<input
					bind:this={fileInput}
					type="file"
					accept=".xlsx"
					aria-label="Spreadsheet to import"
					onchange={pickFile}
				/>
				<button class="button" type="submit" disabled={!importFile || importState === 'running'}>
					{importState === 'running' ? 'Importing…' : 'Import questions'}
				</button>
			</form>

			{#if importState === 'running'}
				<p class="import-status" aria-live="polite">Reading your spreadsheet…</p>
			{:else if importState === 'error'}
				<p class="form-alert form-alert--error" role="alert">{importError}</p>
			{:else if importState === 'timeout'}
				<p class="form-alert form-alert--info">
					This import is taking longer than expected. It's still running — reload the page in a moment to see the
					result.
				</p>
			{:else if importResult}
				{#if importResult.status === 'failed'}
					<p class="form-alert form-alert--error" role="alert">
						That spreadsheet couldn't be imported. {importResult.failure_reason}
					</p>
				{:else}
					<p class="import-status" aria-live="polite">{summarize(importResult)}</p>
					{#if importResult.row_errors.length > 0}
						<details class="import-errors">
							<summary>Show the {importResult.row_errors.length} rows that didn't make it</summary>
							<ul>
								{#each importResult.row_errors as rowError (rowError.row)}
									<li>
										<span class="import-errors__row">Row {rowError.row}</span>
										<span class="import-errors__title">{rowError.title}</span>
										<span class="import-errors__reason">{rowError.reason}</span>
									</li>
								{/each}
							</ul>
						</details>
					{/if}
				{/if}
			{/if}
		</div>
	{/if}

	{#if exam.questions.length === 0}
		<div class="empty-state">
			<strong>No questions yet</strong>
			{#if isOwner}
				<p>Add your first question above before you can take this exam.</p>
			{:else}
				<p>Whoever built this exam hasn't added any questions to it yet.</p>
			{/if}
		</div>
	{:else}
		<div class="panel">
			<ol class="question-list">
				{#each exam.questions as question, i (question.id)}
					<li>
						<p class="question-list__title">{i + 1}. {question.title}</p>
						<ul class="question-list__options">
							{#each question.options as opt (opt.id)}
								<li>{opt.text}</li>
							{/each}
						</ul>
					</li>
				{/each}
			</ol>
		</div>
	{/if}
{/if}

<style>
	.exam-header {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: var(--space-md);
		flex-wrap: wrap;
	}

	.back-link {
		display: inline-block;
		color: var(--tan-400);
		text-decoration: none;
		font-size: 0.8125rem;
		margin-bottom: 0.4rem;
	}

	.back-link:hover {
		color: var(--gold-300);
	}

	.exam-meta {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin-top: 0.4rem;
	}

	.exam-meta__item {
		font-size: 0.8125rem;
		color: var(--tan-400);
	}

	.question-form {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
	}

	.template-link {
		font-size: 0.8125rem;
		font-weight: 600;
		color: var(--crimson-500);
		text-decoration: none;
	}

	.template-link:hover {
		text-decoration: underline;
	}

	.import-hint {
		font-size: 0.8125rem;
		line-height: 1.5;
		color: var(--paper-ink-muted);
	}

	.import-hint code {
		font-family: var(--font-mono);
		font-size: 0.75rem;
		background: color-mix(in srgb, var(--paper-ink) 8%, transparent);
		padding: 0.05rem 0.3rem;
		border-radius: 4px;
	}

	.import-form {
		display: flex;
		align-items: center;
		gap: var(--space-sm);
		flex-wrap: wrap;
		margin-top: var(--space-sm);
	}

	.import-form input[type='file'] {
		font-size: 0.8125rem;
		color: var(--paper-ink-muted);
		min-width: 0;
		flex: 1 1 14rem;
	}

	.import-status {
		margin-top: var(--space-sm);
		font-size: 0.875rem;
		font-weight: 600;
		color: var(--paper-ink);
	}

	.import-errors {
		margin-top: 0.5rem;
		font-size: 0.8125rem;
	}

	.import-errors summary {
		cursor: pointer;
		color: var(--paper-ink-muted);
	}

	.import-errors ul {
		list-style: none;
		padding: 0;
		margin-top: 0.5rem;
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
	}

	.import-errors li {
		display: grid;
		grid-template-columns: 4.5rem minmax(0, 1fr) minmax(0, 1.2fr);
		gap: 0.5rem;
		padding-bottom: 0.4rem;
		border-bottom: 1px solid color-mix(in srgb, var(--paper-ink) 10%, transparent);
	}

	.import-errors__row {
		font-family: var(--font-mono);
		color: var(--paper-ink-muted);
	}

	.import-errors__reason {
		color: var(--crimson-500);
	}

	@media (max-width: 640px) {
		.import-errors li {
			grid-template-columns: 1fr;
			gap: 0.15rem;
		}
	}

	.options-fieldset {
		border: none;
		padding: 0;
		margin: 0;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.options-fieldset legend {
		font-size: 0.8125rem;
		font-weight: 600;
		color: var(--paper-ink-muted);
		padding: 0;
		margin-bottom: 0.25rem;
	}

	.option-row {
		display: flex;
		align-items: center;
		gap: 0.5rem;
	}

	.option-row input[type='text'] {
		flex: 1;
		background: var(--paper-100);
		color: var(--paper-ink);
		border: 1px solid var(--paper-300);
		border-radius: var(--radius-card);
		padding: 0.5rem 0.7rem;
		font-size: 0.875rem;
	}

	.option-row input[type='radio'] {
		accent-color: var(--crimson-500);
		width: 1rem;
		height: 1rem;
		flex-shrink: 0;
	}

	.remove-option {
		background: none;
		border: none;
		color: var(--crimson-500);
		font-size: 1.1rem;
		line-height: 1;
		cursor: pointer;
		padding: 0.2rem 0.4rem;
	}

	.question-list {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.9rem;
	}

	.question-list li + li {
		padding-top: 0.9rem;
		border-top: 1px dashed color-mix(in srgb, var(--paper-ink) 18%, transparent);
	}

	.question-list__title {
		font-weight: 600;
		color: var(--paper-ink);
		margin: 0 0 0.35rem;
	}

	.question-list__options {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
		color: var(--paper-ink-muted);
		font-size: 0.875rem;
	}
</style>
