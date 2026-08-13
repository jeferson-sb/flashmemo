<script lang="ts">
	let { size = 22 }: { size?: number } = $props();
</script>

<svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
	<path
		d="M12 3c4 3 6.5 7 6.5 10.5a6.5 6.5 0 1 1-13 0C5.5 10 8 6 12 3Z"
		fill="var(--gold-500)"
		stroke="var(--gold-600)"
		stroke-width="1"
	/>
	<path d="M12 8.5v9" stroke="var(--gold-600)" stroke-width="1" stroke-linecap="round" opacity="0.6" />
</svg>
