json.array!(@cases) do |case|
  json.extract! case, :id, :name, :stage, :starting_date, :ending_date, :next_hearing
  json.url case_url(case, format: :json)
end
