class Resource < Sequel::Model
  plugin :serialization, :json, :options
end
