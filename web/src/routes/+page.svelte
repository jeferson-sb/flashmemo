<script lang="ts">
	import SiteHeader from '$lib/components/SiteHeader.svelte';
	import Hero from '$lib/components/Hero.svelte';
	import Mechanism from '$lib/components/Mechanism.svelte';
	import Almanac from '$lib/components/Almanac.svelte';
	import SeasonalProgress from '$lib/components/SeasonalProgress.svelte';
	import FinalCta from '$lib/components/FinalCta.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
</script>

<svelte:head>
	<title>Flashmemo — Grow a garden out of everything you study</title>
	<meta
		name="description"
		content="Flashmemo turns flashcards, exams, and revisions into seeds. Answer right, plant a tree, and watch a season of studying become a garden you can see."
	/>
</svelte:head>

<SiteHeader />

<main>
	<Hero />
	<Mechanism />
	<Almanac />
	<SeasonalProgress />
	<FinalCta />
</main>

<SiteFooter />
