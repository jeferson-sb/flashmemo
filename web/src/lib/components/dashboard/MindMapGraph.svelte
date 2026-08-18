<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import type { GraphEdge, GraphNode } from '$lib/api';

	let { nodes, edges }: { nodes: GraphNode[]; edges: GraphEdge[] } = $props();

	let container = $state<HTMLDivElement | null>(null);
	let svgEl = $state<SVGSVGElement | null>(null);
	let hovered = $state<{ label: string; type: string; x: number; y: number } | null>(null);

	// d3 owns everything under <g class="zoom-layer"> once mounted: Svelte's
	// job stops at handing it a sized <svg>, since a physics tick can fire far
	// more often than a reactive re-render should.
	let stopSimulation: (() => void) | null = null;

	onMount(async () => {
		if (!svgEl || !container) return;

		const [{ forceSimulation, forceLink, forceManyBody, forceCenter, forceCollide }, { select }, { drag }, { zoom }] =
			await Promise.all([import('d3-force'), import('d3-selection'), import('d3-drag'), import('d3-zoom')]);

		type SimNode = GraphNode & { x?: number; y?: number; fx?: number | null; fy?: number | null };
		type SimEdge = { source: SimNode; target: SimNode; type: GraphEdge['type'] };

		// Plain, un-proxied copies: forceLink mutates source/target from id
		// strings into live node references in place, and d3 ticking that
		// object identity against a Svelte $state proxy (the props as passed)
		// silently decouples the reference from the node the simulation
		// actually animates, freezing every edge at its tick-zero position.
		const simNodes: SimNode[] = nodes.map((node) => ({ ...node }));
		const simEdges: SimEdge[] = edges.map((edge) => ({ ...edge })) as unknown as SimEdge[];

		const { width, height } = container.getBoundingClientRect();
		const svg = select(svgEl);
		const zoomLayer = svg.append('g').attr('class', 'zoom-layer');

		const linkSelection = zoomLayer
			.append('g')
			.attr('class', 'links')
			.selectAll<SVGLineElement, SimEdge>('line')
			.data(simEdges)
			.join('line')
			.attr('class', (d) => `link link--${d.type.toLowerCase()}`)
			.attr('marker-end', (d) => (d.type === 'IN' ? 'url(#arrow-in)' : null));

		const nodeSelection = zoomLayer
			.append('g')
			.attr('class', 'nodes')
			.selectAll<SVGGElement, SimNode>('g')
			.data(simNodes)
			.join('g')
			.attr('class', (d) => `node node--${d.type}`)
			.on('mouseenter', (event: PointerEvent, d: SimNode) => {
				const bounds = container!.getBoundingClientRect();
				hovered = { label: d.label, type: d.type, x: event.clientX - bounds.left, y: event.clientY - bounds.top };
			})
			.on('mousemove', (event: PointerEvent) => {
				if (!hovered) return;
				const bounds = container!.getBoundingClientRect();
				hovered = { ...hovered, x: event.clientX - bounds.left, y: event.clientY - bounds.top };
			})
			.on('mouseleave', () => (hovered = null));

		nodeSelection.append('circle').attr('r', (d) => (d.type === 'category' ? 22 : 16));
		nodeSelection
			.append('text')
			.attr('dy', (d) => (d.type === 'category' ? 36 : 30))
			.text((d) => d.label);

		const simulation = forceSimulation(simNodes)
			.force(
				'link',
				forceLink<SimNode, SimEdge>(simEdges)
					.id((d) => d.id)
					.distance(90)
			)
			.force('charge', forceManyBody().strength(-260))
			.force('center', forceCenter(width / 2, height / 2))
			.force(
				'collide',
				forceCollide<SimNode>((d) => (d.type === 'category' ? 34 : 26))
			);

		simulation.on('tick', () => {
			linkSelection
				.attr('x1', (d) => d.source.x ?? 0)
				.attr('y1', (d) => d.source.y ?? 0)
				.attr('x2', (d) => d.target.x ?? 0)
				.attr('y2', (d) => d.target.y ?? 0);

			nodeSelection.attr('transform', (d) => `translate(${d.x ?? 0}, ${d.y ?? 0})`);
		});

		nodeSelection.call(
			drag<SVGGElement, SimNode>()
				.on('start', (event) => {
					if (!event.active) simulation.alphaTarget(0.25).restart();
					event.subject.fx = event.subject.x;
					event.subject.fy = event.subject.y;
				})
				.on('drag', (event) => {
					event.subject.fx = event.x;
					event.subject.fy = event.y;
				})
				.on('end', (event) => {
					if (!event.active) simulation.alphaTarget(0);
					// Left pinned where dropped, so a user arranging the map by hand
					// doesn't watch it drift back — refreshing resets the layout.
				})
		);

		svg.call(
			zoom<SVGSVGElement, unknown>()
				.scaleExtent([0.35, 3])
				.on('zoom', (event) => zoomLayer.attr('transform', event.transform))
		);

		stopSimulation = () => simulation.stop();
	});

	onDestroy(() => stopSimulation?.());
