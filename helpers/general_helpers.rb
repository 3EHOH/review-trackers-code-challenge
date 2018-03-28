# helpers that aren't specific to a certain feature of the app

def base_url
  @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
end