# frozen_string_literal: true

require 'yaml'

module Support
  class Fixture
    attr_reader :filename

    def fetch(reload: false)
      (reload && read) || (@data ||= read || {})
    end

    def read
      YAML.safe_load(File.read(filename), permitted_classes: [Symbol], symbolize_names: true)
    end

    private

    def initialize(name:)
      @filename = File.expand_path("#{name}.yml", __dir__)
    end
  end
end
