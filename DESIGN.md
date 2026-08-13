---
name: Flashmemo — Harvest Almanac
description: A warm, dark study-desk almanac where flashcards become seeds, trees, and a garden you can see.
colors:
  crimson-primary: "#a3392a"
  crimson-primary-hover: "#bb4736"
  crimson-deep: "#832a1e"
  harvest-gold: "#d89b3c"
  harvest-gold-bright: "#f0c874"
  gold-deep: "#b8802e"
  garden-forest: "#46612f"
  forest-bright: "#5c7d44"
  forest-deep: "#334a21"
  ground-ink: "#2a1d14"
  ground-ink-deep: "#180f09"
  ledger-paper: "#f2e4c6"
  ledger-paper-bright: "#f7ecd2"
  cream-text: "#f3e9d2"
  tan-muted: "#c9b08a"
typography:
  display:
    fontFamily: "Fraunces Variable, Fraunces, ui-serif, Georgia, serif"
    fontSize: "clamp(2.75rem, 5.4vw, 6.25rem)"
    fontWeight: 600
    lineHeight: 1.05
    letterSpacing: "-0.02em"
  body:
    fontFamily: "Plus Jakarta Sans Variable, Plus Jakarta Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.0625rem"
    fontWeight: 400
    lineHeight: 1.55
  label:
    fontFamily: "Space Mono, ui-monospace, SFMono-Regular, Menlo, monospace"
    fontSize: "0.6875rem"
    fontWeight: 400
    letterSpacing: "0.14em"
rounded:
  card: "6px"
  pill: "999px"
  seal: "50%"
spacing:
  3xs: "0.25rem"
  2xs: "0.5rem"
  xs: "0.75rem"
  sm: "1.25rem"
  md: "2rem"
  lg: "3.25rem"
  xl: "5.25rem"
  2xl: "8.5rem"
  3xl: "11rem"
components:
  button-primary:
    backgroundColor: "{colors.crimson-primary}"
    textColor: "{colors.cream-text}"
    rounded: "{rounded.card}"
    padding: "0.85rem 1.6rem"
  button-primary-hover:
    backgroundColor: "{colors.crimson-primary-hover}"
  button-primary-disabled:
    backgroundColor: "{colors.crimson-primary}"
    textColor: "{colors.cream-text}"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.cream-text}"
    rounded: "{rounded.card}"
    padding: "0.85rem 1.6rem"
  card-paper:
    backgroundColor: "{colors.ledger-paper}"
    textColor: "{colors.ground-ink}"
    rounded: "{rounded.card}"
  tag-sample:
    backgroundColor: "transparent"
    textColor: "{colors.harvest-gold-bright}"
    rounded: "{rounded.pill}"
    padding: "0.2rem 0.65rem"
---

<!--
Written in a single degraded, in-thread documenter pass: this environment's
Agent tool has no registered `impeccable-documenter` subagent, so the scan,
extraction, and write ran inline in the build thread rather than as an
independent fresh-eyes pass. Disclosed per the skill's degraded-mode contract.
-->

# Design System: Flashmemo — Harvest Almanac

## Overview

**Creative North Star: "The Harvest Almanac"**

Flashmemo's landing page is staged as a study desk after dark: a warm, soil-brown ground lit by one lamp, with sheets of ledger paper pinned onto it wherever the product needs to show real information. The world was arrived at through Impeccable's direction-roll process (seed key `c5f7050f`), landing on an almanac/harvest-ledger reading of the product's existing reward mechanism — seeds, trees, and a garden — rather than the generic warm-cream-plus-serif-plus-red-accent look that a from-scratch AI pass defaults to. The page deliberately inverts that default: the dominant field is dark, not pale cream, and "paper" only ever appears as a lamplit inset, never as the page's own ground.

Every demonstrative number on the page (the weekly yield ledger, the twelve-month harvest chart) is synthetic and explicitly tagged "Sample ledger" / "Sample season" — this is a real, load-bearing rule, not decoration: the product has no hosted instance yet, so nothing on the page may read as a real user's data or a real testimonial.

**Key Characteristics:**
- Dark, warm soil-brown ground; ledger paper exists only as a lit inset, never as the page background.
- One saturated accent (oxblood crimson) reserved for action and the wax-seal signature moment; harvest gold carries identity and headlines; garden green is used sparingly for the reward motif.
- Mixed type system: a warm display serif for headlines, a monospace for ledger figures/labels, a humanist sans for body copy — mirroring a real almanac's masthead + ledger + prose registers.
- Structure borrows almanac/ledger conventions (dotted leaders, dashed rules, tabular entries, seasonal brackets) instead of icon-plus-heading card grids.
- Motion is deliberately restrained to two authored moments: the harvest-chart bars growing in, and a wax seal stamping down on successful sign-up — not a scroll-fade applied uniformly to every section.

