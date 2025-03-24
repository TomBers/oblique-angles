---
layout: post
title: "state lang p2"
date: 2025-03-24 09:44:02 +0000
categories: ai education
---
# state lang p2
---
title: "state lang p2: A FSM First Approach to Programming Part 2"
date: 2023-10-XX
categories: [FSM, state, lang, templates, API]
---

## Introduction

Imagine a tool that not only manages your application's state but also renders fully dynamic web templates without needing to switch contexts. In our previous post, ["state lang"](https://tombers.github.io/oblique-angles/ai/education/2025/03/23/state-lang.html), we introduced a state-first approach to program design that placed the state machine at the core of application logic. Although effective, its rendering system was limited to simple iterations of inputs and outputs. Today, we extend the concept. *tldr:* We extend state lang to include full template renderingâturning it into a fully flexible application building tool. And yes, there are fun extras too, like a built-in timer (a web game loop) and an API endpoint for handling web requests and webhooks!

## Extending the State Lang: Going Beyond Just State Management

At its heart, state lang reimagined programming by making state transitions central to application design. However, one significant limitation was that rendering was extremely basic. We were simply iterating over inputs and outputsâinsufficient for modern web development. The next evolution was to integrate full template rendering, transforming every state into a fully rendered page.

This exciting enhancement leverages the powerful **Heex** templating engine from Phoenix Liveview. Instead of rethinking the web's current core technologies (HTML, CSS, and JS) altogether, we simply build on top of an existing, battle-tested system. With Heex, you now have:

- **Full templating capabilities:** Create dynamic, interactive, and visually rich pages.
- **Seamless integration:** Integrate with your state-first logic without complex rewrites.
- **Flexibility:** Build websites, APIs, and even mobile apps from a single code base.

Check out the complete example of our new implementation on [GitHub](https://github.com/TomBers/state_lang).

## Key Insights and Extensions

### 1. A Modern Templating Revolution in State Lang

The introduction of Heex is a game-changer for state lang. By integrating this template language, you can now build fully dynamic apps without losing the benefits of explicit state management. The code snippet below demonstrates how a state machine transitions through different states while rendering a complete template:

```elixir
defmodule StateLang.States.TemplateTest do
  use StateLangWeb, :live_view

  @state %{output: "Red", cycles: 0, count: 0}

  # State Red -> Orange -> Green -> Red * 5 then End
  # State transition functions
  def change_state(%{cycles: cycles} = state, _) when cycles >= 3, do: %{state | output: "END"}
  def change_state(%{output: "Red"} = state, _), do: %{state | output: "Orange"}
  def change_state(%{output: "Orange"} = state, _), do: %{state | output: "Yellow"}
  def change_state(%{output: "Yellow"} = state, _), do: %{state | output: "Green"}

  def change_state(%{output: "Green"} = state, _),
    do: %{state | output: "Red", cycles: state.cycles + 1}

  # Message recieved function
  def message_call(state, _), do: state

  # Timer function
  def timer(state), do: %{state | count: state.count + 1}

  # Output function
  def output_state(state), do: "#{state.output} [cycles: #{state.cycles}] count: #{state.count}"

  def render(assigns) do
    ~H\"""
    <div>
      <p class="output-name">Current State:</p>
      <p class="output-value">{output_state(@state)}</p>

      <.button
        phx-click="change_state"
        class="rounded-md bg-black-800 py-2 px-4 mb-4 border border-transparent text-center text-sm transition-all shadow-md hover:shadow-lg focus:bg-slate-700 focus:shadow-none active:bg-slate-700 hover:bg-slate-700 active:shadow-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none ml-2"
      >
        Change State
      </.button>

      <div class="events-container">
        <h1>Events:</h1>
        <ul>
          <%= for event <- @events do %>
            <li>{event}</li>
          <% end %>
        </ul>
      </div>
    </div>
    \"""
  end

  def state_machine do
    %{
      initial_state: @state,
      module: __MODULE__,
      transitions: [
        "change_state"
      ],
      timer_interval: 2000
    }
  end
end
```

### 2. Built-In Game Loop: The Clock That Ticks

One of the fun extensions included is a built-in timer function that acts like a game loop for your web application. Much like a clock in a video game constantly updating the screen, this timer ticks every few milliseconds, allowing your app to update smoothly without any manual intervention. For example:

```elixir
# Timer function
def timer(state), do: %{state | count: state.count + 1}
```

This simple addition enables continuous state updates, making your application interactive and responsive by default.

### 3. A Versatile API for Seamless Integration

Another significant extension is the inclusion of an API endpoint. By setting up a message inbox in every app, you can receive and process messages from other systems with ease. Itâs as simple as defining:

```elixir
# Message received function
def message_call(state, _), do: state
```

This approach not only simplifies the integration of external web requests and webhooks but also transforms your state machine into a reactive system capable of handling asynchronous events from various sources.

## Personal Reflection

Working on this project has been an enlightening journey. Iâve always believed that explicit state management carries immense power when applied correctly, but the visual limitations were frustrating. By extending state lang with Heex, the blend of a powerful state machine and modern web rendering feels like a natural evolution. Itâs a reminder of how even simple ideas can transform into robust systems with the right tools and mindset. I'm particularly excited about the potential of a single code base that can handle websites, APIs, and mobile apps alike. It opens up endless possibilities for developers looking for simplicity without sacrificing functionality.

## Conclusion: A New Era for State-driven Applications

The evolution of state lang is an example of how thinking differently about programming paradigms can yield practical benefits. By extending state lang to fully include template rendering, combining a continuous timer and a built-in API, we pave the way for building truly flexible, state-aware applications. As we look to the future, a few next steps become apparent:

- Persist state to allow for resuming complex computations.
- Enhance the API to ensure the server is always ready to process external requests.
- Explore mobile app integrations with tools like Live View Native for a seamless cross-platform experience.

This project is a bold step towards a unified application-building toolâa tool where state, templates, and extension points like timers and APIs are all part of one coherent vision. What are your thoughts on state-driven programming? Could this approach redefine how we build digital experiences? Letâs spark a conversation!

---

*Keywords: tldr:, Extend, state, lang, include*
