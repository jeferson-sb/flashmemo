<script lang="ts">
	import { page } from '$app/state';

	let { onnavigate }: { onnavigate?: () => void } = $props();

	const links = [
		{ href: '/dashboard', label: 'Overview', exact: true },
		{ href: '/dashboard/categories', label: 'Categories' },
		{ href: '/dashboard/exams', label: 'Exams' },
		{ href: '/dashboard/garden', label: 'Garden' },
		{ href: '/dashboard/progress', label: 'Progress' },
		{ href: '/dashboard/mindmap', label: 'Mind map' }
	];

	function isActive(href: string, exact?: boolean) {
		return exact ? page.url.pathname === href : page.url.pathname.startsWith(href);
	}
</script>

<nav class="dash-nav" aria-label="Dashboard">
	{#each links as link (link.href)}
		<a
			href={link.href}
			class="dash-nav__item"
			aria-current={isActive(link.href, link.exact) ? 'page' : undefined}
			onclick={onnavigate}
		>
			{link.label}
		</a>
	{/each}
</nav>

<style>
	.dash-nav {
		display: flex;
		flex-direction: column;
		gap: 0.15rem;
	}

	.dash-nav__item {
		padding: 0.55rem 0.85rem;
		border-radius: var(--radius-card);
		color: var(--tan-300);
		text-decoration: none;
		font-size: 0.875rem;
		font-weight: 600;
	}

	.dash-nav__item:hover {
		background: color-mix(in srgb, var(--gold-500) 10%, transparent);
		color: var(--cream-100);
	}

	.dash-nav__item[aria-current='page'] {
		background: color-mix(in srgb, var(--crimson-500) 18%, transparent);
		color: var(--cream-100);
	}
</style>
