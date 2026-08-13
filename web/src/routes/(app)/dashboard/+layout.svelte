<script lang="ts">
	import { goto } from '$app/navigation';
	import Mark from '$lib/icons/Mark.svelte';
	import DashboardNav from '$lib/components/dashboard/DashboardNav.svelte';
	import { authApi } from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	let { children } = $props();
	let ready = $state(false);
	let menuOpen = $state(false);

	$effect(() => {
		if (!auth.token) {
			goto('/login');
			return;
		}
		if (auth.user) {
			ready = true;
			return;
		}
		authApi
			.me()
			.then((user) => {
				auth.setUser(user);
				ready = true;
			})
			.catch(() => {
				auth.clear();
				goto('/login');
			});
	});

	async function handleLogout() {
		try {
			await authApi.logout();
		} catch {
			// token may already be invalid server-side — clear locally regardless
		}
		auth.clear();
		goto('/login');
	}
</script>

<svelte:head>
	<title>Dashboard — Flashmemo</title>
</svelte:head>

{#if ready}
	<div class="app-shell">
		<aside class="dash-sidebar" class:is-open={menuOpen}>
			<div class="dash-sidebar__top">
				<a class="dash-brand" href="/">
					<Mark size={24} />
					<span>Flashmemo</span>
				</a>
				<button
					class="menu-toggle"
					class:is-open={menuOpen}
					aria-expanded={menuOpen}
					aria-controls="dash-nav-panel"
					onclick={() => (menuOpen = !menuOpen)}
				>
					<span class="visually-hidden">Toggle menu</span>
					<span class="menu-toggle__bar"></span>
					<span class="menu-toggle__bar"></span>
				</button>
			</div>

			<div class="dash-sidebar__body" id="dash-nav-panel">
				<DashboardNav onnavigate={() => (menuOpen = false)} />
				<div class="dash-sidebar__footer">
					<div class="dash-user">
						<span class="dash-user__name">{auth.user?.name}</span>
						<span class="dash-user__email">{auth.user?.email}</span>
					</div>
					<button class="button button--ghost button--small" onclick={handleLogout}>Log out</button>
				</div>
			</div>
		</aside>

		<main class="app-main">
			<div class="app-main__inner">
				{@render children()}
			</div>
		</main>
	</div>
{:else}
	<div class="dash-loading" aria-busy="true">
		<div class="skeleton-line" style="width: 8rem; height: 1.4rem;"></div>
	</div>
{/if}

<style>
	.dash-sidebar {
		flex: 0 0 15rem;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		padding: var(--space-md) var(--space-sm) var(--space-md) var(--edge);
		border-right: 1px solid color-mix(in srgb, var(--gold-500) 16%, transparent);
	}

	.dash-sidebar__top {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.dash-sidebar__body {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		flex: 1;
		min-height: 0;
	}

	.dash-brand {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		color: var(--cream-100);
		text-decoration: none;
		font-family: var(--font-display);
		font-weight: 600;
		font-size: 1.1rem;
		margin-bottom: var(--space-md);
	}

	.dash-sidebar__footer {
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
		padding-top: var(--space-sm);
		border-top: 1px solid color-mix(in srgb, var(--gold-500) 16%, transparent);
	}

	.dash-user {
		display: flex;
		flex-direction: column;
		line-height: 1.3;
	}

	.dash-user__name {
		color: var(--cream-100);
		font-weight: 600;
		font-size: 0.875rem;
	}

	.dash-user__email {
		color: var(--tan-500);
		font-size: 0.75rem;
	}

	.dash-loading {
		min-height: 100vh;
		display: flex;
		align-items: center;
		justify-content: center;
		background: var(--ink-800);
	}

	.menu-toggle {
		display: none;
		background: none;
		border: none;
		padding: 0.4rem;
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

	@media (max-width: 860px) {
		.app-shell {
			flex-direction: column;
		}

		.dash-sidebar {
			flex: none;
			padding: 0.75rem 1rem;
			border-right: none;
			border-bottom: 1px solid color-mix(in srgb, var(--gold-500) 16%, transparent);
		}

		.dash-brand {
			margin-bottom: 0;
		}

		.menu-toggle {
			display: flex;
		}

		.dash-sidebar__body {
			display: none;
		}

		.dash-sidebar.is-open .dash-sidebar__body {
			display: flex;
			margin-top: 0.75rem;
		}

		.dash-sidebar__footer {
			flex-direction: row;
			align-items: center;
			justify-content: space-between;
		}
	}
</style>
