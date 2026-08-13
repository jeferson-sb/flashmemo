<script lang="ts">
	import { goto } from '$app/navigation';
	import WaxSeal from '$lib/icons/WaxSeal.svelte';

	let stamped = $state(false);

	async function handleStart(event: MouseEvent) {
		event.preventDefault();
		stamped = true;
		await new Promise((resolve) => setTimeout(resolve, 520));
		goto('/signup');
	}
</script>

<section class="cta" id="signup">
	<div class="cta__inner">
		<div class="cta__copy">
			<span class="dateline">Sign the Ledger</span>
			<h2>Ready to plant this season's first seed?</h2>
			<p>
				Create an account, answer your first question, and your garden starts the same day.
				Free while flashmemo is in its first season.
			</p>

			<div class="cta__actions">
				<a class="button" href="/signup" onclick={handleStart}>Start your garden</a>
				<a class="cta__signin" href="/login">Already have a garden? Sign in</a>
			</div>
		</div>

		<div class="cta__seal" aria-hidden="true">
			<WaxSeal size={132} {stamped} />
		</div>
	</div>
</section>

<style>
	.cta {
		background: linear-gradient(180deg, transparent, var(--ink-900));
		padding-block: var(--space-2xl);
	}

	.cta__inner {
		max-width: var(--content-width);
		margin-inline: auto;
		padding-inline: var(--edge);
		display: grid;
		grid-template-columns: minmax(0, 1fr) auto;
		align-items: center;
		gap: var(--space-2xl);
	}

	h2 {
		font-size: clamp(2rem, 3.6vw, var(--text-2xl));
		color: var(--cream-100);
		margin-block: var(--space-xs);
		max-width: 18ch;
	}

	.cta__copy p {
		color: var(--tan-300);
		max-width: 46ch;
		font-size: var(--text-base);
		line-height: 1.6;
	}

	.cta__actions {
		display: flex;
		align-items: center;
		gap: var(--space-md);
		margin-block-start: var(--space-md);
		flex-wrap: wrap;
	}

	.cta__signin {
		color: var(--gold-300);
		text-decoration: none;
		font-weight: 600;
		font-size: var(--text-sm);
	}

	.cta__signin:hover {
		text-decoration: underline;
	}

	.cta__seal {
		justify-self: center;
	}

	@media (max-width: 760px) {
		.cta__inner {
			grid-template-columns: 1fr;
			gap: var(--space-md);
		}

		.cta__seal {
			order: -1;
			justify-self: flex-start;
		}
	}
</style>
