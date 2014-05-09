require 'set'

module Scrutinize
  class Trigger
    ANY  = Set.new(['SCRUTINIZE_ANY', true, nil])
    NONE = Set.new(['SCRUTINIZE_NONE', false])

    # Instantiate a new Trigger.
    #
    # Returns nothing.
    def initialize
      @targets               = Set.new
      @methods               = Set.new
      @target_methods        = Set.new
      @any_target_methods    = Set.new
      @any_method_targets    = Set.new
      @any_method_any_target = false
    end

    # Add targets/methods to the trigger.#
    #
    # criteria - A hash of targets/methods
    #            :targets - An Array of target names to trigger on. Setting to
    #                       `true` means all targets match. Setting to nil
    #                       means that only calls without a target match.
    #            :methods - An Array of method names to trigger on. Setting to
    #                       `true` means all methods match.
    #
    # Returns nothing.
    def add(criteria = {})
      # Stop now if we're searching for everything.
      return if @any_method_any_target

      # Extract targets/methods from criteria
      targets  = Set.new
      targets += Array(criteria['targets']) if criteria.key?('targets')
      targets += Array(criteria['target'])  if criteria.key?('target')
      targets += [nil] if targets.empty? # Can't do Array(nil)

      methods  = Set.new
      methods += Array(criteria['methods']) if criteria.key?('methods')
      methods += Array(criteria['method'])  if criteria.key?('method')
      methods += [nil] if methods.empty? # Can't do Array(nil)

      any_method = !(ANY & methods).empty?
      any_target = !(ANY & targets).empty?

      # Stop now if we're searching for everything.
      if any_target && any_method
        return @any_method_any_target = true
      end

      # Don't clean up methods if we're looking for all methods.
      if !any_method
        methods.map! &:to_sym
        methods -= @any_target_methods
      end

      # Stop now if we're looking for any method.
      if any_target
        return @any_target_methods += methods
      end

      # Clean up targets, preserving no target case.
      if !(targets & NONE).empty?
        targets -= NONE
        targets.map! &:to_sym
        targets.add nil
      else
        targets.map! &:to_str
      end
      targets -= @any_method_targets

      # Stop now if we're looking for any target.
      if any_method
        return @any_method_targets += targets
      end

      # Track all the methods/targets we've seen for faster checks.
      @methods += methods
      @targets += targets

      # Track each target/method combo.
      targets.each do |target|
        methods.each do |method|
          @target_methods.add [target, method]
        end
      end
    end

    # Checks if a given target/method match the configuration.
    #
    # target - A String target name.
    # method - A Symbol method name.
    #
    # Returns boolean.
    def match?(target, method)
      @any_method_any_target ||
      @any_method_targets.include?(target) ||
      @any_target_methods.include?(method) ||
      (
        @targets.include?(target) &&
        @methods.include?(method) &&
        @target_methods.include?([target, method])
      )
    end
  end
end
