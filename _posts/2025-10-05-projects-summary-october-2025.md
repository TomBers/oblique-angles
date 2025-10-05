---
layout: post
title: "Projects summary — October 2025"
date: 2025-10-05 00:00:00 +0000
categories: projects
---

A quick roundup of what I’ve been building and exploring in October 2025.

## Main project: MuDG

MuDG is a collaborative learning tool built on top of LLMs. It routes model answers into a graph data structure so you can branch, recombine, and drill deeper into topics while discovering related ideas.

Innovations:
- Make AI conversations public so others can contribute, correct rabbit holes, and build shared knowledge.
- Store conversations as a graph, enabling branching paths and later synthesis.
- Visualize and persist knowledge so it can grow meaningfully over time.

Live: [mudg.fly.dev](https://mudg.fly.dev/)

## Games projects

### WordGo
Exploring how modern AI embeddings can enable new kinds of word games. By treating words as vectors, we can score “semantic distance” between words and blend that with positional play on a Go-like board. Each placed piece is associated with a word; scoring balances board position with the semantic similarity of chosen words.

Live: [wordgo.fly.dev](https://wordgo.fly.dev/)

### TimeLine
How well do you know your history? Arrange events in chronological order. Two modes:
- Buckets: drop events into the correct time buckets.
- Full timeline: place events with accurate durations and overlapping time periods.

Live: [timeline-game.fly.dev](https://timeline-game.fly.dev/)

## Ongoing experiment: Statelang

Statelang is an experiment in state-first programming: centering design on state machines and deriving the rest of the application (web, API, mobile) from that model.

- Post: [https://tombers.github.io/oblique-angles/ai/education/2025/03/23/state-lang.html](https://tombers.github.io/oblique-angles/ai/education/2025/03/23/state-lang.html)
- Repo: [https://github.com/TomBers/state_lang](https://github.com/TomBers/state_lang)
