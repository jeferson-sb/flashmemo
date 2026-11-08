import { defineEnvVars } from '@sveltejs/kit/env';

export const variables = defineEnvVars({
	// Base URL of the Rails API, including the /api path prefix.
	PUBLIC_API_BASE_URL: { public: true }
});
