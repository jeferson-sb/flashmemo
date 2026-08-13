import { browser } from '$app/environment';
import type { SessionUser } from '$lib/api/types';

const TOKEN_KEY = 'flashmemo:token';

function readStoredToken(): string | null {
	if (!browser) return null;
	return localStorage.getItem(TOKEN_KEY);
}

class AuthStore {
	token = $state<string | null>(readStoredToken());
	user = $state<SessionUser | null>(null);

	get isAuthenticated() {
		return this.token !== null;
	}

	setToken(token: string) {
		this.token = token;
		if (browser) localStorage.setItem(TOKEN_KEY, token);
	}

	setUser(user: SessionUser) {
		this.user = user;
	}

	clear() {
		this.token = null;
		this.user = null;
		if (browser) localStorage.removeItem(TOKEN_KEY);
	}
}

export const auth = new AuthStore();
