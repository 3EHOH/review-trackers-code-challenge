#helpers for sprint labels

def get_release_label
  label = ENV['RELEASE_LABEL'] || '2.2017.1'

  {'project_ids' => ENV['PT_PROJECTS'].split(', '), 'name' => label }
end

def add_label(project, story, label)
  return if label_present?(project, story, label)

  headers = pivotal_headers
  url = "#{pivotal_url}/#{project}/stories/#{story['id']}/labels"
  body = {name: label}

  RestClient.post url, body, headers
end

def label_present?(project, story, label)
  headers = pivotal_headers
  url = "#{pivotal_url}/#{project}/stories/#{story['id']}/labels"
  labels = make_call_parsed(url, headers)

  labels.each do |l|
    if l['name'] == label
      return true
    end
  end

  false
end