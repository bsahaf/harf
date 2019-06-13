defmodule Discuss.User do
    use Discuss.Web, :model

    schema "users" do
        field :email, :string
        field :provider, :string
        field :token, :string
        field :name, :string
        field :image_url, :string
        has_many :topics, Discuss.Topic
        has_many :comments, Discuss.Comment

        timestamps()
    end

    # describes how we want to change the record
    def changeset(struct, params \\ %{})do
        struct 
        |> cast(params, [:email, :provider, :token, :name, :image_url])
        |> validate_required([:email, :provider, :token]) #all of these properties are required
    end
end