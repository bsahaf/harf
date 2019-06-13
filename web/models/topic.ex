defmodule Discuss.Topic do
    use Discuss.Web, :model


    schema "topics" do
        field :title, :string
        field :description, :string
        field :image_url, :string
        belongs_to :user, Discuss.User
        has_many :comments, Discuss.Comment
    end


    def changeset(struct, params \\ %{})do
        struct 
        |> cast(params, [:title, :description, :image_url])
        |> validate_required([:title])
    end
end