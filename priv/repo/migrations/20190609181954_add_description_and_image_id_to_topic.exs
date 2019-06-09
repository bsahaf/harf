defmodule Discuss.Repo.Migrations.AddDescriptionAndImageIdToTopic do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :description, :string
      add :image_url, :string
    end
  end
end
