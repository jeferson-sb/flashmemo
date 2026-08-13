<script lang="ts">
	// An authored illustration of a study garden at different growth stages —
	// not a screenshot, since no hosted product exists yet to photograph.
</script>

<svg
	class="horizon"
	viewBox="0 0 1200 220"
	preserveAspectRatio="xMidYMax slice"
	fill="none"
	aria-hidden="true"
>
	<path
		d="M0 120c120-18 180 22 300 10s180-30 300-8 180 26 300 6 180-24 300-2v94H0Z"
		fill="var(--ink-700)"
		opacity="0.8"
	/>
	<path
		d="M0 150c120-14 180 16 300 8s180-22 300-6 180 20 300 4 180-18 300-2v66H0Z"
		fill="var(--ink-600)"
		opacity="0.55"
	/>

	<!-- furrow rows -->
	<g stroke="var(--gold-500)" stroke-width="1" opacity="0.16">
		<path d="M-20 170c140-10 240 10 380 0s240-14 380-2 240 12 380 2" />
		<path d="M-20 190c140-8 240 8 380 0s240-10 380-2 240 10 380 2" />
		<path d="M-20 210c140-6 240 6 380 0s240-8 380-2 240 8 380 2" />
	</g>

	<!-- growth stages, left to right: seed, sprout, sapling, full tree -->
	<g transform="translate(120 172)">
		<circle r="4.5" fill="var(--gold-500)" />
	</g>
	<g transform="translate(340 168) scale(0.9)">
		<path d="M0 24V6" stroke="var(--forest-400)" stroke-width="1.4" stroke-linecap="round" />
		<path d="M0 10c-3 0-5-1.8-5-5.2C-2.4 4.8 0 6.6 0 10Z" fill="var(--forest-400)" />
		<path d="M0 8c2.6 0 4.3-1.5 4.3-4.4C1.9 3.6 0 5.2 0 8Z" fill="var(--forest-300)" />
	</g>
	<g transform="translate(620 160)">
		<path d="M0 36V14" stroke="var(--forest-500)" stroke-width="1.6" stroke-linecap="round" />
		<path d="M0 18c-5 0-8.3-3-8.3-7.9C-3.6 9.8 0 12.9 0 18Z" fill="var(--forest-400)" />
		<path d="M0 13c4.4 0 7.2-2.5 7.2-7.2C3.2 6.3 0 9.2 0 13Z" fill="var(--forest-300)" />
	</g>
	<g transform="translate(940 148)">
		<path d="M0 48V18" stroke="var(--forest-600)" stroke-width="2" stroke-linecap="round" />
		<path d="M0 24c-6.6 0-11-4-11-10.5C-4.8 13 0 17 0 24Z" fill="var(--forest-400)" />
		<path d="M0 17c5.8 0 9.6-3.3 9.6-9.5C4.3 8.4 0 12.1 0 17Z" fill="var(--forest-300)" />
		<path d="M0 11c-4.4 0-7.2-2.5-7.2-7.2C-3.2 3.6 0 6.4 0 11Z" fill="var(--gold-400)" opacity="0.9" />
	</g>
</svg>

<style>
	.horizon {
		position: absolute;
		inset-inline: 0;
		bottom: 0;
		width: 100%;
		height: clamp(120px, 22vw, 220px);
		pointer-events: none;
	}
</style>
