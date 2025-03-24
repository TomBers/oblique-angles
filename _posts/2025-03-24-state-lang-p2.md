---
layout: post
title: "A FSM first approach to programming part 2"
date: 2025-03-24 04:44:02 +0000
categories: ai education
---
## tldr:

Extend state-lang to include full template rendering, making a fully flexible application building tool
Some fun extras - a built-in timer to act as a 'game-loop' for websites and setting up of a api endpoint,
so any site can have a url for web requests / webhooks.

[Code](https://github.com/TomBers/state_lang)

---
## A FSM first approach to programming part 2

[The first post](https://tombers.github.io/oblique-angles/ai/education/2025/03/23/state-lang.html) suggested a state first approach to program design, where a state machine was the primary part of the progam and the rest was derrived.

One of the most obvious drawbacks were the rendering was extemely limited. Just an interation of inputs and outputs.

The next step was to make the rendered page completely general.

## Heex to the rescue

While I (quietly) hoped to rethink the whole process of rendering to the web, replacing in its entirety the current way the web works (HTML, CSS and JS); that is a problem for another day.

The simplest and easiest is to leveage the existing template language in [Liveview Heex](https://hexdocs.pm/phoenix_live_view/assigns-eex.html).  This allows a full templating engine allowing the building of fully general apps)

A full example [code - https://github.com/TomBers/state_lang](https://github.com/TomBers/state_lang):

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
    ~H"""
    <div>
      <p class="output-name">Current State:</p>
      <p class="output-value">{output_state(@state)}</p>

      <.button
        phx-click="change_state"
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
    """
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

## Event Log

Each state change is stored, so the precise state, action and new state are recorded.  This helps both in debugging issues, but also time travel, you can restart the app in any state you want.  Meaning that complex state management does not have to restart from the beginning, meaning if you have completed costly computation you do not have to rerun.

## Testing
As the state is a pure function - it make testing far simpler, without having to scaffold rendered Liveview components.

## Fun extensions

While not core to the central idea, there are a couple of extensions, experimenting with what is possible.

# Clock

Elixir makes it very each to setup callback functions to act as a clock.  In the same way a game loop works, the clock ticks every N milliseconds and you can write a function to update the state.

When writing you simply:
```elixir
 # Timer function
 def timer(state), do: %{state | count: state.count + 1}
```


# API

I thought it would be interesting for every app generated to have a message inbox, which can process messages from other systems.  This was as simple as writing an API endpoint that broadcast a pubsub message and the program having a function for dealing with messages.

You simply write:
```elixir
 # Message recieved function
  def message_call(state, _), do: state
```

## Next steps

There are a couple of obvious next steps.
- Persist state, this could be storing / loading state at any transition point
- API, for an API you want the server to always be on, listening to requests.  This would be as simple as using a GenServer and adding it to the supervision tree.
- Mobile Apps, I think this would be a good use case for [https://github.com/liveview-native/live_view_native](https://github.com/liveview-native/live_view_native)

So from a simple idea had about 5 days ago, it seems that it is not an impossible dream to have a single code base, with more expliict state-management that could build websites, API's and Mobile apps.

---

*Keywords: tldr:, Extend, state, lang, include*
