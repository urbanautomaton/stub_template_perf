module StubTemplateCache
  def self.resolver_for(hash)
    @resolvers ||= {}
    if ENV['CACHE_RESOLVERS']
      @resolvers[hash] ||= ActionView::FixtureResolver.new(hash).freeze
    else
      ActionView::FixtureResolver.new(hash).freeze
    end
  end
end

module RSpec
  module Rails
    module ViewExampleGroup
      module ExampleMethods
        # Simulates the presence of a template on the file system by adding a
        # Rails' FixtureResolver to the front of the view_paths list. Designed to
        # help isolate view examples from partials rendered by the view template
        # that is the subject of the example.
        #
        #     stub_template("widgets/_widget.html.erb" => "This content.")
        def stub_template(hash)
          view.view_paths.unshift(StubTemplateCache.resolver_for(hash))
        end
      end
    end
  end
end
