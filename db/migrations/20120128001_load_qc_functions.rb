Sequel.migration do
  up do
    require 'queue_classic'
    $QC_DATABASE_URL = ENV['DATABASE_URL']
    QC::Database.new.load_functions
  end
end
