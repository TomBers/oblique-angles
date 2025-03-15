# For Elixir 1.12+
Mix.install([
  {:jason, "~> 1.2"}
])

# Get command line arguments
[title | rest] = System.argv()
notes = Enum.join(rest, " ")

# Functions
defmodule PostGenerator do
  def contents(title, date, draft) do
    """
    ---
    layout: post
    title: "#{title}"
    date: #{date} 09:44:02 +0000
    categories: ai education
    ---
    # #{title}
    #{draft}
    """
  end

  def extract_keywords(notes) do
    notes
    |> String.split(~r/[\s,;.]+/, trim: true)
    |> Enum.filter(fn word -> String.length(word) > 3 end)
    |> Enum.take(5)
    |> Enum.join(", ")
  end

  def template(notes, keywords) do
    """
    ## Introduction
    <!-- Hook your readers with an engaging opening about #{keywords} -->

    #{notes}

    ## Main Points

    ### The Convenience Paradox
    <!-- Discuss how AI makes learning more accessible but might reduce effort -->

    ### Redefining Educational Goals
    <!-- Explore how AI changes what we need to learn and how -->

    ### The New Teacher-Student Dynamic
    <!-- Analyze how having an AI tutor changes the learning relationship -->

    ## Personal Reflection
    <!-- Share your personal take or experience related to using AI for learning -->

    ## Conclusion
    <!-- Wrap up with a thought-provoking statement about the future of education with AI -->

    ---

    **Keywords**: #{keywords}

    **Related posts**: <!-- Link to 2-3 related posts if applicable -->

    **Resources**: <!-- Add any helpful resources or references -->
    """
  end

  def generate_from_api(api_key, title, notes, keywords) do
    prompt = """
    Write a blog post draft with the title "#{title}" based on these notes: #{notes}

    Keywords to include: #{keywords}

    Structure the post with:
    1. An introduction that hooks the reader
    2. Three main sections discussing:
       - How AI might breed laziness vs. enhance learning
       - The potential educational arms race
       - How AI changes the purpose of education
    3. A section on the benefits of having an AI teacher
    4. A personal reflection
    5. A thought-provoking conclusion

    Keep it conversational and nuanced, showing both sides of these issues.
    """

    request_body =
      Jason.encode!(%{
        "model" => "gpt-4",
        "messages" => [
          %{
            "role" => "system",
            "content" =>
              "You are a thoughtful blog post writer who can see multiple sides of complex issues."
          },
          %{"role" => "user", "content" => prompt}
        ],
        "temperature" => 0.7
      })

    # Using built-in :httpc instead of HTTPoison
    headers = [
      {'Content-Type', 'application/json'},
      {'Authorization', 'Bearer #{api_key}'}
    ]

    request = {
      'https://api.openai.com/v1/chat/completions',
      headers,
      'application/json',
      request_body
    }

    # Make sure inets is started
    :inets.start()
    :ssl.start()

    case :httpc.request(:post, request, [], []) do
      {:ok, {{_, 200, _}, _, response_body}} ->
        decoded = Jason.decode!(response_body)
        decoded["choices"] |> List.first() |> Map.get("message") |> Map.get("content")

      error ->
        IO.puts("API call failed: #{inspect(error)}. Using template.")
        template(notes, keywords)
    end
  end

  def draft(title, notes) do
    # Extract potential keywords from notes
    keywords = extract_keywords(notes)

    # Try to use LLM API, fall back to template if it fails
    api_key = System.get_env("OPENAI_API_KEY")

    if is_nil(api_key) do
      IO.puts("No API key found. Using template.")
      template(notes, keywords)
    else
      try do
        generate_from_api(api_key, title, notes, keywords)
      rescue
        e ->
          IO.puts("Error with API: #{inspect(e)}")
          template(notes, keywords)
      end
    end
  end
end

# Main execution
date = Date.utc_today() |> Date.to_string()
post_path = "_posts"
file_name = date <> "-" <> String.replace(String.downcase(title), " ", "-") <> ".md"
path = Path.join(post_path, file_name)

unless File.exists?(post_path), do: File.mkdir_p!(post_path)

draft_content = PostGenerator.draft(title, notes)
contents = PostGenerator.contents(title, date, draft_content)
File.write!(path, contents)

# Print confirmation
IO.puts("Created blog post: #{path}")
