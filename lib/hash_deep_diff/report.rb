# frozen_string_literal: true

module HashDeepDiff
  # Visual representation of the difference between wo values
  class Report
    module Mode
      ADDITION = '+left'
      DELETION = '-left'
    end

    def to_str
      if @value.respond_to?(:to_hash) && !@value.empty?
        [@mode, diff_prefix, ' = ', "{}\n"].join +
          @value.keys.map do |key|
            Report.new(path: @path + [key], value: @value[key], mode: @mode)
          end.join("\n")
      else
        [@mode, diff_prefix, ' = ', @value.to_s].join
      end
    end

    def to_s
      to_str
    end

    private

    def initialize(path:, value:, mode: Mode::ADDITION)
      @path = path.to_ary
      @value = value
      @mode = mode
    end

    # TOFIX poor naming
    def diff_prefix
      @path.map { |key| "[#{key}]" }.join
    end
  end
end
