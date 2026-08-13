<script lang="ts">
	import favicon from '$lib/assets/favicon.svg';
	import '../lib/styles/global.css';

	let { children } = $props();

	// Svelte strips literal template comments at compile time, so the
	// direction contract is injected as raw HTML to survive into the build.
	const directionContract = `<!--
THESIS: Studying is a harvest, not a chore — answer, earn a seed, watch it grow into a garden you can see.
OWN-WORLD: Harvest Almanac. Soil-brown ground; lamplit ledger-paper insets; harvest-gold headlines; oxblood wax-seal red; garden-green foliage. Fraunces display, Space Mono ledger figures, Plus Jakarta Sans body.
STORY: A self-studying visitor sees their study habit reframed as a living garden ledger, believes flashmemo makes progress visible and fun, and signs up to start their first plot.
FIRST VIEWPORT: full-bleed almanac masthead on the dark ground — dateline + wordmark in gold Fraunces, a lamplit "this week's yield" ledger card, primary "Start your garden" CTA visible without scrolling.
FORM: Harvest Almanac, rolled direction (assigned index 7 of the grounded list), standard scroll staging, seed key c5f7050f.
FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, and DESIGN.md.
-->`;
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

{@html directionContract}
{@render children()}
