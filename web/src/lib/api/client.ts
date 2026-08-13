import { PUBLIC_API_BASE_URL } from '$env/static/public';
import { auth } from '$lib/stores/auth.svelte';
import type { ApiErrorBody } from './types';

export class ApiError extends Error {
	status: number;
	fieldErrors?: Record<string, string[]>;

	constructor(message: string, status: number, fieldErrors?: Record<string, string[]>) {
		super(message);
		this.name = 'ApiError';
		this.status = status;
		this.fieldErrors = fieldErrors;
	}
}

function normalizeError(body: unknown, status: number): ApiError {
	const b = body as ApiErrorBody | undefined;
	if (b && typeof b === 'object' && 'error' in b) {
		const err = b.error;
		if (Array.isArray(err)) {
			return new ApiError(err.join(' '), status);
		}
		if (typeof err === 'string') {
			return new ApiError(err, status);
		}
		if (err && typeof err === 'object') {
			const messages = Object.entries(err).map(([field, msgs]) => `${field} ${msgs.join(', ')}`);
			return new ApiError(messages.join(' — ') || 'Request failed.', status, err);
		}
	}
	return new ApiError('Something went wrong. Please try again.', status);
}

async function request<T>(path: string, options: RequestInit = {}): Promise<T> {
	const headers = new Headers(options.headers);
	headers.set('Accept', 'application/json');
	if (!(options.body instanceof FormData) && options.body) {
		headers.set('Content-Type', 'application/json');
	}
	if (auth.token) {
		headers.set('Authorization', `Token token="${auth.token}"`);
	}

	const res = await fetch(`${PUBLIC_API_BASE_URL}${path}`, { ...options, headers });

	// 204s sometimes carry a JSON body in this API, sometimes not — read as
	// text first so an empty body never throws a JSON parse error.
	const text = await res.text();
	const data = text ? JSON.parse(text) : null;

	if (!res.ok) {
		if (res.status === 401) auth.clear();
		throw normalizeError(data, res.status);
	}

	return data as T;
}

export const api = {
	get: <T>(path: string) => request<T>(path, { method: 'GET' }),
	post: <T>(path: string, body?: unknown) =>
		request<T>(path, { method: 'POST', body: body !== undefined ? JSON.stringify(body) : undefined }),
	patch: <T>(path: string, body?: unknown) =>
		request<T>(path, { method: 'PATCH', body: body !== undefined ? JSON.stringify(body) : undefined }),
	del: <T>(path: string) => request<T>(path, { method: 'DELETE' })
};
