<script lang="ts">
	import Mark from '$lib/icons/Mark.svelte';
</script>

<footer class="footer">
	<div class="footer__inner">
		<div class="footer__brand">
			<Mark size={22} />
			<span>Flashmemo</span>
		</div>
		<p class="footer__note">
			A study almanac, published one season at a time. Grow what you learn instead of just
			re-reading it.
		</p>
		<nav class="footer__links" aria-label="Footer">
			<a href="#how-it-grows">How it grows</a>
			<a href="#almanac">This year's almanac</a>
			<a href="#seasons">Your seasons</a>
			<a href="/signup">Start your garden</a>
		</nav>
	</div>
</footer>

<style>
	.footer {
		border-top: 1px solid color-mix(in srgb, var(--gold-500) 18%, transparent);
	}

	.footer__inner {
		max-width: var(--content-width);
		margin-inline: auto;
		padding: var(--space-lg) var(--edge) var(--space-xl);
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
	}

	.footer__brand {
		display: flex;
		align-items: center;
		gap: var(--space-2xs);
		font-family: var(--font-display);
		font-weight: 600;
		color: var(--cream-100);
	}

	.footer__note {
		color: var(--tan-500);
		font-size: var(--text-sm);
		max-width: 34ch;
	}

	.footer__links {
		display: flex;
		gap: var(--space-md);
		flex-wrap: wrap;
	}

	.footer__links a {
		font-size: var(--text-sm);
		color: var(--tan-300);
		text-decoration: none;
	}

	.footer__links a:hover {
		color: var(--gold-300);
	}
</style>
