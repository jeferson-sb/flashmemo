<script lang="ts">
	import { goto } from '$app/navigation';
	import Mark from '$lib/icons/Mark.svelte';
	import { authApi, ApiError } from '$lib/api';
	import { auth } from '$lib/stores/auth.svelte';

	let name = $state('');
	let username = $state('');
	let email = $state('');
	let password = $state('');
	let status: 'idle' | 'submitting' | 'error' = $state('idle');
	let errorMessage = $state('');

	async function handleSubmit(event: SubmitEvent) {
		event.preventDefault();
		status = 'submitting';
		errorMessage = '';
		try {
			const { token } = await authApi.signup({ name, username, email, password });
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
	<title>Create an account — Flashmemo</title>
</svelte:head>

<main class="auth-screen">
	<div class="auth-card panel">
		<a class="auth-brand" href="/">
			<Mark size={24} tone="light" />
			<span>Flashmemo</span>
		</a>

		<h1 class="page-title">Start your garden</h1>
		<p class="page-lede">Create an account — your first plot opens the moment you answer a question.</p>

		{#if status === 'error'}
			<p class="form-alert form-alert--error" role="alert">{errorMessage}</p>
		{/if}

		<form onsubmit={handleSubmit}>
			<div class="field">
				<label for="name">Name</label>
				<input id="name" type="text" name="name" autocomplete="name" required bind:value={name} />
			</div>
			<div class="field">
				<label for="username">Username</label>
				<input
					id="username"
					type="text"
					name="username"
					autocomplete="username"
					required
					bind:value={username}
				/>
			</div>
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
					autocomplete="new-password"
					minlength="6"
					required
					bind:value={password}
				/>
				<span class="field-hint">At least 6 characters.</span>
			</div>
			<button class="button" type="submit" disabled={status === 'submitting'}>
				{status === 'submitting' ? 'Planting…' : 'Create account'}
			</button>
		</form>

		<p class="auth-switch">Already have a garden? <a href="/login">Sign in</a></p>
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

	.field-hint {
		font-size: 0.75rem;
		color: var(--paper-ink-muted);
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
