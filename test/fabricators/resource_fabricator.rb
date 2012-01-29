Fabricator(:resource) do
  heroku_id { sequence(:heroku_id) { |i| "resource#{i}@heroku.com" }}
  plan 'test'
end
