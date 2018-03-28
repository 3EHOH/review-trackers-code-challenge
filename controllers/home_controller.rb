get '/' do
  protected!
  erb :'home/home'
end

#populate our users database - created for ease of repopulating after an accidental drop
put '/initial_users' do
  populate_owners
end
