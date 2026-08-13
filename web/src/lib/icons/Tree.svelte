<script lang="ts">
	let { size = 26 }: { size?: number } = $props();
</script>

<svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
	<path d="M12 23v-8.5" stroke="var(--forest-600)" stroke-width="1.6" stroke-linecap="round" />
	<path
		d="M12 15.5c-4.5 0-7.5-2.6-7.5-7C4.5 8.2 4.5 8 4.5 7.8 10 8 12 11 12 15.5Z"
		fill="var(--forest-400)"
		stroke="var(--forest-600)"
		stroke-width="0.85"
	/>
	<path
		d="M12 12.2c4-.1 6.6-2.5 6.6-6.5 0-.15 0-.3 0-.45C14 5.6 12 8.3 12 12.2Z"
		fill="var(--forest-300)"
		stroke="var(--forest-600)"
		stroke-width="0.85"
	/>
	<path
		d="M12 8.7c-3-.2-4.9-2-4.9-4.9C10.2 3.9 12 5.9 12 8.7Z"
		fill="var(--gold-400)"
		stroke="var(--gold-600)"
		stroke-width="0.7"
	/>
	<ellipse cx="12" cy="23.3" rx="7" ry="1.3" fill="var(--ink-600)" opacity="0.55" />
</svg>