## Colors

The palette reads as a lamp-lit ledger book: soil-dark ground, warm gold for identity, oxblood crimson reserved for action, garden green used only for the reward motif.

### Primary
- **Oxblood Crimson** (`#a3392a`, hover `#bb4736`, deep `#832a1e`): the one saturated action color — every button, the wax-seal stamp, the CTA underline. Deliberately not the bright signal-red a generic "warm + red accent" brief tends to produce; richer and more ink-like.

### Secondary
- **Harvest Gold** (`#d89b3c`, bright `#f0c874`, deep `#b8802e`): headlines' accent glow, dividers, the seed icon, dateline highlights. Carries the almanac's identity register.

### Tertiary
- **Garden Forest** (`#46612f`, bright `#5c7d44`, deep `#334a21`): reserved for the reward motif specifically — sprout/tree icons, the lower half of the harvest-chart bars. Never used for UI chrome or text.

### Neutral
- **Ground Ink** (`#2a1d14`, deep `#180f09`): the page's own background — a soil-brown dusk, not a neutral gray or near-black.
- **Ledger Paper** (`#f2e4c6`, bright `#f7ecd2`): the lamplit inset surface for every card, table, and chart sheet. Textured with a subtle warm grain (see Elevation & Depth) — never a flat fill.
- **Cream Text** (`#f3e9d2`) / **Tan Muted** (`#c9b08a`): primary and secondary text on the dark ground. Secondary text is tinted warm from the ground hue, never plain gray.

### Named Rules
**The Paper-Never-Is-The-Page Rule.** Ledger paper (`#f2e4c6`) is only ever a card, table, or chart surface pinned onto the dark ground — it never becomes the page's own background. This is what keeps the world out of the generic "warm cream page" pattern.

**The One Red Rule.** Crimson is the only saturated color used for interactive action (buttons, form focus, the seal). Gold and forest never carry a clickable affordance, so the eye always knows what crimson means.

**The Paper Context Rule.** Every text/badge/button color in this system was tuned for one of two grounds — the dark soil ink or the light ledger paper — and the two are not interchangeable. `page-title`, `page-lede`, `field label`, `field-error`, `form-alert--error/--info`, `button--ghost`, and every `badge--*` default to cream/tan/light tones for the dark ground; each has a `.panel `-scoped override (in `app.css`) that darkens it to an ink/muted-ink/600-series tone instead. This was learned the hard way in the dashboard build: reusing a dark-ground primitive inside a `.panel` without its paper override produces text that is present in the DOM but functionally invisible (a real contrast failure, not a style nitpick). Any new primitive must ship both variants before it ships inside a panel.

## Typography

**Display Font:** Fraunces Variable (fallback: Fraunces, ui-serif, Georgia, serif)
**Body Font:** Plus Jakarta Sans Variable (fallback: ui-sans-serif, system-ui, sans-serif)
**Label/Mono Font:** Space Mono (fallback: ui-monospace, SFMono-Regular, Menlo, monospace)

**Character:** Fraunces supplies the masthead's warmth and print heritage for headlines and ledger-entry terms; Space Mono renders every dateline, tag, and tabular figure with a typewriter-ledger character; Plus Jakarta Sans carries body prose in a plain, readable voice so the display and label faces stay the ones with personality.

### Hierarchy
- **Display** (600, `clamp(2.75rem, 5.4vw, 6.25rem)`, line-height 1.05): the H1 masthead headline only.
- **Headline** (600, `clamp(2rem, 3.4vw, 2.5rem)`): section H2s ("Four entries. One season of studying.", etc.).
- **Title** (600, `1.3125rem`, Fraunces): ledger entry terms (mechanism step names, almanac table row headers).
- **Body** (400, `1.0625rem`, line-height 1.55, measure ≤62ch): all prose paragraphs.
- **Label** (400, `0.6875rem`, letter-spacing `0.14em`, uppercase, Space Mono): datelines, sample tags, chart month labels, semester brackets.

### Operate mode (dashboard)

