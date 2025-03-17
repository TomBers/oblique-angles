---
layout: post
title: "Elixir LiveView - Phaser.js multiplayer game : pt1"
date: 2025-03-17 09:44:02 +0000
categories: ai education
published: true
---


## tldr: project outline

The outline of a simple structure for making games with Elixir Liveview and Phaser

[https://github.com/TomBers/build_a_boss](https://github.com/TomBers/build_a_boss)

![Screenshot]({{ site.baseurl }}/assets/img/game.png)

## Motivation

I am a fan of the Dark/Borne/Shekiro Souls series of games.  Part of the appeal of these games is the challenging boss combat.

One idea occured to me, imagine a Soul's like game where the objective is to build a boss character, adding attacks and magic.  This boss would then exist to be challenged by other players.

Each boss could be challenged and a global Win / Loss leader board for the most challenging bosses.  You then could play as the player character who can go out and defeat other bosses.

Unfortunately I am not a professional game developer, so this might be too ambititous.  However, it did raise a question of how you would even go about doing this.

## Getting started

For a few years [Elixir](https://elixir-lang.org/) and [Phoenix](https://www.phoenixframework.org/) have been my go-to web tools.  It prvides fully featured framework for building interactive websites.

The real game changers are [LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) and [Presence](https://hexdocs.pm/phoenix/presence.html).  Liveview maintains state on the server and broadcast changes.  Making highly reactive pages a pleasure to make.  Presense is a built-in means of tracking users, meaning it is easy to sync data between users.

The last part - FE game engine.  This is where I am less experienced, I came across [Phaser](https://phaser.io/v388) which seemed exactly what I was looking for.

## Why Elixir Phoenix & LiveView?

- **State Management Made Easy:** LiveView allows you to easily manage and update state without the overhead of writing complex JavaScript.
- **Real-time Updates:** With Phoenix channels integrated, you can push changes directly to the client in real time, perfect for a responsive multiplayer game.
- **Simplicity and Elegance:** The framework encourages you to focus on writing Elixir code, reducing the friction typically encountered in modern web development.

Using LiveView, we're building a system that interacts smoothly with our game engine, ensuring our multiplayer components have robust real-time communication. This seamless integration offers a promising starting point for scalable, networked game development.

## The Power of Phaser.js

While Elixir handles the backend magic, **Phaser.js** is the front-end game engine. It's designed to make game development accessible, even for beginners:

- **Ease of Use:** Phaser provides an intuitive API that simplifies game creation, allowing you to quickly prototype gameplay mechanics.
- **Rich Feature Set:** From physics to animations, Phaser offers a comprehensive toolkit that caters specifically to the needs of front-end game development.
- **Active Community:** With a wealth of tutorials, examples, and [community projects](https://phaser.io/news/category/game)

Integrating Phaser with Phoenix offers a multi-layered approach: while the game side focuses on user interactions and visual thrills, the backend powered by Phoenix ensures robust multiplayer support and real-time data handling.

## Bridging the Two Worlds: Multiplayer Dynamics

The combination of these two powerful frameworks allows us to overcome many challenges in **multiplayer** game development:

- **Synchronization:** LiveViews prowess in pushing real-time updates meshes well with Phaser's game loop, ensuring game state remains consistent across clients.
- **Scalability:** With Phoenix proven capability in handling concurrent connections gracefully, scaling our multiplayer logic becomes more achievable.
- **Ease of Development:** Both frameworks emphasize simplicity and efficiency, reducing boilerplate code and letting you focus on game mechanics rather than infrastructure.

This is the **first part** of our exploration, and already we're laying down a solid foundation for a sophisticated, interactive gaming experience that marries the best of backend and front-end technologies.

## Conclusion

Code: [https://github.com/TomBers/build_a_boss](https://github.com/TomBers/build_a_boss)

As we wrap up this **first part** of our multiplayer game series. Merging Elixir Phoenix and Phaser.js is a fun technical challenge and an exploration of new approaches in game development.

What are your thoughts on integrating diverse technologies for real-time gaming? Have you experimented with these frameworks before? The journey is just beginning, and there is a universe of exciting innovations waiting on the horizon.

Stay tuned for more insights, code snippets, and the evolution of our multiplayer game adventure. Happy coding!