</script>

<div class="mindmap-canvas" bind:this={container}>
	<svg bind:this={svgEl} role="img" aria-label="Mind map of exams grouped by category">
		<defs>
			<marker id="arrow-in" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
				<path d="M0 0L10 5L0 10Z" fill="var(--gold-400)" />
			</marker>
		</defs>
	</svg>

	{#if hovered}
		<div class="graph-tooltip" style="left: {hovered.x}px; top: {hovered.y}px;">
			<span class="graph-tooltip__dot graph-tooltip__dot--{hovered.type}"></span>
			{hovered.label}
			<span class="graph-tooltip__type">{hovered.type}</span>
		</div>
	{/if}
</div>

<style>
	.mindmap-canvas {
		position: relative;
		width: 100%;
		height: 32rem;
		border-radius: var(--radius-card);
		background: radial-gradient(ellipse 120% 80% at 50% 0%, var(--ink-800), var(--ink-950));
		border: 1px solid color-mix(in srgb, var(--gold-500) 20%, transparent);
		overflow: hidden;
	}

	svg {
		width: 100%;
		height: 100%;
		cursor: grab;
	}

	svg:active {
		cursor: grabbing;
	}

	.mindmap-canvas :global(.link) {
		stroke-width: 1.5;
		fill: none;
	}

	.mindmap-canvas :global(.link--relates_to) {
		stroke: var(--tan-500);
		opacity: 0.5;
	}

	.mindmap-canvas :global(.link--in) {
		stroke: var(--gold-500);
		opacity: 0.75;
	}

	.mindmap-canvas :global(.node) {
		cursor: pointer;
	}

	.mindmap-canvas :global(.node circle) {
		stroke-width: 2;
		transition: filter var(--duration-fast) var(--ease-out-expo);
	}

	.mindmap-canvas :global(.node:hover circle) {
		filter: brightness(1.15);
	}

	.mindmap-canvas :global(.node--category circle) {
		fill: var(--forest-400);
		stroke: var(--forest-600);
	}

	.mindmap-canvas :global(.node--exam circle) {
		fill: var(--gold-400);
		stroke: var(--crimson-500);
	}

	.mindmap-canvas :global(.node text) {
		font-family: var(--font-body);
		font-size: 0.6875rem;
		font-weight: 600;
		fill: var(--cream-100);
		text-anchor: middle;
		paint-order: stroke;
		stroke: var(--ink-950);
		stroke-width: 3px;
		stroke-linejoin: round;
		pointer-events: none;
		user-select: none;
	}

	.graph-tooltip {
		position: absolute;
		transform: translate(-50%, calc(-100% - 0.85rem));
		pointer-events: none;
		display: flex;
		align-items: center;
		gap: 0.35rem;
		background: var(--ink-900);
		border: 1px solid color-mix(in srgb, var(--gold-500) 30%, transparent);
		border-radius: 999px;
		padding: 0.3rem 0.65rem;
		font-size: 0.75rem;
		font-weight: 600;
		color: var(--cream-100);
		white-space: nowrap;
		box-shadow: 0 8px 20px -8px rgba(12, 7, 4, 0.6);
	}

	.graph-tooltip__dot {
		width: 8px;
		height: 8px;
		border-radius: 50%;
		flex-shrink: 0;
	}

	.graph-tooltip__dot--category {
		background: var(--forest-400);
	}

	.graph-tooltip__dot--exam {
		background: var(--gold-400);
	}

	.graph-tooltip__type {
		color: var(--tan-400);
		font-weight: 500;
		text-transform: capitalize;
	}
</style>
