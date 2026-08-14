import { browser } from '$app/environment';
import { ApiError, authApi } from '$lib/api';
import { auth } from './auth.svelte';
import type { SessionUser } from '$lib/api/types';

// Lives outside auth.svelte.ts on purpose: the API client imports the auth
// store for the bearer token, so the store itself cannot import the client.

let pending: Promise<SessionUser | null> | null = null;

/**
 * Resolve the signed-in user from the stored token, at most once per page
 * load. Returns null when there is no token, or when the token turned out to
 * be invalid (in which case the stored token is dropped).
 */
export function ensureSession(): Promise<SessionUser | null> {
	if (!browser || !auth.token) return Promise.resolve(null);
	if (auth.user) return Promise.resolve(auth.user);

	pending ??= authApi
		.me()
		.then((user) => {
			auth.setUser(user);
			return user;
		})
		.catch((err) => {
			// Only a rejected token means "signed out" — a network blip should
			// not throw away a session that is still perfectly valid.
			if (err instanceof ApiError && err.status === 401) auth.clear();
			return null;
		})
		.finally(() => {
			pending = null;
		});

	return pending;
}
