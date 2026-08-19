<script lang="ts">
	let { size = 28, tone = 'dark' }: { size?: number; tone?: 'dark' | 'light' } = $props();
</script>

<svg width={size} height={size} viewBox="0 0 64 64" fill="none" aria-hidden="true">
	<rect x="17" y="9" width="11" height="46" rx="1.5" fill={tone === 'dark' ? 'var(--paper-200)' : 'var(--ink-900)'} />
	<rect x="17" y="9" width="27" height="9.5" rx="1.5" fill={tone === 'dark' ? 'var(--paper-200)' : 'var(--ink-900)'} />
	<path
		d="M28 30c11-2.2 17 1.4 17 5.2 0 .3 0 .6-.1.9-9.8 2.4-16.9-1.2-16.9-6.1Z"
		fill="var(--forest-400)"
		stroke="var(--forest-600)"
		stroke-width="1"
	/>
	<path
		d="M44 9v8.2c3-1.4 5-3.6 5-6.2 0-.7-.1-1.4-.4-2Z"
		fill={tone === 'dark' ? 'var(--paper-300)' : 'var(--gold-500)'}
		stroke="var(--gold-600)"
		stroke-width="0.6"
	/>
	<path d="M46 10c4 1 7 3 8 5" stroke="var(--forest-600)" stroke-width="2" stroke-linecap="round" />
	<path
		d="M54 15c1-4 4-6 7-6 .2 3.2-1.6 5.7-4.6 6.6-.9.3-1.7.1-2.4-.6Z"
		fill="var(--forest-400)"
		stroke="var(--forest-600)"
		stroke-width="0.6"
	/>
	<path
		d="M54 15c1.7 2.8 1.6 6.3-.9 8-2.3-1.9-2.8-5.2-1.3-7.7.7-.5 1.5-.6 2.2-.3Z"
		fill="var(--forest-300)"
		stroke="var(--forest-600)"
		stroke-width="0.6"
	/>
</svg>
