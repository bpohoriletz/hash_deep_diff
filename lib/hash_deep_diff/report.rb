# frozen_string_literal: true

module HashDeepDiff
  # Visual representation of the difference between two values
  class Report
    # We have two cases
    #   * added - when value on the left is missing
    #   * deleted - when the value on the right is missing
    module Mode
      # for additions
      ADDITION = '+left'
      # for deletions
      DELETION = '-left'
    end

    # see {#to_str}
    # @return [String]
    def to_s
      to_str
    end

    # A report with all additions and deletions
    # @return [String]
    def to_str
      return '' if @value == NO_VALUE

      if @value.respond_to?(:to_hash) && !@value.empty?
        [@mode, diff_prefix, ' = ', "{}\n"].join +
          @value.keys.map do |key|
            Report.new(path: @path + [key], value: @value[key], mode: @mode).to_s
          end.join
      else
        [@mode, diff_prefix, ' = ', @value.to_s, "\n"].join
      end
    end

    # @return [Bool]
    def empty?
      @value == NO_VALUE
    end

    private

    # @param [Array] path Keys from compared objects to fetch the compared values
    # @param [Object] value value from a  compared object at +@path+
    # @param [Mode::ADDITION, Mode::DELETION] mode
    def initialize(path:, value:, mode: Mode::ADDITION)
      @path = path.to_ary
      @value = value
      @mode = mode
    end

    # Visual representation of keys from compared objects needed to fetch the compared values
    # @return [String]
    def diff_prefix
      # TOFIX poor naming
      @path.map { |key| "[#{key}]" }.join
    end
  end
end
