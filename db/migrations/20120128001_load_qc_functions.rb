def load_qc
  require 'queue_classic'
  ENV['QC_DATABASE_URL'] = self.uri
end

Sequel.migration do
  up do
    load_qc
    QC::Database.new.load_functions
  end

  down do
    load_qc
    QC::Database.new.unload_functions
  end
end
