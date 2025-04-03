# For Elixir 1.12+
Mix.install([
  {:jason, "~> 1.2"}
])

defmodule PostGenerator do
  def generate_from_notes_file(notes_path) do
    # Extract title from file name (remove extension)
    title =
      notes_path
      |> Path.basename()
      |> Path.rootname()
      |> String.replace("-", " ")
      |> String.trim()

    # Read notes from file
    notes =
      case File.read(notes_path) do
        {:ok, content} ->
          content

        {:error, reason} ->
          IO.puts("Error reading file: #{reason}")
          exit(1)
      end

    # Generate blog post
    create_post(title, notes)
  end

  def create_post(title, notes) do
    date = Date.utc_today() |> Date.to_string()
    post_path = "_posts"
    file_name = date <> "-" <> String.replace(String.downcase(title), " ", "-") <> ".md"
    path = Path.join(post_path, file_name)

    # Ensure posts directory exists
    unless File.exists?(post_path), do: File.mkdir_p!(post_path)

    # Generate content
    draft_content = draft(title, notes)
    contents = contents(title, date, draft_content)

    # Write file
    File.write!(path, contents)

    # Print confirmation
    IO.puts("Created blog post: #{path}")
    {:ok, path}
  end

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

    ### Key Insight 1
    <!-- Develop your first main point here -->

    ### Key Insight 2
    <!-- Explore a contrasting or complementary idea -->

    ### Key Insight 3
    <!-- Provide a surprising perspective or deeper analysis -->

    ## Personal Reflection
    <!-- Share your personal take or experience related to this topic -->

    ## Conclusion
    <!-- Wrap up with a thought-provoking statement or call to action -->

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
    2. Three main sections with key insights related to the topic
    3. Personal reflection on the topic

    """

    request_body =
      Jason.encode!(%{
        "model" => "o3-mini",
        "messages" => [
          %{
            "role" => "system",
            "content" =>
              "The content is for a personal blog, the purpose is to share the journey of creating a new project and what can be learned about that journey from technical / social aspects, personal experiences, and potential pitfalls.
              It is fine to be a little bit sarcastic or humorous, it should demostate a strident point of view.
              Make sure you return valid markdown suitable for a Jekyll blog."
          },
          %{"role" => "user", "content" => prompt}
        ]
        # "temperature" => 0.7
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
        decoded = Jason.decode!(to_string(response_body))
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
      catch
        _, reason ->
          IO.puts("Error caught: #{inspect(reason)}")
          template(notes, keywords)
      end
    end
  end
end

# Main execution
case System.argv() do
  [notes_path | _] ->
    if File.exists?(notes_path) do
      PostGenerator.generate_from_notes_file(notes_path)
    else
      IO.puts("Error: Cannot find notes file at #{notes_path}")
    end

  [] ->
    IO.puts("Error: Please provide the path to a notes file")
    IO.puts("Usage: elixir gen_post_from_notes.exs path/to/notes/file.txt")
end
