Sequel.migration do
  up do
    create_table :resources do 
      primary_key :id
      String :heroku_id
      String :plan
      String :options
    end
  end

  down do
    drop_table :resources
  end
end
