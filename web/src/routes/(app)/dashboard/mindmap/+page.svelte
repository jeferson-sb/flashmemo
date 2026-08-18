<script lang="ts">
	import { onMount } from 'svelte';
	import { mindmapsApi, type MindMapGraph, type MindMapListItem } from '$lib/api';
	import MindMapGraphView from '$lib/components/dashboard/MindMapGraph.svelte';

	let mindmaps = $state<MindMapListItem[]>([]);
	let selectedId = $state('');
	let graph = $state<MindMapGraph | null>(null);
	let listState: 'loading' | 'ready' | 'error' = $state('loading');
	let graphState: 'loading' | 'ready' | 'error' = $state('loading');

	async function loadGraph(id: string) {
		if (!id) return;
		graphState = 'loading';
		graph = null;
		try {
			graph = await mindmapsApi.graph(Number(id));
			graphState = 'ready';
		} catch {
			graphState = 'error';
		}
	}

	onMount(async () => {
		try {
			mindmaps = await mindmapsApi.list();
			listState = 'ready';
			if (mindmaps.length > 0) {
				selectedId = String(mindmaps[0].id);
				await loadGraph(selectedId);
			}
		} catch {
			listState = 'error';
		}
	});
</script>

<svelte:head>
	<title>Mind map — Flashmemo</title>
</svelte:head>

<header>
	<h1 class="page-title">Mind map</h1>
	<p class="page-lede">How your categories and exams connect, laid out as a graph you can drag and zoom.</p>
</header>

{#if listState === 'loading'}
	<div class="panel">
		<div class="skeleton-line" style="width: 40%; margin-bottom: 0.6rem;"></div>
		<div class="skeleton-line" style="width: 60%;"></div>
	</div>
{:else if listState === 'error'}
	<p class="form-alert form-alert--error" role="alert">Couldn't load your mind maps. Try refreshing the page.</p>
{:else if mindmaps.length === 0}
	<div class="empty-state">
		<strong>No mind maps yet</strong>
		<p>
			Once one exists, its categories and exams show up here as a graph — forest-green nodes for categories, gold
			nodes for exams, connected by how they relate.
		</p>
	</div>
{:else}
	<div class="panel">
		<div class="panel-head">
			<span class="panel-title">Viewing</span>
			<select
				bind:value={selectedId}
				onchange={() => loadGraph(selectedId)}
				aria-label="Choose a mind map"
			>
				{#each mindmaps as mindmap (mindmap.id)}
					<option value={String(mindmap.id)}>{mindmap.name}</option>
				{/each}
			</select>
		</div>

		<div class="legend" aria-hidden="true">
			<span class="legend-item"><span class="legend-dot legend-dot--category"></span>Category</span>
			<span class="legend-item"><span class="legend-dot legend-dot--exam"></span>Exam</span>
			<span class="legend-item"><span class="legend-line legend-line--relates_to"></span>Relates to</span>
			<span class="legend-item"><span class="legend-line legend-line--in"></span>Belongs in</span>
		</div>

		{#if graphState === 'loading'}
			<div class="skeleton-line" style="width: 100%; height: 32rem;"></div>
		{:else if graphState === 'error'}
			<p class="form-alert form-alert--error" role="alert">Couldn't load this mind map's graph.</p>
		{:else if graph && graph.nodes.length === 0}
			<div class="empty-state">
				<strong>Nothing to draw yet</strong>
				<p>This mind map has no categories or exams connected to it.</p>
			</div>
		{:else if graph}
			<MindMapGraphView nodes={graph.nodes} edges={graph.edges} />
		{/if}
	</div>
{/if}

<style>
	header {
		margin-bottom: var(--space-sm);
	}

	.panel-head select {
		background: var(--paper-100);
		border: 1px solid color-mix(in srgb, var(--paper-ink) 25%, transparent);
		border-radius: var(--radius-card);
		color: var(--paper-ink);
		font-family: var(--font-body);
		font-size: 0.875rem;
		font-weight: 600;
		padding: 0.4rem 0.6rem;
	}

	.legend {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: var(--space-sm);
		margin-bottom: var(--space-xs);
		padding-bottom: var(--space-xs);
		border-bottom: 1px solid color-mix(in srgb, var(--paper-ink) 12%, transparent);
	}

	.legend-item {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		font-size: 0.75rem;
		font-weight: 600;
		color: var(--paper-ink-muted);
	}

	.legend-dot {
		width: 10px;
		height: 10px;
		border-radius: 50%;
		flex-shrink: 0;
	}

	.legend-dot--category {
		background: var(--forest-400);
		border: 2px solid var(--forest-600);
	}

	.legend-dot--exam {
		background: var(--gold-400);
		border: 2px solid var(--crimson-500);
	}

	.legend-line {
		width: 18px;
		height: 0;
		border-top: 2px solid var(--tan-500);
		flex-shrink: 0;
	}

	.legend-line--in {
		border-top-color: var(--gold-500);
		border-top-style: solid;
	}
</style>
