defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic
    alias Discuss.Router.Helpers

    plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
    plug :check_topic_owner when action in [:update, :edit, :delete]



    def index(conn, _params) do
        topics = Repo.all(Topic)
        render conn, "index.html", topics: topics
    end


    def show(conn, %{ "id" => topic_id}) do
        topic = Repo.get!(Topic, topic_id)
        render conn, "show.html", topic: topic
    end


    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end


    def create(conn, %{"topic" => %{"description" => description, "image" => image_params, "title" => title}} = topic) do

        file_uuid = UUID.uuid4(:hex)        
        image_filename = image_params.filename
        unique_filename = "#{file_uuid}-#{image_filename}"
        {:ok, image_binary} = File.read(image_params.path)           
        
        bucket_name = "basim-image-storage-bucket"

        bucket_name 
        |> ExAws.S3.put_object(unique_filename, image_binary, [acl: :public_read])
        |> ExAws.request!

        topic_params = %{
            title: title,
            description: description,
            image_url: "https://#{bucket_name}.s3.amazonaws.com/#{bucket_name}/#{unique_filename}"
        }

        changeset = conn.assigns.user
        |> build_assoc(:topics)
        |> Topic.changeset(topic_params)

        #inserts the new topic into the database
        case Repo.insert(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic created")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                render conn, "new.html", changeset: changeset
        end
    end

    def create(conn, %{"topic" => %{"description" => description, "title" => title}} = topic) do
        topic_params = %{
            title: title,
            description: description,
        }

        changeset = conn.assigns.user
        |> build_assoc(:topics)
        |> Topic.changeset(topic_params)

        #inserts the new topic into the database
        case Repo.insert(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic created")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                render conn, "new.html", changeset: changeset
        end
    end


    def edit(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
    end


    def update(conn, %{"id" => topic_id, "topic" => topic}) do

        changeset =
        Repo.get(Topic, topic_id) |> Topic.changeset(topic)
        
        Repo.update(changeset)
        |> handle_update(conn)
    end


    def delete(conn, %{"id" => topic_id}) do
        Repo.get!(Topic, topic_id) |> Repo.delete!
        conn
        |> put_flash(:info, "Topic has been deleted")
        |> redirect(to: topic_path(conn, :index))
    end

    def check_topic_owner(conn, _params) do
        %{params: %{"id" => topic_id}} = conn
        
        if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
            conn
        else
            conn
            |> put_flash(:error, "You cannot edit that")
            |> redirect(to: topic_path(conn, :index))
            |> halt()
        end
    end


    defp handle_update({:ok, _topic}, conn) do
        conn
        |> put_flash(:info, "Topic has been updated")
        |> redirect(to: topic_path(conn, :index))
    end

    defp handle_update({:error, changeset}, conn) do
        render conn, "new.html", changeset: changeset
    end
  end
  