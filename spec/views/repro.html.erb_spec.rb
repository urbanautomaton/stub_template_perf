require 'rails_helper'

(1..1000).each do |i|
  RSpec.describe "many/#{i}.html.erb" do
    it 'renders the template' do
      render

      expect(rendered).to include("some-contents-#{i}")
    end
  end
end
