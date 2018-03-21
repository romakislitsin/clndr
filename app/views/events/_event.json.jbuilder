json.extract! event, :id, :name, :start_time, :created_at, :updated_at, :reccuring
json.url event_url(event, format: :json)
