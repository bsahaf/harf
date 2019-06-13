defmodule Discuss.ProfileController do
    use Discuss.Web, :controller
    
    alias Discuss.User
    alias Discuss.Topic

    plug Discuss.Plugs.RequireAuth when action in [:index]

    def index(conn, _params) do
        user_profile = 
        Repo.get_by(User, email: conn.assigns.user.email)
        |> get_user_profile

        render conn, "profile.html", profile: user_profile
    end

    defp get_user_profile(changeset) do
        %{
            name: changeset.name,
            email: changeset.email,
            image_url: changeset.image_url,
            join_date: changeset.inserted_at
        }
    end
  end