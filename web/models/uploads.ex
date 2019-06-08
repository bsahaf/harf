defmodule Discuss.Upload do
    use Discuss.Web, :model

    schema "uploads" do
        field :image_url, :string

        timestamps()
    end

    # describes how we want to change the record
    def changeset(struct, params \\ %{})do
        struct 
        |> cast(params, [:image_url])
        |> validate_required([:image_url]) #all of these properties are required
    end
end