The landing page's fluid `clamp()` scale is a Persuade-mode device and does not carry into the dashboard. Operate surfaces use a fixed rem scale instead: page titles at `1.75rem`, panel titles at `1rem`, body/labels at `0.8125–0.9375rem` — no `clamp()`, no viewport-relative sizing. Fraunces is still used, but only for page titles and ledger row-entry names (exam/category titles); every button, label, badge, and numeric value in the dashboard is Plus Jakarta Sans or Space Mono, never the display face.

### Named Rules
**The No-Kicker Rule.** No section ever carries a small eyebrow label above its own heading; the almanac's dateline furniture (volume/date lines) is masthead convention, not a marketing kicker, and appears only once, at the very top of the page.

## Layout

Single-column marketing page, `max-width: 78rem` content well, edge padding `clamp(1.5rem, 5vw, 4rem)`. Section vertical rhythm uses an open spacing scale (`0.25rem` → `11rem`); the space above a heading is always generous relative to the space below it. Two-column splits (hero copy + yield card; CTA copy + wax seal) collapse to a single stacked column under 900px / 760px respectively. The header is sticky with a blurred, semi-opaque dark backdrop so content stays legible scrolling beneath it; below 860px it collapses to a hamburger toggle with an animated X state.

**Dashboard shell (Operate):** a fixed `15rem` sidebar (brand + vertical nav + user/logout footer) beside a `72rem`-max content column, both on the same dark ground as the marketing page. Below 860px the sidebar collapses to a slim top bar (brand + hamburger only); the hamburger — the same morph-to-X control as the marketing header — expands the full nav list plus user/logout inline below the bar. This replaced an earlier horizontal-scrolling nav-strip attempt, which hid most of the nav off-screen with no scroll affordance; a hamburger that reveals everything at once is the correct pattern here, not a novel one.

## Elevation & Depth

The dark ground conveys depth with a soft radial gold glow (not a shadow) fading from the top of the page, plus a faint SVG-noise grain across the whole background for material honesty. Ledger paper surfaces are lifted with a single soft, offset drop shadow (`0 22px 40px -18px rgba(12,7,4,0.65)`) plus a 1px inner highlight — never a zero-offset colored halo. Paper surfaces also carry their own subtle warm-toned grain texture (a low-opacity SVG turbulence layer blended over the solid fill) so they read as paper, not flat CSS color.

### Shadow Vocabulary
- **paper-lift** (`0 1px 0 rgba(255,255,255,0.4) inset, 0 22px 40px -18px rgba(12,7,4,0.65)`): every `.paper` card, table sheet, and chart sheet.
- **button-press** (`0 2px 0 var(--crimson-600)`, deepening to `0 6px 0` on hover, flattening to `0 1px 0` on active): the primary button's tactile, printed-stamp feel.

### Named Rules
**The Grain-Not-Gloss Rule.** Depth on paper surfaces comes from grain and a soft offset shadow, never from a gradient overlay standing in for texture, and never from a fake bevel/emboss filter pretending the wax seal or paper has physical relief it doesn't render.

## Shapes

Cards, tables, and chart sheets use a tight `6px` corner radius — read as trimmed paper, not the softer `12–16px` rounding of a generic app card. Tags/pills use full `999px` radius, reserved for small inline labels only. The wax seal is a true circle (`50%`). No borders stand alone; every surface break is either the paper's own edge (shadow-defined) or a dashed/dotted ledger rule (never a solid colored `border-left`).

## Components

### Buttons
- **Shape:** `6px` radius, never pill-shaped.
- **Primary:** crimson fill (`#a3392a`), cream text, `0.85rem 1.6rem` padding, printed-stamp shadow that deepens on hover and flattens on press (`translateY` + shadow-depth change, not opacity).
- **Ghost:** transparent fill, cream text, gold-tinted border at 45% mix on the dark ground; inside a `.panel` it switches to ink text and a crimson-tinted border (see The Paper Context Rule).
- **Disabled:** `opacity: 0.45`, `cursor: not-allowed`, hover/press transforms and shadow-depth changes suppressed — never just a label change ("Planting…") with no visual dimming.
- **Small variant:** `0.55rem 1.1rem` padding, used in the sticky header and dashboard sidebar.

### Tags
- **Style:** transparent background, `999px` pill radius, 1px border at 40% mix of the muted tan, uppercase Space Mono label.
- **Sample variant:** border and text shift to gold at 55%/full — marks every piece of illustrative/demo data on the page ("Sample ledger", "Sample season"). This tag is a truth-labeling device, not decoration; it must accompany any invented number until a real hosted instance exists.

