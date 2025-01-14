# frozen_string_literal: true

require 'dry-validation'

module MealDecoder
  module Forms
    # Form object to validate dish name
    class NewDish < Dry::Validation::Contract
      params do
        required(:dish_name).filled(:string)
      end

      rule(:dish_name) do
        # Check if dish name contains only letters and spaces from any language
        key.failure('must contain only letters and spaces') unless /\A[\p{L}\p{M}\p{Zs}]+\z/u.match?(value)

        # Check length
        key.failure('must be less than 100 characters') if value.length > 100

        # Check if empty after stripping
        key.failure('must not be empty') if value.strip.empty?
      end
    end
  end
end
