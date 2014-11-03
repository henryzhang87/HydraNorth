require 'rails_helper'

feature 'Branding' do
	scenario 'visit root' do
		visit root_path
		expect(page).to have_content 'University of Alberta'
	end
end
			
	
