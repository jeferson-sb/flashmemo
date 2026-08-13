<script lang="ts">
	const entries = [
		{
			term: 'Exams & categories',
			note: 'Group questions into an exam, and file every exam under the subject it belongs to.'
		},
		{
			term: 'Three question types',
			note: 'True/false, multiple choice, and duo combinations — drilling never feels the same twice.'
		},
		{
			term: 'Revisions',
			note: "Weak spots resurface on their own schedule, instead of waiting for you to remember them."
		},
		{
			term: 'Mind maps',
			note: 'Sketch how ideas connect to each other, then drill straight from the map.'
		},
		{
			term: 'Progress by season',
			note: 'Track how much you have grown by month, by semester, or across the whole year.'
		},
		{
			term: 'An account of your own',
			note: 'Sign in and your ledger — every seed, every tree — stays yours alone.'
		}
	];
</script>

<section class="almanac section" id="almanac">
	<div class="almanac__head">
		<span class="dateline">This Year's Almanac</span>
		<h2>Everything filed under one ledger.</h2>
		<p class="almanac__lede">
			The garden is the reward. The almanac underneath it is a real study tool — built to hold
			exams, questions, and revisions the way you'd actually use them.
		</p>
	</div>

	<div class="paper almanac__sheet">
		<table class="ledger-table">
			<thead>
				<tr>
					<th scope="col">Entry</th>
					<th scope="col">What it does</th>
				</tr>
			</thead>
			<tbody>
				{#each entries as entry (entry.term)}
					<tr>
						<th scope="row">{entry.term}</th>
						<td>{entry.note}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
</section>

<style>
	.almanac__head {
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

	.almanac__lede {
		color: var(--tan-300);
		font-size: var(--text-base);
		line-height: 1.6;
	}

	.almanac__sheet {
		padding: var(--space-lg);
	}

	.ledger-table th[scope='row'] {
		width: 15rem;
		padding-inline-end: var(--space-md);
	}

	.ledger-table td {
		color: var(--paper-ink-muted);
		font-size: var(--text-sm);
	}

	@media (max-width: 700px) {
		.ledger-table thead {
			display: none;
		}

		.ledger-table th[scope='row'] {
			width: auto;
		}

		.ledger-table tr {
			display: grid;
			gap: var(--space-3xs);
			padding-block: var(--space-xs);
		}

		.almanac__sheet {
			padding: var(--space-md) var(--space-sm);
		}
	}
</style>
