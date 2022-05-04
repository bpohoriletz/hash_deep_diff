# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[LOCALES]HashDeepDiff::Comparison#diff' do
    let(:uk_en_diff) do
      [{ '...' => { left: [:dismiss], right: %i[hello dismiss] } },
       { '...' => { left: [:separator], right: HashDeepDiff::NO_VALUE } },
       { address: { left: %i[country
                             building_number
                             masculine_street_prefix
                             feminine_street_prefix
                             street_prefix
                             street_suffix
                             secondary_address
                             postcode
                             state
                             state_abbr
                             street_title
                             masculine_street_title
                             feminine_street_title
                             city_name
                             city_prefix
                             city_suffix
                             city
                             street_name
                             street_address
                             full_address
                             default_country],
                    right: HashDeepDiff::NO_VALUE } },
       { internet: { left: %i[free_email domain_suffix], right: HashDeepDiff::NO_VALUE } },
       { name: { left: %i[male_first_name male_middle_name male_last_name female_first_name
                          female_middle_name female_last_name first_name last_name name name_with_middle],
                 right: HashDeepDiff::NO_VALUE } },
       { phone_number: { left: [:formats], right: HashDeepDiff::NO_VALUE } },
       { cell_phone: { left: [:formats], right: HashDeepDiff::NO_VALUE } },
       { '...' => { left: %i[color department], right: HashDeepDiff::NO_VALUE } },
       { product_name: { left: %i[adjective material product], right: HashDeepDiff::NO_VALUE } },
       { company: { left: %i[prefix suffix product name], right: HashDeepDiff::NO_VALUE } },
       { music: { left: [:instruments], right: HashDeepDiff::NO_VALUE } },
       { artist: { left: [:names], right: HashDeepDiff::NO_VALUE } },
       { yoda: { left: [:quotes], right: HashDeepDiff::NO_VALUE } },
       { '...' => { left: [:user], right: [] } },
       { user: { left: HashDeepDiff::NO_VALUE, right: %i[one other] } },
       { minimum_password_length: { left: %i[few many one other], right: %i[one other] } },
       { '...' =>
        { left: %i[already_confirmed
                   confirmation_period_expired
                   expired
                   not_found
                   not_locked
                   accepted
                   blank
                   confirmation
                   empty
                   equal_to
                   even
                   exclusion
                   greater_than
                   greater_than_or_equal_to
                   inclusion
                   invalid
                   less_than
                   less_than_or_equal_to
                   model_invalid
                   not_a_number
                   not_an_integer
                   odd
                   other_than
                   present
                   required
                   taken],
          right: %i[model_invalid
                    inclusion
                    exclusion
                    invalid
                    confirmation
                    accepted
                    empty
                    blank
                    present
                    not_a_number
                    not_an_integer
                    greater_than
                    greater_than_or_equal_to
                    equal_to
                    less_than
                    less_than_or_equal_to
                    other_than
                    in
                    odd
                    even
                    required
                    taken
                    already_confirmed
                    confirmation_period_expired
                    expired
                    not_found
                    not_locked] } },
       { not_saved: { left: %i[few many one other], right: %i[one other] } },
       { too_long: { left: %i[one few many other], right: %i[one other] } },
       { too_short: { left: %i[one few many other], right: %i[one other] } },
       { wrong_length: { left: %i[one few many other], right: %i[one other] } },
       { header: { left: %i[one few many other], right: %i[one other] } },
       { '...' => { left: %i[abbr_day_names abbr_month_names day_names month_names order],
                    right: %i[day_names abbr_day_names month_names abbr_month_names order] } },
       { formats: { left: %i[default long short], right: %i[default short long] } },
       { about_x_hours: { left: %i[one few many other], right: %i[one other] } },
       { about_x_months: { left: %i[one few many other], right: %i[one other] } },
       { about_x_years: { left: %i[one few many other], right: %i[one other] } },
       { almost_x_years: { left: %i[one few many other], right: %i[one other] } },
       { less_than_x_seconds: { left: %i[one few many other], right: %i[one other] } },
       { less_than_x_minutes: { left: %i[one few many other], right: %i[one other] } },
       { over_x_years: { left: %i[one few many other], right: %i[one other] } },
       { x_seconds: { left: %i[one few many other], right: %i[one other] } },
       { x_minutes: { left: %i[one few many other], right: %i[one other] } },
       { x_days: { left: %i[one few many other], right: %i[one other] } },
       { x_months: { left: %i[one few many other], right: %i[one other] } },
       { x_years: { left: %i[one few many other], right: %i[one other] } },
       { prompts: { left: %i[second minute hour day month year],
                    right: %i[year month day hour minute second] } },
       { submit: { left: %i[create submit update], right: %i[create update submit] } },
       { format: { left: %i[delimiter format precision separator significant strip_insignificant_zeros unit],
                   right: %i[format unit separator delimiter precision significant
                             strip_insignificant_zeros] } },
       { format: { left: %i[delimiter precision separator significant strip_insignificant_zeros],
                   right: %i[separator delimiter precision round_mode significant
                             strip_insignificant_zeros] } },
       { '...' => { left: [:unit], right: %i[unit thousand million billion trillion quadrillion] } },
       { billion: { left: %i[one few many other], right: HashDeepDiff::NO_VALUE } },
       { million: { left: %i[one few many other], right: HashDeepDiff::NO_VALUE } },
       { quadrillion: { left: %i[one few many other], right: HashDeepDiff::NO_VALUE } },
       { thousand: { left: %i[one few many other], right: HashDeepDiff::NO_VALUE } },
       { trillion: { left: %i[one few many other], right: HashDeepDiff::NO_VALUE } },
       { '...' => { left: %i[gb kb mb tb], right: %i[kb mb gb tb pb eb] } },
       { byte: { left: %i[one few many other], right: %i[one other] } },
       { format: { left: [:delimiter], right: %i[delimiter format] } },
       { nth: { left: HashDeepDiff::NO_VALUE, right: %i[ordinals ordinalized] } },
       { array: { left: %i[last_word_connector two_words_connector words_connector],
                  right: %i[words_connector two_words_connector last_word_connector] } },
       { formats: { left: %i[default long short], right: %i[default short long us] } },
       { transliterate: { left: [:rule], right: HashDeepDiff::NO_VALUE } },
       { '...' => { left: HashDeepDiff::NO_VALUE, right: [] } },
       { '...' => { left: HashDeepDiff::NO_VALUE, right: [] } },
       { create: { left: HashDeepDiff::NO_VALUE, right: [:notice] } },
       { update: { left: HashDeepDiff::NO_VALUE, right: [:notice] } },
       { destroy: { left: HashDeepDiff::NO_VALUE, right: %i[notice alert] } }]
    end

    let(:uk_en_change_keys) do
      [['...'],
       ['{}', :faker, '...'],
       ['{}', :faker, '{}', :address],
       ['{}', :faker, '{}', :internet],
       ['{}', :faker, '{}', :name],
       ['{}', :faker, '{}', :phone_number],
       ['{}', :faker, '{}', :cell_phone],
       ['{}', :faker, '{}', :commerce, '...'],
       ['{}', :faker, '{}', :commerce, '{}', :product_name],
       ['{}', :faker, '{}', :company],
       ['{}', :faker, '{}', :music],
       ['{}', :faker, '{}', :artist],
       ['{}', :faker, '{}', :yoda],
       ['{}', :activerecord, '{}', :models, '...'],
       ['{}', :activerecord, '{}', :models, '{}', :user],
       ['{}', :devise, '{}', :shared, '{}', :minimum_password_length],
       ['{}', :errors, '{}', :messages, '...'],
       ['{}', :errors, '{}', :messages, '{}', :not_saved],
       ['{}', :errors, '{}', :messages, '{}', :too_long],
       ['{}', :errors, '{}', :messages, '{}', :too_short],
       ['{}', :errors, '{}', :messages, '{}', :wrong_length],
       ['{}', :errors, '{}', :template, '{}', :header],
       ['{}', :date, '...'],
       ['{}', :date, '{}', :formats],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :about_x_hours],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :about_x_months],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :about_x_years],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :almost_x_years],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :less_than_x_seconds],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :less_than_x_minutes],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :over_x_years],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :x_seconds],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :x_minutes],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :x_days],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :x_months],
       ['{}', :datetime, '{}', :distance_in_words, '{}', :x_years],
       ['{}', :datetime, '{}', :prompts],
       ['{}', :helpers, '{}', :submit],
       ['{}', :number, '{}', :currency, '{}', :format],
       ['{}', :number, '{}', :format],
       ['{}', :number, '{}', :human, '{}', :decimal_units, '{}', :units, '...'],
       ['{}', :number, '{}', :human, '{}', :decimal_units, '{}', :units, '{}', :billion],
       ['{}', :number, '{}', :human, '{}', :decimal_units, '{}', :units, '{}', :million],
       ['{}', :number, '{}', :human, '{}', :decimal_units, '{}', :units, '{}', :quadrillion],
       ['{}', :number, '{}', :human, '{}', :decimal_units, '{}', :units, '{}', :thousand],
       ['{}', :number, '{}', :human, '{}', :decimal_units, '{}', :units, '{}', :trillion],
       ['{}', :number, '{}', :human, '{}', :storage_units, '{}', :units, '...'],
       ['{}', :number, '{}', :human, '{}', :storage_units, '{}', :units, '{}', :byte],
       ['{}', :number, '{}', :percentage, '{}', :format],
       ['{}', :number, '{}', :nth],
       ['{}', :support, '{}', :array],
       ['{}', :time, '{}', :formats],
       ['{}', :i18n, '{}', :transliterate],
       ['{}', :flash, '...'],
       ['{}', :flash, '{}', :actions, '...'],
       ['{}', :flash, '{}', :actions, '{}', :create],
       ['{}', :flash, '{}', :actions, '{}', :update],
       ['{}', :flash, '{}', :actions, '{}', :destroy]]
    end

    it 'finds difference between uk and en examples' do
      uk, en = load_fixture('locales/uk', 'locales/en')
      # delete Faker locales
      en.delete_at(9)

      diff = HashDeepDiff::Comparison.new(uk, en).diff

      assert_equal(uk_en_diff, diff)
    end

    it 'difference between uk and en examples has correct change_keys' do
      uk, en = load_fixture('locales/uk', 'locales/en')
      # delete Faker locales
      en.delete_at(9)

      keys = HashDeepDiff::Comparison.new(uk, en).diff

      assert_equal(uk_en_change_keys, keys.map(&:change_key))
    end
  end

  describe '[LOCALES]HashDeepDiff::Comparison#report' do
    let(:uk_en_report) do
      <<~Q
        -left[...] = []
        +left[...] = [:hello]
        -left[{}][faker][...] = [:separator]
        -left[{}][faker][{}][address] = [:country, :building_number, :masculine_street_prefix, :feminine_street_prefix, :street_prefix, :street_suffix, :secondary_address, :postcode, :state, :state_abbr, :street_title, :masculine_street_title, :feminine_street_title, :city_name, :city_prefix, :city_suffix, :city, :street_name, :street_address, :full_address, :default_country]
        -left[{}][faker][{}][internet] = [:free_email, :domain_suffix]
        -left[{}][faker][{}][name] = [:male_first_name, :male_middle_name, :male_last_name, :female_first_name, :female_middle_name, :female_last_name, :first_name, :last_name, :name, :name_with_middle]
        -left[{}][faker][{}][phone_number] = [:formats]
        -left[{}][faker][{}][cell_phone] = [:formats]
        -left[{}][faker][{}][commerce][...] = [:color, :department]
        -left[{}][faker][{}][commerce][{}][product_name] = [:adjective, :material, :product]
        -left[{}][faker][{}][company] = [:prefix, :suffix, :product, :name]
        -left[{}][faker][{}][music] = [:instruments]
        -left[{}][faker][{}][artist] = [:names]
        -left[{}][faker][{}][yoda] = [:quotes]
        -left[{}][activerecord][{}][models][...] = [:user]
        +left[{}][activerecord][{}][models][...] = []
        +left[{}][activerecord][{}][models][{}][user] = [:one, :other]
        -left[{}][devise][{}][shared][{}][minimum_password_length] = [:few, :many]
        +left[{}][devise][{}][shared][{}][minimum_password_length] = []
        -left[{}][errors][{}][messages][...] = []
        +left[{}][errors][{}][messages][...] = [:in]
        -left[{}][errors][{}][messages][{}][not_saved] = [:few, :many]
        +left[{}][errors][{}][messages][{}][not_saved] = []
        -left[{}][errors][{}][messages][{}][too_long] = [:few, :many]
        +left[{}][errors][{}][messages][{}][too_long] = []
        -left[{}][errors][{}][messages][{}][too_short] = [:few, :many]
        +left[{}][errors][{}][messages][{}][too_short] = []
        -left[{}][errors][{}][messages][{}][wrong_length] = [:few, :many]
        +left[{}][errors][{}][messages][{}][wrong_length] = []
        -left[{}][errors][{}][template][{}][header] = [:few, :many]
        +left[{}][errors][{}][template][{}][header] = []
        -left[{}][date][...] = []
        +left[{}][date][...] = []
        -left[{}][date][{}][formats] = []
        +left[{}][date][{}][formats] = []
        -left[{}][datetime][{}][distance_in_words][{}][about_x_hours] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][about_x_hours] = []
        -left[{}][datetime][{}][distance_in_words][{}][about_x_months] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][about_x_months] = []
        -left[{}][datetime][{}][distance_in_words][{}][about_x_years] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][about_x_years] = []
        -left[{}][datetime][{}][distance_in_words][{}][almost_x_years] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][almost_x_years] = []
        -left[{}][datetime][{}][distance_in_words][{}][less_than_x_seconds] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][less_than_x_seconds] = []
        -left[{}][datetime][{}][distance_in_words][{}][less_than_x_minutes] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][less_than_x_minutes] = []
        -left[{}][datetime][{}][distance_in_words][{}][over_x_years] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][over_x_years] = []
        -left[{}][datetime][{}][distance_in_words][{}][x_seconds] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][x_seconds] = []
        -left[{}][datetime][{}][distance_in_words][{}][x_minutes] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][x_minutes] = []
        -left[{}][datetime][{}][distance_in_words][{}][x_days] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][x_days] = []
        -left[{}][datetime][{}][distance_in_words][{}][x_months] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][x_months] = []
        -left[{}][datetime][{}][distance_in_words][{}][x_years] = [:few, :many]
        +left[{}][datetime][{}][distance_in_words][{}][x_years] = []
        -left[{}][datetime][{}][prompts] = []
        +left[{}][datetime][{}][prompts] = []
        -left[{}][helpers][{}][submit] = []
        +left[{}][helpers][{}][submit] = []
        -left[{}][number][{}][currency][{}][format] = []
        +left[{}][number][{}][currency][{}][format] = []
        -left[{}][number][{}][format] = []
        +left[{}][number][{}][format] = [:round_mode]
        -left[{}][number][{}][human][{}][decimal_units][{}][units][...] = []
        +left[{}][number][{}][human][{}][decimal_units][{}][units][...] = [:billion, :million, :quadrillion, :thousand, :trillion]
        -left[{}][number][{}][human][{}][decimal_units][{}][units][{}][billion] = [:one, :few, :many, :other]
        -left[{}][number][{}][human][{}][decimal_units][{}][units][{}][million] = [:one, :few, :many, :other]
        -left[{}][number][{}][human][{}][decimal_units][{}][units][{}][quadrillion] = [:one, :few, :many, :other]
        -left[{}][number][{}][human][{}][decimal_units][{}][units][{}][thousand] = [:one, :few, :many, :other]
        -left[{}][number][{}][human][{}][decimal_units][{}][units][{}][trillion] = [:one, :few, :many, :other]
        -left[{}][number][{}][human][{}][storage_units][{}][units][...] = []
        +left[{}][number][{}][human][{}][storage_units][{}][units][...] = [:eb, :pb]
        -left[{}][number][{}][human][{}][storage_units][{}][units][{}][byte] = [:few, :many]
        +left[{}][number][{}][human][{}][storage_units][{}][units][{}][byte] = []
        -left[{}][number][{}][percentage][{}][format] = []
        +left[{}][number][{}][percentage][{}][format] = [:format]
        +left[{}][number][{}][nth] = [:ordinals, :ordinalized]
        -left[{}][support][{}][array] = []
        +left[{}][support][{}][array] = []
        -left[{}][time][{}][formats] = []
        +left[{}][time][{}][formats] = [:us]
        -left[{}][i18n][{}][transliterate] = [:rule]
        +left[{}][flash][...] = []
        +left[{}][flash][{}][actions][...] = []
        +left[{}][flash][{}][actions][{}][create] = [:notice]
        +left[{}][flash][{}][actions][{}][update] = [:notice]
        +left[{}][flash][{}][actions][{}][destroy] = [:notice, :alert]
      Q
    end

    it 'reports difference between uk and en' do
      uk, en = load_fixture('locales/uk', 'locales/en')
      # delete Faker locales
      en.delete_at(9)

      report = HashDeepDiff::Comparison.new(uk, en).report

      assert_equal(uk_en_report, report)
    end
  end
end
