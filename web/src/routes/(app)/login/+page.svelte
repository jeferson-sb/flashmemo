<script lang="ts">
	import { goto } from '$app/navigation';
	import Mark from '$lib/icons/Mark.svelte';
	import { authApi, ApiError } from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	let email = $state('');
	let password = $state('');
	let status: 'idle' | 'submitting' | 'error' = $state('idle');
	let errorMessage = $state('');

	async function handleSubmit(event: SubmitEvent) {
		event.preventDefault();
		status = 'submitting';
		errorMessage = '';
		try {
			const { token } = await authApi.login(email, password);
			auth.setToken(token);
			auth.setUser(await authApi.me());
			await goto('/dashboard');
		} catch (err) {
			status = 'error';
			errorMessage = err instanceof ApiError ? err.message : 'Something went wrong. Please try again.';
			return;
		}
		status = 'idle';
	}
</script>

<svelte:head>
	<title>Sign in — Flashmemo</title>
</svelte:head>

<main class="auth-screen">
	<div class="auth-card panel">
		<a class="auth-brand" href="/">
			<Mark size={24} />
			<span>Flashmemo</span>
		</a>

		<h1 class="page-title">Welcome back</h1>
		<p class="page-lede">Sign in to pick up your garden where you left it.</p>

		{#if status === 'error'}
			<p class="form-alert form-alert--error" role="alert">{errorMessage}</p>
		{/if}

		<form onsubmit={handleSubmit}>
			<div class="field">
				<label for="email">Email</label>
				<input id="email" type="email" name="email" autocomplete="email" required bind:value={email} />
			</div>
			<div class="field">
				<label for="password">Password</label>
				<input
					id="password"
					type="password"
					name="password"
					autocomplete="current-password"
					required
					bind:value={password}
				/>
			</div>
			<button class="button" type="submit" disabled={status === 'submitting'}>
				{status === 'submitting' ? 'Signing in…' : 'Sign in'}
			</button>
		</form>

		<p class="auth-switch">New here? <a href="/signup">Create an account</a></p>
	</div>
</main>

<style>
	.auth-screen {
		min-height: 100vh;
		display: flex;
		align-items: center;
		justify-content: center;
		background: var(--ink-800);
		padding: var(--space-md);
	}

	.auth-card {
		width: 100%;
		max-width: 24rem;
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
	}

	.auth-brand {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		color: var(--paper-ink);
		text-decoration: none;
		font-family: var(--font-display);
		font-weight: 600;
		font-size: 1.1rem;
		margin-bottom: 0.25rem;
	}

	form {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
		margin-top: 0.25rem;
	}

	.auth-switch {
		font-size: 0.875rem;
		color: var(--paper-ink-muted);
	}

	.auth-switch a {
		color: var(--crimson-500);
		font-weight: 600;
		text-decoration: none;
	}

	.auth-switch a:hover {
		text-decoration: underline;
	}
</style>
