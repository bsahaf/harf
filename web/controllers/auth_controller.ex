defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        user_params = %{
            token: auth.credentials.token,
            email: auth.info.email,
            provider: "github"
        }

        changeset = User.changeset(%User{}, user_params)
        signin(conn, changeset)
    end

    def signout(conn, _params) do
        conn 
        |> configure_session(drop: true)
        |> redirect(to: topic_path(conn, :index))
    end

    defp signin(conn, changeset) do
        insert_or_update_user(changeset)
        |> handle_signin(conn)
    end

    defp insert_or_update_user(changeset) do
        Repo.get_by(User, email: changeset.changes.email)
        |> handle_response(changeset)
    end

    defp handle_response(nil, changeset) do
        Repo.insert(changeset)
    end

    defp handle_response(user, changeset) do
        {:ok, user}
    end

    defp handle_signin({:ok, user}, conn) do
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
    end

    defp handle_signin({:error, _reason}, conn) do
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
end