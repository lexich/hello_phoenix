defmodule JsonSplitter do
  @behaviour Plug

  def init(options), do: options

  def call(conn, _opts) do
    case getId conn.params do
      :none ->
        conn
      id ->
        params = %{ conn.params | "id" => id }
        %{ conn | params: params }
    end
  end

  defp getId(%{"format" => "json", "id" => id }) do
    [newId | _format] = String.split(id, ".")
    newId
  end

  defp getId(_) do
    :none
  end
end
