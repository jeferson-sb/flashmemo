<script lang="ts">
	import { onMount } from 'svelte';
	import Seed from '$lib/icons/Seed.svelte';
	import Sprout from '$lib/icons/Sprout.svelte';
	import { gardensApi, ApiError, type GardenDetail } from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	type Phase = 'loading' | 'none' | 'ready' | 'error';

	let phase: Phase = $state('loading');
	let garden = $state<GardenDetail | null>(null);
	let creating = $state(false);

	let plantName = $state('');
	let plantState: 'idle' | 'submitting' | 'error' = $state('idle');
	let plantError = $state('');

	let nurtureAmounts = $state<Record<number, number>>({});
	let nurtureState = $state<Record<number, 'idle' | 'submitting' | 'error'>>({});
	let nurtureErrors = $state<Record<number, string>>({});

	async function load() {
		phase = 'loading';
		try {
			const gardens = await gardensApi.list();
			const mine = gardens.find((g) => g.user_id === auth.user?.id);
			if (!mine) {
				phase = 'none';
				return;
			}
			garden = await gardensApi.get(mine.id);
			phase = 'ready';
		} catch {
			phase = 'error';
		}
	}

	onMount(load);

	async function handleCreateGarden() {
		creating = true;
		try {
			await gardensApi.create();
			await load();
		} catch {
			phase = 'error';
		}
		creating = false;
	}

	async function handlePlant(event: SubmitEvent) {
		event.preventDefault();
		if (!garden || !plantName.trim()) return;
		plantState = 'submitting';
		plantError = '';
		try {
			await gardensApi.plant(garden.id, plantName.trim());
			plantName = '';
			plantState = 'idle';
			await load();
		} catch (err) {
			plantState = 'error';
			plantError = err instanceof ApiError ? err.message : 'Could not plant that tree.';
		}
	}

	async function handleNurture(treeId: number) {
		if (!garden) return;
		const amount = nurtureAmounts[treeId] ?? 10;
		nurtureState = { ...nurtureState, [treeId]: 'submitting' };
		try {
			await gardensApi.nurture(garden.id, treeId, amount);
			nurtureState = { ...nurtureState, [treeId]: 'idle' };
			await load();
		} catch (err) {
			nurtureState = { ...nurtureState, [treeId]: 'error' };
			nurtureErrors = {
				...nurtureErrors,
				[treeId]: err instanceof ApiError ? err.message : 'Could not feed that tree.'
			};
		}
	}
</script>

<svelte:head>
	<title>Garden — Flashmemo</title>
</svelte:head>

<header>
	<h1 class="page-title">Your garden</h1>
	<p class="page-lede">Seeds and nutrients earned from studying, spent here on trees you can watch grow.</p>
</header>

