<script lang="ts">
	import { onMount } from 'svelte';
	import { usersApi, examsApi, ApiError, type PeriodFilter, type ExamListItem } from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	const periods: { value: PeriodFilter; label: string }[] = [
		{ value: 'all', label: 'All time' },
		{ value: 'monthly', label: 'Last 30 days' },
		{ value: 'semester', label: 'This semester' },
		{ value: 'yearly', label: 'This year' }
	];

	let period = $state<PeriodFilter>('all');
	let phase: 'loading' | 'ready' | 'empty' | 'error' = $state('loading');
	let average = $state(0);
	let examTitles = $state<string[]>([]);

	async function load() {
		phase = 'loading';
		try {
			const result = await usersApi.progress(auth.user!.id, period);
			average = result.average;
			try {
				const allExams: ExamListItem[] = await examsApi.list();
				const byId = new Map(allExams.map((e) => [e.id, e.title]));
				examTitles = result.exams.map((id) => byId.get(id) ?? `Exam #${id}`);
			} catch {
				examTitles = result.exams.map((id) => `Exam #${id}`);
			}
			phase = 'ready';
		} catch (err) {
			phase = err instanceof ApiError && err.status === 404 ? 'empty' : 'error';
		}
	}

	onMount(load);
</script>

<svelte:head>
	<title>Progress — Flashmemo</title>
</svelte:head>

<header>
	<h1 class="page-title">Your progress</h1>
	<p class="page-lede">Average score across the exams you've attempted, by period.</p>
</header>

<div class="period-tabs" role="tablist" aria-label="Time period">
	{#each periods as p (p.value)}
		<button
			role="tab"
			aria-selected={period === p.value}
			class="period-tab"
			class:is-active={period === p.value}
			onclick={() => {
				period = p.value;
				load();
			}}
		>
			{p.label}
		</button>
	{/each}
</div>

{#if phase === 'loading'}
	<div class="panel">
		<div class="skeleton-line" style="width: 30%; margin-bottom: 0.6rem;"></div>
		<div class="skeleton-line" style="width: 50%;"></div>
	</div>
{:else if phase === 'error'}
	<p class="form-alert form-alert--error" role="alert">Couldn't load your progress. Try refreshing the page.</p>
{:else if phase === 'empty'}
	<div class="empty-state">
		<strong>No answers in this period yet</strong>
		<p>Take an exam to start building your progress history.</p>
	</div>
{:else}
	<div class="panel score-panel">
		<span class="panel-title">Average score</span>
		<p class="score-value">{average}%</p>
	</div>

	<div class="panel">
		<div class="panel-head">
			<span class="panel-title">Exams attempted</span>
		</div>
		<ul class="exam-list">
			{#each examTitles as title (title)}
				<li>{title}</li>
			{/each}
		</ul>
	</div>
{/if}

<style>
	header {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.period-tabs {
		display: flex;
		gap: 0.4rem;
		flex-wrap: wrap;
	}

	.period-tab {
		background: transparent;
		border: 1px solid color-mix(in srgb, var(--tan-500) 35%, transparent);
		color: var(--tan-300);
		border-radius: 999px;
		padding: 0.4rem 0.9rem;
		font-size: 0.8125rem;
		font-weight: 600;
		cursor: pointer;
	}

	.period-tab:hover {
		color: var(--cream-100);
	}

	.period-tab.is-active {
		background: color-mix(in srgb, var(--crimson-500) 22%, transparent);
		border-color: color-mix(in srgb, var(--crimson-500) 55%, transparent);
		color: var(--cream-100);
	}

	.score-panel {
		max-width: 16rem;
	}

	.score-value {
		font-family: var(--font-display);
		font-weight: 600;
		font-size: 2.5rem;
		color: var(--paper-ink);
		margin: 0.2rem 0 0;
	}

	.exam-list {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
		color: var(--paper-ink);
		font-size: 0.9375rem;
	}

	.exam-list li {
		padding-block: 0.35rem;
		border-bottom: 1px dashed color-mix(in srgb, var(--paper-ink) 18%, transparent);
	}

	.exam-list li:last-child {
		border-bottom: none;
	}
</style>
