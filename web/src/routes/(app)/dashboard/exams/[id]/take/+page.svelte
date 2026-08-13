<script lang="ts">
	import { onMount } from 'svelte';
	import { page } from '$app/state';
	import { examsApi, ApiError, type ExamDetail } from '$lib/api';

	const examId = Number(page.params.id);

	let exam = $state<ExamDetail | null>(null);
	let loadState: 'loading' | 'ready' | 'error' = $state('loading');

	let answers = $state<Record<number, number>>({});
	let submitState: 'idle' | 'submitting' | 'error' = $state('idle');
	let submitError = $state('');
	let score = $state<number | null>(null);

	onMount(async () => {
		loadState = 'loading';
		try {
			exam = await examsApi.get(examId);
			loadState = 'ready';
		} catch {
			loadState = 'error';
		}
	});

	function allAnswered() {
		return exam !== null && exam.questions.every((q) => answers[q.id] !== undefined);
	}

	async function handleSubmit(event: SubmitEvent) {
		event.preventDefault();
		if (!exam || !allAnswered()) return;
		submitState = 'submitting';
		submitError = '';
		try {
			const result = await examsApi.evaluate(
				exam.id,
				exam.questions.map((q) => ({ id: q.id, option_id: answers[q.id] }))
			);
			score = result.score;
			submitState = 'idle';
		} catch (err) {
			submitState = 'error';
			submitError = err instanceof ApiError ? err.message : 'Could not submit your answers.';
		}
	}
</script>

<svelte:head>
	<title>{exam ? `Take ${exam.title}` : 'Take exam'} — Flashmemo</title>
</svelte:head>

{#if loadState === 'loading'}
	<div class="panel">
		<div class="skeleton-line" style="width: 50%; margin-bottom: 0.6rem;"></div>
		<div class="skeleton-line" style="width: 30%;"></div>
	</div>
{:else if loadState === 'error' || !exam}
	<p class="form-alert form-alert--error" role="alert">Couldn't load this exam.</p>
{:else if score !== null}
	<div class="panel result-panel">
		<span class="panel-title">Score</span>
		<p class="result-score">{score}%</p>
		<p class="page-lede">
			{#if score > 90}
				Excellent work — that's a strong result.
			{:else if score >= 60}
				Solid attempt. Missed questions may show up again in your revisions.
			{:else}
				That one was tough. Missed questions will come back around for review.
			{/if}
		</p>
		<div class="result-actions">
			<a class="button" href="/dashboard/garden">View your garden</a>
			<a class="button button--ghost" href="/dashboard/exams/{exam.id}">Back to exam</a>
		</div>
	</div>
{:else}
	<header>
		<a class="back-link" href="/dashboard/exams/{exam.id}">← Back to exam</a>
		<h1 class="page-title">{exam.title}</h1>
		<p class="page-lede">Answer every question, then submit to see your score.</p>
	</header>

	<form onsubmit={handleSubmit}>
		{#each exam.questions as question, i (question.id)}
			<div class="panel question-panel">
				<p class="question-panel__title">{i + 1}. {question.title}</p>
				<div class="question-panel__options">
					{#each question.options as option (option.id)}
						<label class="option-choice">
							<input
								type="radio"
								name={`question-${question.id}`}
								value={option.id}
								checked={answers[question.id] === option.id}
								onchange={() => (answers = { ...answers, [question.id]: option.id })}
							/>
							{option.text}
						</label>
					{/each}
				</div>
			</div>
		{/each}

		{#if submitState === 'error'}
			<p class="form-alert form-alert--error" role="alert">{submitError}</p>
		{/if}

		<button class="button" type="submit" disabled={!allAnswered() || submitState === 'submitting'}>
			{submitState === 'submitting' ? 'Scoring…' : 'Submit answers'}
		</button>
	</form>
{/if}

<style>
	header {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		margin-bottom: 0.5rem;
	}

	.back-link {
		color: var(--tan-400);
		text-decoration: none;
		font-size: 0.8125rem;
	}

	.back-link:hover {
		color: var(--gold-300);
	}

	form {
		display: flex;
		flex-direction: column;
		gap: var(--space-md);
	}

	.question-panel {
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
	}

	.question-panel__title {
		font-weight: 700;
		color: var(--paper-ink);
		margin: 0;
	}

	.question-panel__options {
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
	}

	.option-choice {
		display: flex;
		align-items: center;
		gap: 0.55rem;
		font-size: 0.9375rem;
		color: var(--paper-ink);
		cursor: pointer;
	}

	.option-choice input {
		accent-color: var(--crimson-500);
		width: 1rem;
		height: 1rem;
	}

	.result-panel {
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
		max-width: 28rem;
	}

	.result-score {
		font-family: var(--font-display);
		font-weight: 600;
		font-size: 3rem;
		color: var(--paper-ink);
		margin: 0;
	}

	.result-actions {
		display: flex;
		gap: 0.75rem;
		margin-top: 0.6rem;
		flex-wrap: wrap;
	}
</style>