{#if phase === 'loading'}
	<div class="panel">
		<div class="skeleton-line" style="width: 40%; margin-bottom: 0.6rem;"></div>
		<div class="skeleton-line" style="width: 60%;"></div>
	</div>
{:else if phase === 'error'}
	<p class="form-alert form-alert--error" role="alert">Couldn't load your garden. Try refreshing the page.</p>
{:else if phase === 'none'}
	<div class="empty-state">
		<strong>You don't have a garden yet</strong>
		<p>Every account gets one — create yours to start planting trees with seeds you earn.</p>
		<button class="button" onclick={handleCreateGarden} disabled={creating}>
			{creating ? 'Planting the plot…' : 'Create my garden'}
		</button>
	</div>
{:else if garden}
	<div class="stat-row">
		<div class="panel stat-tile">
			<Seed size={20} />
			<span class="stat-tile__value">{garden.bucket_seeds}</span>
			<span class="stat-tile__label">seeds</span>
		</div>
		<div class="panel stat-tile">
			<Sprout size={20} />
			<span class="stat-tile__value">{garden.nutrients}</span>
			<span class="stat-tile__label">nutrients</span>
		</div>
		<div class="panel stat-tile">
			<span class="stat-tile__value">{garden.trees.length}</span>
			<span class="stat-tile__label">tree{garden.trees.length === 1 ? '' : 's'}</span>
		</div>
	</div>

	<div class="panel">
		<div class="panel-head">
			<span class="panel-title">Plant a tree</span>
			<span class="panel-hint">Costs 1 seed</span>
		</div>
		<form class="inline-form" onsubmit={handlePlant}>
			<div class="field">
				<label class="visually-hidden" for="tree-name">Tree name</label>
				<input id="tree-name" type="text" placeholder="Name this tree" required bind:value={plantName} />
			</div>
			<button class="button" type="submit" disabled={plantState === 'submitting' || garden.bucket_seeds <= 0}>
				{plantState === 'submitting' ? 'Planting…' : 'Plant tree'}
			</button>
		</form>
		{#if garden.bucket_seeds <= 0}
			<p class="panel-hint">Earn seeds by taking an exam before you can plant.</p>
		{/if}
		{#if plantState === 'error'}
			<p class="field-error">{plantError}</p>
		{/if}
	</div>

	{#if garden.trees.length === 0}
		<div class="empty-state">
			<strong>No trees planted yet</strong>
			<p>Plant your first one above once you've earned a seed.</p>
		</div>
	{:else}
		<div class="tree-grid">
			{#each garden.trees as tree (tree.id)}
				<div class="panel tree-card">
					<div class="tree-card__head">
						<span class="tree-card__name">{tree.name}</span>
						<span class="badge badge--{tree.phase}">{tree.phase}</span>
					</div>
					<div class="health-bar" role="img" aria-label={`Health ${tree.health}%`}>
						<span class="health-bar__fill" style={`--h:${tree.health}%`}></span>
					</div>
					<span class="tree-card__health">{tree.health}% health</span>

					<div class="nurture-row">
						<input
							type="number"
							min="1"
							max="100"
							value={nurtureAmounts[tree.id] ?? 10}
							oninput={(e) =>
								(nurtureAmounts = { ...nurtureAmounts, [tree.id]: Number(e.currentTarget.value) })}
							aria-label={`Nutrients to feed ${tree.name}`}
						/>
						<button
							class="button button--ghost button--small"
							type="button"
							onclick={() => handleNurture(tree.id)}
							disabled={nurtureState[tree.id] === 'submitting' || tree.health >= 100 || garden.nutrients <= 0}
						>
							{nurtureState[tree.id] === 'submitting' ? 'Feeding…' : 'Feed'}
						</button>
					</div>
					{#if nurtureState[tree.id] === 'error'}
						<p class="field-error">{nurtureErrors[tree.id]}</p>
					{/if}
				</div>
			{/each}
		</div>
	{/if}
{/if}

<style>
	header {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.stat-row {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: var(--space-sm);
	}

	.stat-tile {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.2rem;
	}

	.stat-tile__value {
		font-family: var(--font-display);
		font-weight: 600;
		font-size: 1.75rem;
		color: var(--paper-ink);
	}

	.stat-tile__label {
		font-size: 0.8125rem;
		color: var(--paper-ink-muted);
	}

	.panel-hint {
		font-size: 0.8125rem;
		color: var(--paper-ink-muted);
		margin-top: 0.4rem;
	}

	.inline-form {
		display: flex;
		gap: 0.75rem;
		align-items: flex-end;
		flex-wrap: wrap;
	}

	.inline-form .field {
		flex: 1 1 14rem;
	}

	.tree-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
		gap: var(--space-sm);
	}

	.tree-card {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.tree-card__head {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tree-card__name {
		font-weight: 700;
		color: var(--paper-ink);
	}

	.health-bar {
		height: 6px;
		border-radius: 999px;
		background: color-mix(in srgb, var(--paper-ink) 12%, transparent);
		overflow: hidden;
	}

	.health-bar__fill {
		display: block;
		height: 100%;
		width: var(--h);
		background: var(--forest-500);
	}

	.tree-card__health {
		font-size: 0.75rem;
		color: var(--paper-ink-muted);
	}

	.nurture-row {
		display: flex;
		gap: 0.5rem;
		margin-top: 0.3rem;
	}

	.nurture-row input {
		width: 4.5rem;
		background: var(--paper-100);
		color: var(--paper-ink);
		border: 1px solid var(--paper-300);
		border-radius: var(--radius-card);
		padding: 0.4rem 0.5rem;
		font-size: 0.875rem;
	}

	@media (max-width: 640px) {
		.stat-row {
			grid-template-columns: 1fr 1fr;
		}
	}
</style>
