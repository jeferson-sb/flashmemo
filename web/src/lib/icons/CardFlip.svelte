<script lang="ts">
	let { size = 22 }: { size?: number } = $props();
</script>

<svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
	<rect
		x="3.5"
		y="5"
		width="13"
		height="16"
		rx="1.5"
		transform="rotate(-6 10 13)"
		fill="var(--paper-200)"
		stroke="var(--paper-ink-muted)"
		stroke-width="1"
	/>
	<path
		d="m8.7 12.6 2 2.2 4.1-5"
		transform="rotate(-6 10 13)"
		stroke="var(--forest-500)"
		stroke-width="1.6"
		stroke-linecap="round"
		stroke-linejoin="round"
	/>
</svg>
