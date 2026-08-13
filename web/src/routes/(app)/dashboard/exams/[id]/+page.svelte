<script lang="ts">
	import { onMount } from 'svelte';
	import { page } from '$app/state';
	import { examsApi, questionsApi, ApiError, type ExamDetail } from '$lib/api';

	const examId = Number(page.params.id);

	let exam = $state<ExamDetail | null>(null);
	let loadState: 'loading' | 'ready' | 'error' = $state('loading');

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

	{#if exam.questions.length === 0}
		<div class="empty-state">
			<strong>No questions yet</strong>
			<p>Add your first question above before you can take this exam.</p>
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
