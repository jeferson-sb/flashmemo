<script lang="ts">
	import CardFlip from '$lib/icons/CardFlip.svelte';
	import Seed from '$lib/icons/Seed.svelte';
	import Sprout from '$lib/icons/Sprout.svelte';
	import Tree from '$lib/icons/Tree.svelte';

	const rows = [
		{
			icon: CardFlip,
			action: 'Answer a question',
			detail: 'True/false, multiple choice, or a duo combination — pulled from an exam you built.'
		},
		{
			icon: Seed,
			action: 'Earn a seed',
			detail: 'Every right answer earns a seed, logged straight to your ledger for that subject.'
		},
		{
			icon: Sprout,
			action: 'Plant it in the plot',
			detail: "Seeds settle into the category they came from — biology grows its own row, history its own."
		},
		{
			icon: Tree,
			action: 'Harvest into your garden',
			detail: 'Enough seeds and a plot matures into a tree — harvested knowledge you can look back on.'
		}
	];
</script>

<section class="mechanism section" id="how-it-grows">
	<div class="mechanism__head">
		<span class="dateline">How It Grows</span>
		<h2>Four entries. One season of studying.</h2>
	</div>

	<div class="paper ledger">
		{#each rows as row, i (row.action)}
			<div class="ledger__row">
				<div class="ledger__head">
					<span class="ledger__no">No. {i + 1}</span>
					<span class="ledger__icon"><row.icon size={22} /></span>
					<span class="ledger__action">{row.action}</span>
					<span class="ledger__leader" aria-hidden="true"></span>
				</div>
				<p class="ledger__detail">{row.detail}</p>
			</div>
		{/each}
	</div>
</section>

<style>
	.mechanism__head {
		display: flex;
		flex-direction: column;
		gap: var(--space-xs);
		margin-bottom: var(--space-lg);
	}

	h2 {
		font-size: clamp(2rem, 3.4vw, var(--text-2xl));
		color: var(--cream-100);
		max-width: 20ch;
	}

	.ledger {
		padding: var(--space-lg) var(--space-lg);
	}

	.ledger__row {
		padding-block: var(--space-sm);
		--indent: 5.5rem;
	}

	.ledger__head {
		display: flex;
		align-items: center;
		gap: var(--space-xs);
	}

	.ledger__no {
		font-family: var(--font-mono);
		font-size: var(--text-xs);
		color: var(--paper-ink-muted);
		flex: 0 0 3rem;
	}

	.ledger__icon {
		flex: 0 0 auto;
		display: flex;
	}

	.ledger__action {
		font-family: var(--font-display);
		font-weight: 600;
		font-size: var(--text-lg);
		color: var(--paper-ink);
		white-space: nowrap;
		flex: 0 0 auto;
	}

	.ledger__leader {
		flex: 1 1 auto;
		min-width: var(--space-lg);
		border-bottom: 1px dotted color-mix(in srgb, var(--paper-ink) 30%, transparent);
		transform: translateY(2px);
	}

	.ledger__detail {
		margin: var(--space-2xs) 0 0;
		padding-inline-start: var(--indent);
		color: var(--paper-ink-muted);
		font-size: var(--text-sm);
		max-width: 56ch;
	}

	@media (max-width: 560px) {
		.ledger__row {
			--indent: 2.25rem;
		}

		.ledger__no {
			display: none;
			flex-basis: 0;
		}

		.ledger__action {
			white-space: normal;
		}

		.ledger {
			padding: var(--space-md) var(--space-sm);
		}
	}
</style>
