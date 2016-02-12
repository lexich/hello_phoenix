defmodule PathFormat do
  @behaviour Plug

  @pathReg ~r/(.+)\.(.+)$/

  def init(options), do: options

  def call(conn, opts) do
    path = conn.path_info |> List.last
    opts = Dict.merge %{ id: "id", key: "_format"}, opts
    cond do
      path == nil -> conn
      Regex.match?(@pathReg, path) ->
        extractor conn, Regex.scan(@pathReg, path), opts

      true -> conn
    end
  end

  defp extractor(conn, [[_, id, format]], %{key: keyName, id: idName}) do
    params    =
      conn.params
        |> Dict.put(keyName, format)
    params = if Dict.has_key? params, idName do
      Dict.put params, idName, id
    else
      params
    end
    tail      = Enum.slice conn.path_info, 1..-1
    path_info = [tail | id]
    %{conn | path_info: path_info, params: params }
  end

  defp extractor(conn, _, _) do
    conn
  end
end
