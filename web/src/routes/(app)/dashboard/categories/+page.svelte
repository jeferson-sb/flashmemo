<script lang="ts">
	import { onMount } from 'svelte';
	import { categoriesApi, ApiError, type Category } from '$lib/api';
	import { formatDate } from '$lib/utils/format';

	let categories = $state<Category[]>([]);
	let loadState: 'loading' | 'ready' | 'error' = $state('loading');

	let title = $state('');
	let createState: 'idle' | 'submitting' | 'error' = $state('idle');
	let createError = $state('');

	async function load() {
		loadState = 'loading';
		try {
			categories = await categoriesApi.list();
			loadState = 'ready';
		} catch {
			loadState = 'error';
		}
	}

	onMount(load);

	async function handleCreate(event: SubmitEvent) {
		event.preventDefault();
		if (!title.trim()) return;
		createState = 'submitting';
		createError = '';
		try {
			await categoriesApi.create(title.trim());
			title = '';
			createState = 'idle';
			await load();
		} catch (err) {
			createState = 'error';
			createError = err instanceof ApiError ? err.message : 'Could not create that category.';
		}
	}
</script>

<svelte:head>
	<title>Categories — Flashmemo</title>
</svelte:head>

<header>
	<h1 class="page-title">Categories</h1>
	<p class="page-lede">The subjects your exams get filed under — biology, history, whatever you're studying.</p>
</header>

<div class="panel">
	<div class="panel-head">
		<span class="panel-title">New category</span>
	</div>
	<form class="inline-form" onsubmit={handleCreate}>
		<div class="field">
			<label class="visually-hidden" for="title">Title</label>
			<input id="title" type="text" placeholder="e.g. Biology" required bind:value={title} />
		</div>
		<button class="button" type="submit" disabled={createState === 'submitting'}>
			{createState === 'submitting' ? 'Adding…' : 'Add category'}
		</button>
	</form>
	{#if createState === 'error'}
		<p class="field-error">{createError}</p>
	{/if}
</div>

{#if loadState === 'loading'}
	<div class="panel">
		<div class="skeleton-line" style="width: 60%; margin-bottom: 0.6rem;"></div>
		<div class="skeleton-line" style="width: 40%;"></div>
	</div>
{:else if loadState === 'error'}
	<p class="form-alert form-alert--error" role="alert">Couldn't load categories. Try refreshing the page.</p>
{:else if categories.length === 0}
	<div class="empty-state">
		<strong>No categories yet</strong>
		<p>Add your first one above — exams get organized underneath it.</p>
	</div>
{:else}
	<div class="panel">
		<table class="ledger-table">
			<thead>
				<tr>
					<th scope="col">Title</th>
					<th scope="col">Added</th>
				</tr>
			</thead>
			<tbody>
				{#each categories as category (category.id)}
					<tr>
						<th scope="row">{category.title}</th>
						<td>{formatDate(category.created_at)}</td>
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

	.inline-form {
		display: flex;
		gap: 0.75rem;
		align-items: flex-end;
		flex-wrap: wrap;
	}

	.inline-form .field {
		flex: 1 1 16rem;
	}
</style>
