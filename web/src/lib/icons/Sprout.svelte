<script lang="ts">
	let { size = 22 }: { size?: number } = $props();
</script>

<svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
	<path d="M12 21V11" stroke="var(--forest-400)" stroke-width="1.4" stroke-linecap="round" />
	<path
		d="M12 12c-4 0-6.5-2.4-6.5-6.7C9.8 5.3 12 8 12 12Z"
		fill="var(--forest-400)"
		stroke="var(--forest-600)"
		stroke-width="0.75"
	/>
	<path
		d="M12 9.5c3.2 0 5.2-2 5.2-5.4C13.7 4.1 12 6.3 12 9.5Z"
		fill="var(--forest-300)"
		stroke="var(--forest-600)"
		stroke-width="0.75"
	/>
	<ellipse cx="12" cy="21.5" rx="6" ry="1.4" fill="var(--ink-600)" opacity="0.6" />
</svg>
