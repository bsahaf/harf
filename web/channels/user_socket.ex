defmodule Discuss.UserSocket do
  use Phoenix.Socket

  # * sets the wildcard and routes everything to the CommentsChannel
  channel "comments:*", Discuss.CommentsChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    Phoenix.Token.verify(socket, "key", token)
    |> handle_auth(socket)
    {:ok, socket}
  end

  def id(_socket), do: nil

  defp handle_auth({:ok, user_id}, socket) do
    {:ok, assign(socket, :user_id, user_id)}
  end
  
  defp handle_auth({:error, _error}, socket) do
    :error
  end
end
