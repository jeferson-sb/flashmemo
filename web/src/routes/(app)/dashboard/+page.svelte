<script lang="ts">
	import { onMount } from 'svelte';
	import Seed from '$lib/icons/Seed.svelte';
	import { gardensApi, usersApi, ApiError } from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	let seeds = $state<number | null>(null);
	let treeCount = $state<number | null>(null);
	let average = $state<number | null>(null);
	let hasAnswers = $state(true);

	onMount(async () => {
		try {
			const gardens = await gardensApi.list();
			const mine = gardens.find((g) => g.user_id === auth.user?.id);
			if (mine) {
				seeds = mine.bucket_seeds;
				treeCount = mine.trees;
			}
		} catch {
			// garden summary is optional on this page — the garden page has its own error state
		}

		try {
			const progress = await usersApi.progress(auth.user!.id, 'all');
			average = progress.average;
		} catch (err) {
			hasAnswers = !(err instanceof ApiError && err.status === 404);
		}
	});

	const quickLinks = [
		{ href: '/dashboard/categories', label: 'Categories', desc: 'Organize your subjects' },
		{ href: '/dashboard/exams', label: 'Exams', desc: 'Build and take exams' },
		{ href: '/dashboard/garden', label: 'Garden', desc: 'Plant and nurture trees' },
		{ href: '/dashboard/progress', label: 'Progress', desc: 'See your average by period' }
	];
</script>

<svelte:head>
	<title>Overview — Flashmemo</title>
</svelte:head>

<header>
	<h1 class="page-title">Welcome back{auth.user ? `, ${auth.user.name}` : ''}</h1>
	<p class="page-lede">Here's where your garden and your study season stand.</p>
</header>

<div class="stat-row">
	<div class="panel stat-tile">
		<Seed size={20} />
		<span class="stat-tile__value">{seeds ?? '—'}</span>
		<span class="stat-tile__label">seeds in your garden</span>
	</div>
	<div class="panel stat-tile">
		<span class="stat-tile__value">{treeCount ?? '—'}</span>
		<span class="stat-tile__label">trees planted</span>
	</div>
	<div class="panel stat-tile">
		<span class="stat-tile__value">{hasAnswers && average !== null ? `${average}%` : '—'}</span>
		<span class="stat-tile__label">average score</span>
	</div>
</div>

<div class="quick-links">
	{#each quickLinks as link (link.href)}
		<a class="panel quick-link" href={link.href}>
			<span class="quick-link__label">{link.label}</span>
			<span class="quick-link__desc">{link.desc}</span>
		</a>
	{/each}
</div>

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

	.quick-links {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(13rem, 1fr));
		gap: var(--space-sm);
	}

	.quick-link {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
		text-decoration: none;
		transition: transform 150ms ease;
	}

	.quick-link:hover {
		transform: translateY(-2px);
	}

	.quick-link__label {
		font-weight: 700;
		color: var(--paper-ink);
	}

	.quick-link__desc {
		font-size: 0.8125rem;
		color: var(--paper-ink-muted);
	}

	@media (max-width: 640px) {
		.stat-row {
			grid-template-columns: 1fr 1fr;
		}
	}
</style>
