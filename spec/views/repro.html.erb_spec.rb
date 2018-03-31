require 'rails_helper'

RSpec.describe 'repro.html.erb' do
  before do
    stub_template('_some_partial.html.erb' => 'some-contents')
  end

  5_000.times do |i|
    context "Example group #{i} to cause expensive finalization" do
      it 'stubs the partial' do
        render

        expect(rendered).to include('some-contents')
      end
    end
  end
end
