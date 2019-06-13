defmodule Discuss.Repo.Migrations.ChangeDescriptionType do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      modify :description, :text
    end
  end
end
