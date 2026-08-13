# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Svelte (user-specified for the landing page). The product's API is a Ruby on Rails backend (JWT auth, Neo4j + Postgres); the landing page is a separate marketing surface, not the app itself.

## Users

Primary users are self-learners and students studying for exams or certifications who want a gamified, low-friction way to memorize material through flashcards and spaced revision, rather than passive reading.

## Product Purpose

Flashmemo lets people build and drill flashcard-style questions (true/false, multiple choice, "duo" combinations) organized into exams and categories, then revisit weak spots through scheduled revisions and mind maps. Success is a user who keeps coming back to study because the app makes progress visible and rewarding, not because they're forced to.

## Positioning

The differentiating mechanism is the "Trees Rewards System": correct answers earn seeds, seeds plant trees tied to the subject/matter being studied, and trees are harvested into a garden that visualizes accumulated knowledge over time. It reframes studying progress as something you grow, not just a score or streak counter.

## Operating Context

- Users create exams (collections of questions) inside categories/subjects.
- Question types: true/false, multiple option, and "duo" combination.
- Revisions resurface previously answered material for spaced review.
- Mind maps are a supporting study tool (per app models/use cases).
- Progress is tracked by period: monthly, yearly, semester.
- Rewards loop: answer → earn seeds → plant trees → harvest → build a garden.
- Auth is via user account creation and sign-in (JWT).

## Capabilities and Constraints

- Confirmed: exams, categorized questions (3 question types), revisions, per-period progress tracking, JWT-based accounts, the seeds/trees/garden reward loop, mind maps.
- The landing page is the marketing entry point for a **hosted instance** of the app: its primary job is to convert visitors into sign-ups, not merely to describe or link to the source repository.
- No production hosted URL is confirmed yet as of this writing — the sign-up flow is the target CTA, but where it points (live app vs. waitlist) is undecided and should not be fabricated as an existing product screenshot beyond what's on hand (see Evidence on Hand).

## Brand Commitments

No logo, wordmark, or established color system exists yet. The user has requested warm colors with red as an accent — this is a binding constraint, not a suggestion, and should anchor the visual world new-work establishes. The README uses 🟦🟩🟨 (blue/green/yellow squares) and a 🌲 tree emoji informally; these are not confirmed brand commitments.

## Evidence on Hand

- `.github/images/rewards-system.png`: an existing screenshot demonstrating the rewards system, usable as real evidence.
- No testimonials, customer logos, press mentions, or pricing exist — none should be fabricated.

## Product Principles

1. Progress should feel visible and cumulative (trees/gardens), not abstract (bare percentages).
2. Studying mechanics (question types, revisions) are the substance; the rewards system is the hook that keeps people returning.
3. The page sells joining a living study habit, not a static software feature list.
4. Warm, red-accented visual identity should feel energetic and encouraging, not alarming — red as accent, not dominant.

## Accessibility & Inclusion

No product-specific accessibility requirement was established beyond standard web accessibility practice.
