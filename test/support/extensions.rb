# frozen_string_literal: true

require_relative 'fixture'

module Support
  module Extensions
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end

    module InstanceMethods
      def load_fixture(*names)
        return Fixture.new(name: names[0]).fetch if names.size == 1

        names.map { |name| Fixture.new(name: name).fetch }
      end
    end

    module ClassMethods
    end
  end
end
