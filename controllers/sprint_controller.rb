get '/update_sprint' do   #change to put?
  protected!
  update_current_iteration
  redirect to('/')
end