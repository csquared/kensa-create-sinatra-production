Sequel.migration do
  up do
    create_table :queue_classic_jobs do 
      primary_key :id
      String :details
      Time   :locked_at
    end
  end

  down do
    drop_table :queue_classic_jobs
  end
end
