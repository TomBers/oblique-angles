---
layout: post
title: "Experiment: A FSM first approach to programming"
date: 2025-03-23 09:44:02 +0000
categories: ai education
---
tags: [experiment, program, language, composition, idea]

## tldr:
Experiment in imaginging state management as the core of the programming experience. [Repo](https://github.com/TomBers/state_lang)

---

## Intro

Imagine a world where every program is designed from the ground up as a state machine. What if software development was less about juggling incidental complexities and more about focusing on the core, the state itself? This experiment in program language composition explores how we can reframe software design by centering on state, and let the rest of the applications, whether it's a web, API, or mobile apps be automatically derived from that state machine.

In this post, we dive into the idea behind "state lang", uncovering key insights drawn from real-world applications like Elixir's LiveView, and look into examples that illustrate our point. Grab a cup of coffee and join me on this exploratory journey.

---

## 1. The Heart of Every Program: Understanding State Machines

At its core, every program is a state machine. From receiving inputs to causing a chain reaction of change that leads to an output,the life cycle is the same. Yet, as our programs grow in size and complexity, the crucial element,the state,often becomes secondary to incidental complexities.

This is where the idea of "state lang" was born: What if, instead of treating state as just another part of the program, we designed our software by first defining a minimal, clear, and powerful representation of the state machine itself? By focusing on state as the primary concern, we could, in theory, generate various types of applications (web, API, mobile) from a single well-defined code base.

---

## 2. Meta-Programming Meets LiveView: A Fresh Approach to State Management

One exciting aspect of this idea is leveraging meta-programming to generate dynamic behavior. Elixir, with its robust ecosystem and tools like Phoenix and LiveView, presents an ideal test-bed for this concept. LiveView operates on a simple yet potent philosophy: every event to the server receives a version of the state and returns a new state. This mirrors the very essence of a state machine in action.

Here's the breakthrough: by creating a minimal state machine representation, we can map its components directly to LiveView elements. Consider the mapping:

- **Inputs:** These turn into `handle_event` functions in LiveView.
- **State Transitions:** The defined state transition functions correlate with the logic inside our event handlers.
- **Outputs:** They form the basis of the HEEx templates that render our user interface.

In this way, our state machine isn't just a theoretical model, it becomes a living, breathing part of dynamic web applications.

---

## 3. From Concept to Code: Real-World Examples

To ground these ideas, let's examine two straightforward yet illustrative examples of state machines.

### Example 1: A Todo List

For a simple Todo list, the initial state might list an empty collection of todos. An input of type text (to add a new Todo) triggers a state transition function which appends the new Todo to the list. The output function then displays the updated list.

```elixir
defmodule StateLang.States.Todo do
  @state %{"todos" => []}
  # State funcs
  def add_note(state, params), do: %{state | todos: state.todos ++ [Map.get(params, "Todo")]}
  # Output funcs
  def todo_state(state), do: Enum.join(state.todos, ", ")

  def state_machine do
    %{
      "initial_state" => @state,
      "module" => __MODULE__,
      "inputs" => [
        %{
          "name" => "Todo",
          "transition" => "add_note",
          "type" => "text"
        }
      ],
      "outputs" => [
        {
          "Todos",
          "list",
          :todo_state
        }
      ],
      "transitions" => [
        {"add_note", :add_note}
      ]
    }
  end
end
```

### Example 2: A Traffic Light Sequence

In this example, the traffic light cycles through Red, Orange, and Green states. A button input triggers the state transition function, which, upon reaching a specific cycle count, terminates the cycle.

```elixir
defmodule StateLang.States.TrafficLights do
  @state %{"output" => "Red", "cycles" => 0}

  # State Red -> Orange -> Green -> Red * 5 then End
  # State funcs
  def change_state(%{cycles: cycles} = state, _) when cycles >= 5, do: %{state | output: "END"}
  def change_state(%{output: "Red"} = state, _), do: %{state | output: "Orange"}
  def change_state(%{output: "Orange"} = state, _), do: %{state | output: "Green"}
  def change_state(%{output: "Green"} = state, _), do: %{output: "Red", cycles: state.cycles + 1}

  # Output funcs
  def output_state(state), do: "#{state.output} [cycles: #{state.cycles}]"

  def state_machine do
    %{
      "initial_state" => @state,
      "module" => __MODULE__,
      "inputs" => [
        %{
          "name" => "Change State",
          "transition" => "change_state",
          "type" => "button"
        }
      ],
      "outputs" => [
        {
          "Output",
          "text",
          :output_state
        }
      ],
      "transitions" => [
        {"change_state", :change_state}
      ]
    }
  end
end
```

Both examples underscore an intriguing idea: by encapsulating program behavior within state machines, complex applications can be distilled into clear, manageable pieces where state remains the central focus.

---

## 4. A Personal Reflection

I've long been a fan of Elixir, Phoenix, and especially LiveView.

After writing large programs, that grow over time, I notice that what should be central "the state" of the code takes a second place to incidental complexity, meaning that state is incidental to the running of the program instead of the primary concern.

---

## 5. Conclusion: Rethinking Software Through the Lens of State

This experiment in program language composition invites us to reimagine the software development process. By prioritizing state machines, we can simplify our code bases and bring a renewed focus on the essential mechanisms that drive our programs.

What if every input, every transition, and every output was a deliberate part of one cohesive state machine? Could this be the key to building more robust, adaptable applications?

I'd love to hear your thoughts, experiences, or any questions you have about this approach. Let's explore this idea further,after all, the best innovations often start as simple experiments that challenge the status quo.

Happy coding!

---

## Apprendix

Some other projects along these lines:

- [https://hackage.haskell.org/package/reactive-banana](https://hackage.haskell.org/package/reactive-banana)
- [https://gist.github.com/andymatuschak/d5f0a8730ad601bcccae97e8398e25b2](https://gist.github.com/andymatuschak/d5f0a8730ad601bcccae97e8398e25b2)
- [https://spotify.github.io/mobius/](https://spotify.github.io/mobius/)
- [https://xstate.js.org/](https://xstate.js.org/)
