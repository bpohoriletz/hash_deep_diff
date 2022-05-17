# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[LOCALES]HashDeepDiff::Comparison#report in YML format' do
    let(:uk_en_report) do
      <<~Q
        ---
        :additions:
        - :hello
        - :activerecord:
          - :models:
            - :user:
              - :one
              - :other
          :errors:
          - :messages:
            - :in
          :number:
          - :format:
            - :round_mode
            :human:
            - :decimal_units:
              - :units:
                - :thousand
                - :million
                - :billion
                - :trillion
                - :quadrillion
              :storage_units:
              - :units:
                - :pb
                - :eb
            :percentage:
            - :format:
              - :format
            :nth:
            - :ordinals
            - :ordinalized
          :time:
          - :formats:
            - :us
          :flash:
          - :actions:
            - :create:
              - :notice
              :update:
              - :notice
              :destroy:
              - :notice
              - :alert
        :deletions:
        - :faker:
          - :separator
          - :address:
            - :country
            - :building_number
            - :masculine_street_prefix
            - :feminine_street_prefix
            - :street_prefix
            - :street_suffix
            - :secondary_address
            - :postcode
            - :state
            - :state_abbr
            - :street_title
            - :masculine_street_title
            - :feminine_street_title
            - :city_name
            - :city_prefix
            - :city_suffix
            - :city
            - :street_name
            - :street_address
            - :full_address
            - :default_country
            :internet:
            - :free_email
            - :domain_suffix
            :name:
            - :male_first_name
            - :male_middle_name
            - :male_last_name
            - :female_first_name
            - :female_middle_name
            - :female_last_name
            - :first_name
            - :last_name
            - :name
            - :name_with_middle
            :phone_number:
            - :formats
            :cell_phone:
            - :formats
            :commerce:
            - :color
            - :department
            - :product_name:
              - :adjective
              - :material
              - :product
            :company:
            - :prefix
            - :suffix
            - :product
            - :name
            :music:
            - :instruments
            :artist:
            - :names
            :yoda:
            - :quotes
          :activerecord:
          - :models:
            - :user
          :devise:
          - :shared:
            - :minimum_password_length:
              - :few
              - :many
          :errors:
          - :messages:
            - :not_saved:
              - :few
              - :many
              :too_long:
              - :few
              - :many
              :too_short:
              - :few
              - :many
              :wrong_length:
              - :few
              - :many
            :template:
            - :header:
              - :few
              - :many
          :datetime:
          - :distance_in_words:
            - :about_x_hours:
              - :few
              - :many
              :about_x_months:
              - :few
              - :many
              :about_x_years:
              - :few
              - :many
              :almost_x_years:
              - :few
              - :many
              :less_than_x_seconds:
              - :few
              - :many
              :less_than_x_minutes:
              - :few
              - :many
              :over_x_years:
              - :few
              - :many
              :x_seconds:
              - :few
              - :many
              :x_minutes:
              - :few
              - :many
              :x_days:
              - :few
              - :many
              :x_months:
              - :few
              - :many
              :x_years:
              - :few
              - :many
          :number:
          - :human:
            - :decimal_units:
              - :units:
                - :billion:
                  - :one
                  - :few
                  - :many
                  - :other
                  :million:
                  - :one
                  - :few
                  - :many
                  - :other
                  :quadrillion:
                  - :one
                  - :few
                  - :many
                  - :other
                  :thousand:
                  - :one
                  - :few
                  - :many
                  - :other
                  :trillion:
                  - :one
                  - :few
                  - :many
                  - :other
              :storage_units:
              - :units:
                - :byte:
                  - :few
                  - :many
          :i18n:
          - :transliterate:
            - :rule
      Q
    end

    it 'reports difference between uk and en' do
      uk, en = load_fixture('locales/uk', 'locales/en')
      # delete Faker locales
      en.delete_at(9)

      report = HashDeepDiff::Comparison.new(uk, en, reporting_engine: HashDeepDiff::Reports::Yml).report

      assert_equal(uk_en_report, report)
    end
  end
end
