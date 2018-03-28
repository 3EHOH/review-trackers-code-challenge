
# Create & Read all product owners

get '/product_owners' do
  content_type :json
  Owner.all.to_json
end

post '/product_owners' do
  new_owner = Owner.new
  new_owner.poid = params[:poid]
  new_owner.name = params[:name]
  new_owner.initials = params[:initials]
  new_owner.save

  redirect '/product_owners_table'
end

# Read, Update, & Delete specific product owners

get '/product_owners/:owner' do
  content_type :json
  Owner.find_by_poid(params['owner']).to_json
end

#known issue: this isn't working properly
put '/product_owners/:owner' do
  updated_owner = Owner.find_by_poid(params['owner'])
  updated_owner.id = params[:id]
  updated_owner.name = params[:name]
  updated_owner.initials = params[:initials]
  updated_owner.update

  redirect '/product_owners_table'
end

#known issue: this isn't working properly
delete '/product_owners/:owner/delete' do
  @deleted_owner = Owner.find_by_poid(params['owner'])
  @deleted_owner.delete

  redirect '/product_owners_table'
end

# view routes for product owners' tables and forms

get '/product_owners_table' do
  @owners = Owner.all

  erb :'product_owners/product_owner_table'
end

get '/product_owners_form_create' do
  erb :'product_owners/product_owner_form_create'
end

get '/product_owners_form_update/:owner' do
  product_owner = Owner.find_by_poid(params['owner']).to_json
  @product_owner = JSON.parse(product_owner)

  erb :'product_owners/product_owner_form_update'
end