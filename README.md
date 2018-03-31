# README

A small repro for a performance issue with `rspec-rails`'
`#stub_template` helper, addressed by caching the
`ActionView::FixtureResolver` instances created to support the stubs.

```erb
<%# app/views/repro.html.erb %>
<%= render partial: 'some_partial' %>
```

```ruby
# spec/views/repro.html.erb_spec.rb
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
```

```
$ rspec spec/views/repro.html.erb_spec.rb
..... [many examples snipped] ....

Finished in 3 minutes 57 seconds (files took 8.83 seconds to load)
5000 examples, 0 failures
```

```
$ CACHE_RESOLVERS=true rspec spec/views/repro.html.erb_spec.rb
..... [many examples snipped] ....

Finished in 13.12 seconds (files took 8.35 seconds to load)
5000 examples, 0 failures
```
