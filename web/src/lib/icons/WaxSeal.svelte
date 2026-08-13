<script lang="ts">
	let { size = 96, stamped = false }: { size?: number; stamped?: boolean } = $props();
</script>

<svg
	width={size}
	height={size}
	viewBox="0 0 96 96"
	fill="none"
	aria-hidden="true"
	class="seal"
	class:stamped
>
	<circle cx="48" cy="48" r="42" fill="var(--crimson-500)" stroke="var(--crimson-600)" stroke-width="2" />
	<circle
		cx="48"
		cy="48"
		r="42"
		fill="none"
		stroke="var(--crimson-300)"
		stroke-width="1"
		stroke-dasharray="2 4"
		opacity="0.6"
	/>
	<path
		d="M48 27c4.5 4 7 8.6 7 12.8a7 7 0 1 1-14 0c0-4.2 2.5-8.8 7-12.8Z"
		fill="var(--paper-200)"
		opacity="0.92"
	/>
	<path d="M48 40.5v22" stroke="var(--paper-200)" stroke-width="2" stroke-linecap="round" opacity="0.92" />
	<path d="M40 55h16" stroke="var(--paper-200)" stroke-width="2" stroke-linecap="round" opacity="0.92" />
</svg>

<style>
	.seal {
		filter: drop-shadow(0 10px 18px rgba(24, 15, 9, 0.45));
	}

	.seal.stamped {
		animation: stamp-down 640ms var(--ease-out-expo);
	}

	@keyframes stamp-down {
		0% {
			transform: translateY(-26px) scale(1.3) rotate(-8deg);
			opacity: 0;
		}
		55% {
			transform: translateY(2px) scale(0.97) rotate(2deg);
			opacity: 1;
		}
		75% {
			transform: translateY(-1px) scale(1.02) rotate(-1deg);
		}
		100% {
			transform: translateY(0) scale(1) rotate(0deg);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.seal.stamped {
			animation: none;
		}
	}
</style>
