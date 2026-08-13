// This whole section (auth pages + dashboard) reads its state from a
// bearer token in localStorage — there is no cookie/session to render
// from on the server, so it renders purely client-side.
export const ssr = false;
export const prerender = false;
