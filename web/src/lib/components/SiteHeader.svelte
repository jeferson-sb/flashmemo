<script lang="ts">
	import Mark from '$lib/icons/Mark.svelte';

	let menuOpen = $state(false);

	const links = [
		{ href: '#how-it-grows', label: 'How it grows' },
		{ href: '#almanac', label: "This year's almanac" },
		{ href: '#seasons', label: 'Your seasons' }
	];
</script>

<header class="header">
	<div class="header__inner">
		<a class="brand" href="#top">
			<Mark size={26} />
			<span class="brand__word">Flashmemo</span>
		</a>

		<nav class="nav" aria-label="Primary">
			{#each links as link (link.href)}
				<a href={link.href}>{link.label}</a>
			{/each}
		</nav>

		<div class="header__actions">
			<a class="link-cta" href="/login">Sign in</a>
			<a class="button button--small" href="/signup">Start your garden</a>
		</div>

		<button
			class="menu-toggle"
			class:is-open={menuOpen}
			aria-expanded={menuOpen}
			aria-controls="mobile-nav"
			onclick={() => (menuOpen = !menuOpen)}
		>
			<span class="visually-hidden">Toggle menu</span>
			<span class="menu-toggle__bar"></span>
			<span class="menu-toggle__bar"></span>
		</button>
	</div>

	{#if menuOpen}
		<nav id="mobile-nav" class="mobile-nav" aria-label="Primary">
			{#each links as link (link.href)}
				<a href={link.href} onclick={() => (menuOpen = false)}>{link.label}</a>
			{/each}
			<a class="button" href="/signup" onclick={() => (menuOpen = false)}>Start your garden</a>
		</nav>
	{/if}
</header>

<style>
	.header {
		position: sticky;
		top: 0;
		z-index: 40;
		background: color-mix(in srgb, var(--ink-800) 88%, transparent);
		backdrop-filter: blur(10px) saturate(1.1);
		border-bottom: 1px solid color-mix(in srgb, var(--gold-500) 18%, transparent);
	}

	.header__inner {
		max-width: var(--content-width);
		margin-inline: auto;
		padding: var(--space-xs) var(--edge);
		display: flex;
		align-items: center;
		gap: var(--space-lg);
	}

	.brand {
		display: flex;
		align-items: center;
		gap: var(--space-2xs);
		color: var(--cream-100);
		text-decoration: none;
		flex-shrink: 0;
	}

	.brand__word {
		font-family: var(--font-display);
		font-weight: 600;
		font-size: var(--text-lg);
		letter-spacing: -0.01em;
	}

	.nav {
		display: flex;
		gap: var(--space-md);
		margin-inline-end: auto;
	}

	.nav a {
		font-size: var(--text-sm);
		color: var(--tan-300);
		text-decoration: none;
		white-space: nowrap;
	}

	.nav a:hover {
		color: var(--gold-300);
	}

	.header__actions {
		display: flex;
		align-items: center;
		gap: var(--space-sm);
		flex-shrink: 0;
	}

	.link-cta {
		font-size: var(--text-sm);
		color: var(--tan-300);
		text-decoration: none;
		white-space: nowrap;
	}

	.link-cta:hover {
		color: var(--gold-300);
	}

	.menu-toggle {
		display: none;
		background: none;
		border: none;
		padding: var(--space-2xs);
		cursor: pointer;
		flex-direction: column;
		gap: 5px;
	}

	.menu-toggle__bar {
		width: 22px;
		height: 2px;
		background: var(--cream-200);
		border-radius: 2px;
		transform-origin: center;
		transition:
			transform var(--duration-fast) var(--ease-out-expo),
			opacity var(--duration-fast) var(--ease-out-expo);
	}

	.menu-toggle.is-open .menu-toggle__bar:first-child {
		transform: translateY(3.5px) rotate(45deg);
	}

	.menu-toggle.is-open .menu-toggle__bar:last-child {
		transform: translateY(-3.5px) rotate(-45deg);
	}

	.mobile-nav {
		display: none;
	}

	@media (max-width: 860px) {
		.nav,
		.header__actions {
			display: none;
		}

		.menu-toggle {
			display: flex;
			margin-inline-start: auto;
		}

		.mobile-nav {
			display: flex;
			flex-direction: column;
			gap: var(--space-sm);
			padding: var(--space-md) var(--edge) var(--space-lg);
			border-top: 1px solid color-mix(in srgb, var(--gold-500) 18%, transparent);
		}

		.mobile-nav a {
			color: var(--tan-300);
			text-decoration: none;
			font-size: var(--text-base);
		}
	}
</style>
