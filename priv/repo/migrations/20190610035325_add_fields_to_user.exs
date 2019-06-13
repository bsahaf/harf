defmodule Discuss.Repo.Migrations.AddFieldsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :image_url, :string
    end
  end
end
