# README

A small repro for a performance issue with `ActionView::Template`'s
finalizer in large test suites. This is caused by undefining methods on
`ActionView::CompiledTemplates` becoming expensive due to the large
number of descendant classes (in this repro, RSpec example groups; in
Test::Unit suites, subclasses of `ActionView::TestCase`).

```erb
<%# app/views/many/1.html.erb %>
some-contents-1
```

```ruby
# spec/views/repro.html.erb_spec.rb
require 'rails_helper'

(1..1000).each do |i|
  RSpec.describe "many/#{i}.html.erb" do
    it 'renders the template' do
      render

      expect(rendered).to include("some-contents-#{i}")
    end
  end
end
```

```
$ time rspec spec/views/repro.html.erb_spec.rb
..... [many examples snipped] ....

Finished in 32.51 seconds (files took 2.17 seconds to load)
1000 examples, 0 failures


real    1m7.304s
user    1m6.304s
sys     0m0.841s
```

Approximately half the runtime is spent finalizing templates at the end
of the test run.
