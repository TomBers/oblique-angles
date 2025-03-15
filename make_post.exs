IO.puts("Hello, World!")
IO.inspect(System.argv())

contents = fn title, date ->
  """
  ---
  layout: post
  title: "#{title}"
  date: #{date} 09:44:02 +0000
  categories: humour media
  ---

  # #{title}
  """
end

date = Date.utc_today() |> Date.to_string()

title =
  System.argv()
  |> List.first()
  |> String.trim()
  |> String.downcase()

file_name = date <> "-" <> title <> ".md"

File.write!(file_name, contents.(title, date))
