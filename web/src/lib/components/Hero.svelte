<script lang="ts">
	import Seed from '$lib/icons/Seed.svelte';
	import GardenHorizon from './GardenHorizon.svelte';

	const yield_ = [
		{ day: 'Mon', seeds: 6 },
		{ day: 'Tue', seeds: 9 },
		{ day: 'Wed', seeds: 4 },
		{ day: 'Thu', seeds: 11 },
		{ day: 'Fri', seeds: 7 },
		{ day: 'Sat', seeds: 14 },
		{ day: 'Sun', seeds: 8 }
	];
	const total = yield_.reduce((sum, d) => sum + d.seeds, 0);
</script>

<section class="hero" id="top">
	<div class="hero__inner">
		<div class="hero__masthead">
			<span class="dateline">Vol. I · Season One · Est. 2026</span>
			<span class="dateline dateline--right">A Living Study Almanac</span>
		</div>

		<div class="hero__content">
			<div class="hero__copy">
				<h1>Grow a garden out of everything you study.</h1>
				<p class="hero__lede">
					Flashmemo turns your flashcards, revisions, and exam prep into seeds. Answer right, plant
					one in your subject's plot, and watch a season of studying become a garden you can
					actually see.
				</p>
				<div class="hero__actions">
					<a class="button" href="#signup">Start your garden</a>
					<a class="hero__secondary" href="#how-it-grows">See how it grows ↓</a>
				</div>
			</div>

			<aside class="paper yield-card" aria-label="Example weekly yield">
				<div class="yield-card__head">
					<span class="dateline">This Week's Yield</span>
					<span class="tag tag--sample">Sample ledger</span>
				</div>
				<ul class="yield-card__rows">
					{#each yield_ as row (row.day)}
						<li>
							<span class="yield-card__day">{row.day}</span>
							<span class="yield-card__bar">
								<span
									class="yield-card__fill"
									style={`--w:${(row.seeds / 14) * 100}%`}
								></span>
							</span>
							<span class="yield-card__count">{row.seeds}</span>
						</li>
					{/each}
				</ul>
				<div class="yield-card__total">
					<Seed size={18} />
					<span><strong>{total}</strong> seeds earned · 3 trees planted</span>
				</div>
			</aside>
		</div>
	</div>

	<GardenHorizon />
</section>

<style>
	.hero {
		position: relative;
		overflow: hidden;
		padding-block-start: var(--space-md);
		padding-block-end: var(--space-3xl);
	}

	.hero__inner {
		max-width: var(--content-width);
		margin-inline: auto;
		padding-inline: var(--edge);
		position: relative;
		z-index: 1;
	}

	.hero__masthead {
		display: flex;
		justify-content: space-between;
		align-items: baseline;
		padding-block: var(--space-md) var(--space-lg);
		border-bottom: 1px solid color-mix(in srgb, var(--gold-500) 22%, transparent);
		margin-bottom: var(--space-xl);
	}

	.dateline--right {
		color: var(--gold-400);
	}

	.hero__content {
		display: grid;
		grid-template-columns: minmax(0, 1.15fr) minmax(280px, 0.85fr);
		gap: var(--space-2xl);
		align-items: start;
	}

	h1 {
		font-size: clamp(2.75rem, 5.4vw, var(--text-4xl));
		max-width: 15ch;
		color: var(--cream-100);
	}

	.hero__lede {
		margin-block-start: var(--space-md);
		max-width: 46ch;
		font-size: var(--text-lg);
		color: var(--tan-300);
		line-height: 1.5;
	}

	.hero__actions {
		display: flex;
		align-items: center;
		gap: var(--space-md);
		margin-block-start: var(--space-lg);
		flex-wrap: wrap;
	}

	.hero__secondary {
		color: var(--gold-300);
		text-decoration: none;
		font-weight: 600;
		font-size: var(--text-sm);
	}

	.hero__secondary:hover {
		text-decoration: underline;
	}

	.yield-card {
		padding: var(--space-md) var(--space-md) var(--space-sm);
		transform: rotate(1.4deg);
	}

	.yield-card__head {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: var(--space-sm);
	}

	.yield-card__head .dateline {
		color: var(--paper-ink-muted);
	}

	.yield-card__rows {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: var(--space-3xs);
	}

	.yield-card__rows li {
		display: grid;
		grid-template-columns: 2.5rem 1fr 1.5rem;
		align-items: center;
		gap: var(--space-xs);
		font-family: var(--font-mono);
		font-size: var(--text-xs);
	}

	.yield-card__day {
		color: var(--paper-ink-muted);
	}

	.yield-card__bar {
		height: 7px;
		border-radius: 999px;
		background: color-mix(in srgb, var(--paper-ink) 12%, transparent);
		overflow: hidden;
	}

	.yield-card__fill {
		display: block;
		height: 100%;
		width: var(--w);
		background: var(--crimson-500);
		border-radius: inherit;
	}

	.yield-card__count {
		text-align: right;
		color: var(--paper-ink);
	}

	.yield-card__total {
		display: flex;
		align-items: center;
		gap: var(--space-2xs);
		margin-block-start: var(--space-sm);
		padding-block-start: var(--space-sm);
		border-top: 1px dashed color-mix(in srgb, var(--paper-ink) 22%, transparent);
		font-size: var(--text-sm);
		color: var(--paper-ink-muted);
	}

	.yield-card__total strong {
		color: var(--paper-ink);
	}

	@media (max-width: 900px) {
		.hero__content {
			grid-template-columns: 1fr;
		}

		.yield-card {
			transform: none;
			justify-self: start;
			max-width: 26rem;
		}

		h1 {
			max-width: none;
		}
	}

	@media (max-width: 540px) {
		.hero__masthead {
			flex-direction: column;
			align-items: flex-start;
			gap: var(--space-3xs);
		}
	}
</style>
