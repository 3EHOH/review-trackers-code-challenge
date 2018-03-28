# Create and Read functionality for releases

get '/releases' do
  content_type :json
  Release.all.to_json
end

get '/release_tickets' do
  get_release_tickets
end

#known issue: not working properly
post '/releases' do
  new_release = Release.new
  new_release.team = params[:team].to_i
  new_release.goals = params[:goals]
  new_release.save

  redirect '/release_table'
end

# views for release forms and tables
get '/release_form' do
  erb :'sprint_releases/release_form'
end

get '/release_table' do
  @release_label = get_release_label
  @stories = get_combined_stories_and_owners

  erb :'sprint_releases/release_table'
end

