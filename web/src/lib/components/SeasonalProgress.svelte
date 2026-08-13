<script lang="ts">
	import { reveal } from '$lib/actions/reveal';

	const months = [
		{ label: 'Jan', value: 22 },
		{ label: 'Feb', value: 28 },
		{ label: 'Mar', value: 34 },
		{ label: 'Apr', value: 31 },
		{ label: 'May', value: 40 },
		{ label: 'Jun', value: 46 },
		{ label: 'Jul', value: 38 },
		{ label: 'Aug', value: 44 },
		{ label: 'Sep', value: 52 },
		{ label: 'Oct', value: 58 },
		{ label: 'Nov', value: 63 },
		{ label: 'Dec', value: 70 }
	];
	const max = Math.max(...months.map((m) => m.value));
</script>

<section class="seasons section" id="seasons">
	<div class="seasons__head">
		<span class="dateline">Your Seasons</span>
		<h2>Watch one year of studying add up.</h2>
		<p class="seasons__lede">
			Every exam you finish adds to the month it happened in. Zoom out and a semester, or a whole
			year, tells you exactly when you grew the most.
		</p>
	</div>

	<div class="paper seasons__sheet">
		<div class="seasons__sheet-head">
			<span class="dateline seasons__tag">Trees harvested, per month</span>
			<span class="tag tag--sample">Sample season</span>
		</div>

		<div
			class="chart"
			use:reveal
			role="img"
			aria-label="Bar chart of trees harvested per month, rising from 22 in January to 70 in December"
		>
			{#each months as m (m.label)}
				<div class="chart__col">
					<div class="chart__bar" style={`--h:${(m.value / max) * 100}%`}></div>
					<span class="chart__label">{m.label}</span>
				</div>
			{/each}
		</div>

		<div class="semesters">
			<span class="semesters__bracket">Semester 1</span>
			<span class="semesters__bracket">Semester 2</span>
		</div>
	</div>
</section>

<style>
	.seasons__head {
		display: flex;
		flex-direction: column;
		gap: var(--space-xs);
		margin-bottom: var(--space-lg);
		max-width: 60ch;
	}

	h2 {
		font-size: clamp(2rem, 3.4vw, var(--text-2xl));
		color: var(--cream-100);
	}

	.seasons__lede {
		color: var(--tan-300);
		font-size: var(--text-base);
		line-height: 1.6;
	}

	.seasons__sheet {
		padding: var(--space-lg);
	}

	.seasons__sheet-head {
		display: flex;
		flex-wrap: wrap;
		justify-content: space-between;
		align-items: center;
		gap: var(--space-2xs) var(--space-sm);
		margin-bottom: var(--space-md);
	}

	.seasons__tag {
		color: var(--paper-ink-muted);
		white-space: nowrap;
	}

	.chart {
		display: grid;
		grid-template-columns: repeat(12, 1fr);
		align-items: end;
		gap: clamp(0.35rem, 1vw, 0.9rem);
		height: clamp(140px, 22vw, 220px);
	}

	.chart__col {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: var(--space-2xs);
		height: 100%;
		justify-content: flex-end;
	}

	.chart__bar {
		width: 100%;
		height: var(--h);
		border-radius: 3px 3px 1px 1px;
		background: linear-gradient(180deg, var(--gold-400), var(--forest-500) 65%);
		transform-origin: bottom;
	}

	/*
	 * Bars are legible even in the armed (pre-animation) state — never fully
	 * hidden — so a stalled observer (a non-scrolling capture, a slow
	 * connection) always leaves real data on screen, just not yet settled.
	 */
	.chart:global(.reveal--armed) .chart__bar {
		transform: scaleY(0.82);
		opacity: 0.7;
	}

	.chart:global(.reveal--armed.is-visible) .chart__bar {
		animation: grow var(--duration-slow) var(--ease-out-expo) forwards;
		animation-delay: calc(var(--i, 0) * 40ms);
	}

	.chart__col:nth-child(1) .chart__bar {
		--i: 1;
	}
	.chart__col:nth-child(2) .chart__bar {
		--i: 2;
	}
	.chart__col:nth-child(3) .chart__bar {
		--i: 3;
	}
	.chart__col:nth-child(4) .chart__bar {
		--i: 4;
	}
	.chart__col:nth-child(5) .chart__bar {
		--i: 5;
	}
	.chart__col:nth-child(6) .chart__bar {
		--i: 6;
	}
	.chart__col:nth-child(7) .chart__bar {
		--i: 7;
	}
	.chart__col:nth-child(8) .chart__bar {
		--i: 8;
	}
	.chart__col:nth-child(9) .chart__bar {
		--i: 9;
	}
	.chart__col:nth-child(10) .chart__bar {
		--i: 10;
	}
	.chart__col:nth-child(11) .chart__bar {
		--i: 11;
	}
	.chart__col:nth-child(12) .chart__bar {
		--i: 12;
	}

	@keyframes grow {
		from {
			transform: scaleY(0.82);
			opacity: 0.7;
		}
		to {
			transform: scaleY(1);
			opacity: 1;
		}
	}

	.chart__label {
		font-family: var(--font-mono);
		font-size: var(--text-2xs);
		color: var(--paper-ink-muted);
	}

	.semesters {
		display: grid;
		grid-template-columns: repeat(2, 1fr);
		gap: clamp(0.35rem, 1vw, 0.9rem);
		margin-top: var(--space-xs);
		padding-top: var(--space-2xs);
		border-top: 1px solid color-mix(in srgb, var(--paper-ink) 20%, transparent);
	}

	.semesters__bracket {
		text-align: center;
		font-family: var(--font-mono);
		font-size: var(--text-2xs);
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--paper-ink-muted);
	}

	@media (prefers-reduced-motion: reduce) {
		.chart__bar,
		.chart:global(.reveal--armed) .chart__bar,
		.chart:global(.reveal--armed.is-visible) .chart__bar {
			animation: none;
			transform: scaleY(1);
			opacity: 1;
		}
	}

	@media (max-width: 640px) {
		.chart {
			gap: 0.25rem;
		}

		.chart__label {
			font-size: 0.55rem;
		}
	}
</style>
