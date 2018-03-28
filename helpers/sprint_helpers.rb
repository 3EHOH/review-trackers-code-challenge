#functionality for getting stories, owners, and updating the current iteration

require_relative 'auth_helpers'
require_relative 'pivotal_helpers'
require_relative 'label_helpers'
require_relative 'general_helpers'

helpers do

  def get_combined_stories_and_owners
    stories = get_release_ticket_stories

    stories.each do |story|
      owners = []

      story['owner_ids'].each do |owner|
        response = RestClient.get "#{base_url}/product_owners/" + owner.to_s
        parsed_response = JSON.parse(response.body)

        parsed_response['name'].split.each do |name|
          owners.push(name)
        end

        if owners.empty?
          story['owners_names'] = ''
        else
          story['owners_names'] = owners
        end
      end
    end
    stories
  end

  def get_release_ticket_stories
    stories = []
    label = get_release_label
    label['project_ids'].each do |id|
      response = make_call_parsed("#{pivotal_url}/#{id}/search?query=label%3A#{label["name"]}+AND+includedone%3Atrue", pivotal_headers)['stories']
      if response
        stories << response['stories']
      end
    end
    stories.flatten
  end


  #populate the owners table
  def populate_owners
    ENV['PT_PROJECTS'].split(', ').each do |id|

      ownersDatum = make_call_parsed("#{pivotal_url}/#{id}/memberships", pivotal_headers)

      ownersDatum.each do |ownerData|

        unless Owner.find_by_poid(ownerData['person']['id'])

          Owner.create( poid: ownerData['person']['id'],
                        initials: ownerData['person']['initials'],
                        name: ownerData['person']['name'])
        end
      end
    end
  end

  def update_current_iteration
    populate_owners

    headers = pivotal_headers
    projects = ENV['PT_PROJECTS'].split(', ')

    projects.each do |project|
      url = "#{pivotal_url}/#{project}/iterations?scope=current"
      response = make_call_parsed(url, headers)
      stories = response.last['stories']
      stories.each do |story|
        add_label(project, story, ENV['RELEASE_LABEL']) #TODO DETERMINE WHAT KIND OF DATA IS ACTUALLY SUPPSOED TO GO HERE TO GET IT WORKING?
      end
    end
  end

end
