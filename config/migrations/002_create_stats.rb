# encoding : utf-8

Sequel.migration do
  up do
    create_table(:Stats) do
      primary_key :id
      foreign_key :link_id, :Stats, key: :id
      String :like_count
      String :share_count
    end
  end

  down do
    drop_table(:Stats)
  end
end
