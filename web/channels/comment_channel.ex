defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel

    alias Discuss.{Topic, Comment}

    def join("comments:" <> topic_id, _params, socket) do
        topic_id = String.to_integer(topic_id)
        topic = Topic
        |> Repo.get(topic_id)
        |> Repo.preload(:comments)

        {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
    end


    def handle_in(name, %{"content" => content}, socket) do
        topic = socket.assigns.topic
        changeset = topic
        |> build_assoc(:comments)
        |> Comment.changeset(%{content: content})

        Repo.insert(changeset)
        |> handle_insert(changeset, socket)
    end

    defp handle_insert({:ok, comment}, changeset, socket) do
        {:reply, :ok, socket}
    end

    defp handle_insert({:error, _reason}, changeset, socket) do
        {:reply, {:error, %{errors: changeset}}, socket}
    end
end