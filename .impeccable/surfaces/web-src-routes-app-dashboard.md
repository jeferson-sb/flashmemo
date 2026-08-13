---
version: 1
slug: "web-src-routes-app-dashboard"
primary_target: "web/src/routes/(app)/dashboard"
related_targets: []
---

## Scope & mode

Operate. Authenticated study app: sign in/up, organize categories, build and take exams, watch the garden grow, check progress. The visitor is doing a task, not being persuaded — the almanac world is inherited from DESIGN.md but restrained per operate.md (one accent for action/state only, fixed rem scale, no display-face labels/data, standard sidebar+content shell).

## Audience & job

Self-learners already convinced by the landing page, now doing the actual work: authoring their own flashcard content (this product has no separate admin — any signed-in user creates their own categories/exams/questions) and drilling it.

## Action / task

Core loop only, this pass: auth → categories → exams (browse/create) → exam detail (add questions) → take exam → score → garden (plant/nurture trees) → progress (average by period). Explicitly deferred: revisions practice, duos-matching, mind maps, surprise question.

## Proof / content

All content is real, user-authored data via the live Rails API — no synthetic/demo data here (unlike the landing page). Empty states teach the interface ("no categories yet — add one above") rather than saying "nothing here."

## Constraints

- Client-side only auth: bearer token in localStorage, no SSR for this route group (`ssr=false`, `prerender=false`, adapter-static `fallback: '200.html'`).
- API base URL via `PUBLIC_API_BASE_URL` env var; CORS enabled on the Rails side for the dev origin.
- `sessions#show` (`GET /api/sessions`) and `user_id`/tree `id` fields on the gardens jbuilder views are small additive backend changes made to close real gaps (no "who am I" endpoint existed; garden list/show didn't expose enough to find "my garden" or nurture a specific tree).

## Chosen direction & memorable moment

Same Harvest Almanac world as the landing page (soil-brown ground, ledger-paper panels, oxblood accent, harvest-gold identity, garden-green reward motif), restrained for task use: sidebar nav + paper-panel content areas, tree phase/difficulty badges, a ledger-style ("Fraunces row header, dashed rule") table reused verbatim from the landing page's Almanac component. No new signature moment was added here — the CTA/seal belongs to the landing page's persuasion; the dashboard's only motion is functional (skeleton loaders, hover/press states, menu-toggle morph).

## Unresolved / left for next pass

- Revisions practice, duos-matching UI, mind-map visualization (API currently has no endpoint to read mind-map graph data back — write-only today), and the surprise-question flow.
- Question image upload (`questions#update` supports it; not built).
- No role/permission system exists in the API (any authenticated user can create exams/questions/categories) — dashboard doesn't gate this because the backend doesn't either.