### Cards / Containers (`.paper`)
- **Corner Style:** `6px`.
- **Background:** ledger paper (`#f2e4c6`) with warm grain texture (see Elevation & Depth).
- **Shadow Strategy:** paper-lift (see above).
- **Border:** none — the shadow and grain define the edge.
- **Internal Padding:** scale step `lg` (`3.25rem`) typical for a full sheet; `md` (`2rem`) for the hero's smaller yield card.

### Ledger Table
- **Style:** borderless table; each row's cells carry their own dashed bottom rule (`1px dashed`, 18–22% mix of ink) so a term's rule spans only its own column width, like an underline on a receipt line.
- **Header row** (`th[scope=col]`): uppercase Space Mono labels, solid 1px rule beneath.
- **Row entries** (`th[scope=row]`): Fraunces, normal case, full body size, ink-colored — this lives in the shared `.ledger-table` primitive (`ui.css`), not per-page overrides, so an exam or category title always reads as a title everywhere this table is reused, never as a second row of column-header styling.

### Navigation
- **Style:** sticky, blurred dark backdrop; anchor links in muted tan, gold on hover; primary CTA always visible as the small button variant.
- **Mobile:** hamburger toggle that morphs into an X (two bars rotating to ±45°) on open; the mobile panel is a simple stacked list under the header, no overlay/scrim. The dashboard sidebar reuses this exact control below 860px rather than inventing a second mobile-nav pattern.

### Wax Seal (signature component)
A crimson circle (drop-shadowed, dashed inner ring, a simple cream seed/tree glyph) used once, in the final sign-up section. On successful sign-up it plays a single authored "stamp down" keyframe (falls from above, overshoots slightly, settles) — the page's one moment of physical, printed-object motion, intentionally not reused anywhere else.

### Dashboard shell & panels (Operate)
- **Sidebar:** fixed `15rem` on desktop; brand, vertical `DashboardNav` (active item gets a crimson-tinted background, never a border-left accent), user name/email, small ghost logout button.
- **Panel (`.panel`):** the same grained ledger-paper surface as `.paper`, used as the dashboard's default content container — forms, tables, stat tiles, tree cards all live inside one.
- **Stat tile:** a `.panel` holding one icon/number/label triple, left-aligned, Fraunces for the number. Used for seeds/nutrients/trees/average-score summaries; three or four per row, `repeat(auto-fill, minmax(...))` collapsing to two columns under 640px.
- **Badge:** difficulty (beginner/intermediate/advanced) and tree-phase (seed/growing/mature/fall) status pills. Same component, two color contexts — see The Paper Context Rule; a badge on the dark ground (e.g. an exam-detail header) uses the light tone, the same badge inside a `.panel` table cell uses the panel-scoped dark tone.
- **Empty state:** dashed gold-tinted border, bold headline plus one instructional sentence ("Add your first one above — exams get organized underneath it") — always dark-ground styled, since it's never placed inside a `.panel`.
- **Skeleton loader:** a shimmering muted-tan bar, used in place of a spinner for any panel still loading.

## Do's and Don'ts

### Do:
- **Do** keep ledger paper (`#f2e4c6`) as an inset surface only — cards, tables, chart sheets — never the page's own background.
- **Do** tag every invented number or chart with a "Sample ledger"/"Sample season" pill until the product has a real hosted instance with real user data.
- **Do** reserve crimson for action and the one signature seal moment; keep gold and forest out of clickable chrome.
- **Do** texture every `.paper` surface with the grain treatment — a flat solid fill on ledger paper reads as machine-made in this world.
- **Do** default motion to visible-first: any scroll-triggered animation must render its content fully even if the trigger never fires (no JS-only content).
- **Do** give every interactive component all of default/hover/focus/active/disabled/loading/error states before shipping it — a button that only changes its label text when disabled is not done.
- **Do** reuse the marketing header's hamburger-to-X pattern for any new mobile nav rather than inventing a horizontal-scroll strip or a different toggle.

### Don't:
- **Don't** add a kicker/eyebrow label above any section heading — the almanac dateline at the very top of the page is the only masthead-convention exception, and it appears once.
- **Don't** use icon-plus-heading-plus-text card grids for feature lists; use the ledger/table/entry vocabulary established in Mechanism and Almanac sections instead.
- **Don't** fake physical relief (CSS bevel/emboss/stamped-metal filters) on the wax seal or paper cards — commit to real grain texture and flat, confident vector instead.
- **Don't** apply the same scroll-reveal fade to every section; the page's motion budget is the harvest-chart grow-in and the wax-seal stamp, not a uniform per-section entrance.
