<script lang="ts">
	import { onMount } from 'svelte';
	import { categoriesApi, examsApi, ApiError, type Category, type Difficulty, type ExamListItem } from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	let categories = $state<Category[]>([]);
	let exams = $state<ExamListItem[]>([]);
	let loadState: 'loading' | 'ready' | 'error' = $state('loading');
	let filterCategory = $state('');

	let title = $state('');
	let difficulty = $state<Difficulty>('beginner');
	let categoryId = $state('');
	let createState: 'idle' | 'submitting' | 'error' = $state('idle');
	let createError = $state('');

	function categoryTitle(id: number | null) {
		return categories.find((c) => c.id === id)?.title ?? '—';
	}

	async function loadExams() {
		loadState = 'loading';
		try {
			exams = await examsApi.list(filterCategory || undefined);
			loadState = 'ready';
		} catch {
			loadState = 'error';
		}
	}

	onMount(async () => {
		try {
			categories = await categoriesApi.list();
		} catch {
			// filter/category names simply won't resolve; exam list still loads
		}
		await loadExams();
	});

	async function handleCreate(event: SubmitEvent) {
		event.preventDefault();
		if (!title.trim() || !categoryId) return;
		createState = 'submitting';
		createError = '';
		try {
			await examsApi.create({
				title: title.trim(),
				difficulty,
				version: 1,
				category_id: Number(categoryId)
			});
			title = '';
			createState = 'idle';
			await loadExams();
		} catch (err) {
			createState = 'error';
			createError = err instanceof ApiError ? err.message : 'Could not create that exam.';
		}
	}
</script>

<svelte:head>
	<title>Exams — Flashmemo</title>
</svelte:head>

<header>
	<h1 class="page-title">Exams</h1>
	<p class="page-lede">Collections of questions you'll drill and get scored on.</p>
</header>

<div class="panel">
	<div class="panel-head">
		<span class="panel-title">New exam</span>
	</div>
	{#if categories.length === 0}
		<p class="form-alert form-alert--info">
			You need at least one category before creating an exam — <a href="/dashboard/categories">add one first</a>.
		</p>
	{:else}
		<form class="exam-form" onsubmit={handleCreate}>
			<div class="field">
				<label for="exam-title">Title</label>
				<input id="exam-title" type="text" placeholder="e.g. Cell Biology Basics" required bind:value={title} />
			</div>
			<div class="field">
				<label for="exam-difficulty">Difficulty</label>
				<select id="exam-difficulty" bind:value={difficulty}>
					<option value="beginner">Beginner</option>
					<option value="intermediate">Intermediate</option>
					<option value="advanced">Advanced</option>
				</select>
			</div>
			<div class="field">
				<label for="exam-category">Category</label>
				<select id="exam-category" required bind:value={categoryId}>
					<option value="" disabled selected>Choose one</option>
					{#each categories as category (category.id)}
						<option value={category.id}>{category.title}</option>
					{/each}
				</select>
			</div>
			<button class="button" type="submit" disabled={createState === 'submitting'}>
				{createState === 'submitting' ? 'Creating…' : 'Create exam'}
			</button>
		</form>
		{#if createState === 'error'}
			<p class="field-error">{createError}</p>
		{/if}
	{/if}
</div>

{#if categories.length > 0}
	<div class="filter-row">
		<label class="filter-label" for="filter-category">Filter by category</label>
		<select id="filter-category" bind:value={filterCategory} onchange={loadExams}>
			<option value="">All categories</option>
			{#each categories as category (category.id)}
				<option value={category.title}>{category.title}</option>
			{/each}
		</select>
	</div>
{/if}

{#if loadState === 'loading'}
	<div class="panel">
		<div class="skeleton-line" style="width: 60%; margin-bottom: 0.6rem;"></div>
		<div class="skeleton-line" style="width: 40%;"></div>
	</div>
{:else if loadState === 'error'}
	<p class="form-alert form-alert--error" role="alert">Couldn't load exams. Try refreshing the page.</p>
{:else if exams.length === 0}
	<div class="empty-state">
		<strong>No exams yet</strong>
		<p>Create one above, then add questions to it from the exam page.</p>
	</div>
{:else}
	<div class="panel">
		<table class="ledger-table">
			<thead>
				<tr>
					<th scope="col">Title</th>
					<th scope="col">Category</th>
					<th scope="col">Difficulty</th>
				</tr>
			</thead>
			<tbody>
				{#each exams as exam (exam.id)}
					<tr>
						<th scope="row">
							<a href="/dashboard/exams/{exam.id}">{exam.title}</a>
							{#if exam.user_id === auth.user?.id}
								<span class="owner-tag">Yours</span>
							{/if}
						</th>
						<td>{categoryTitle(exam.category_id)}</td>
						<td><span class="badge badge--{exam.difficulty}">{exam.difficulty}</span></td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
{/if}

<style>
	header {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.exam-form {
		display: flex;
		gap: 0.75rem;
		align-items: flex-end;
		flex-wrap: wrap;
	}

	.exam-form .field {
		flex: 1 1 12rem;
	}

	.filter-row {
		display: flex;
		align-items: center;
		gap: 0.6rem;
	}

	/* Exams from every user share one list, so yours are marked. */
	.owner-tag {
		margin-inline-start: 0.4rem;
		font-size: 0.6875rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.04em;
		color: var(--paper-ink-muted);
		border: 1px solid color-mix(in srgb, var(--paper-ink) 22%, transparent);
		border-radius: 999px;
		padding: 0.05rem 0.4rem;
		white-space: nowrap;
	}

	.filter-label {
		font-size: 0.8125rem;
		font-weight: 600;
		color: var(--tan-300);
	}

	.filter-row select {
		background: var(--paper-200);
		color: var(--paper-ink);
		border: 1px solid var(--paper-300);
		border-radius: var(--radius-card);
		padding: 0.4rem 0.65rem;
		font-size: 0.875rem;
	}

	.ledger-table a {
		color: inherit;
		text-decoration: none;
	}

	.ledger-table a:hover {
		text-decoration: underline;
	}
</style>
