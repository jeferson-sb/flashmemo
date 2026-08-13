<script lang="ts">
	let { width = 120 }: { width?: number } = $props();
</script>

<svg {width} height="16" viewBox="0 0 120 16" fill="none" aria-hidden="true">
	<path d="M0 8h48M72 8h48" stroke="currentColor" stroke-width="1" opacity="0.45" />
	<path
		d="M60 8c0-3.5-2.6-6-6-6M60 8c0-3.5 2.6-6 6-6M60 8c0 3.5-2.6 6-6 6M60 8c0 3.5 2.6 6 6 6"
		stroke="var(--forest-400)"
		stroke-width="1.1"
		stroke-linecap="round"
	/>
	<circle cx="60" cy="8" r="2.2" fill="var(--gold-500)" />
</svg>
