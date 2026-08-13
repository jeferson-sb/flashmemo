<script lang="ts">
	let { size = 28 }: { size?: number } = $props();
</script>

<svg width={size} height={size} viewBox="0 0 32 32" fill="none" aria-hidden="true">
	<path d="M16 29c0-9 0-15 0-19" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" />
	<path
		d="M16 19c-5.5 0-9-3.4-9-9.6C7 9.4 7 9.2 7 9c5.6 0 9 3.5 9 10Z"
		fill="var(--forest-400)"
		stroke="var(--forest-600)"
		stroke-width="0.75"
	/>
	<path
		d="M16 15c5-.2 8-3.3 8-9 0-.2 0-.3 0-.5C18.7 5.8 16 9 16 15Z"
		fill="var(--forest-300)"
		stroke="var(--forest-600)"
		stroke-width="0.75"
	/>
	<circle cx="16" cy="26" r="4.5" fill="var(--gold-500)" stroke="var(--gold-600)" stroke-width="0.75" />
</svg>
