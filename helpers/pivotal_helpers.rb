# helpers specifically for the pivotal site

def pivotal_url
  "https://www.pivotaltracker.com/services/v5/projects"
end

def pivotal_headers
  { 'X-TrackerToken' => ENV['PT_TOKEN'] }
end

def make_call_parsed(url, headers)
  response = RestClient.get url, headers

  JSON.parse(response)
end
