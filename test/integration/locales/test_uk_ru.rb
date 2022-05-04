# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[LOCALES]HashDeepDiff::Comparison#diff' do
    let(:uk_ru_diff) do
      [{ '...' => { left: [:separator], right: %i[separator country_code] } },
       { address: {
         left: %i[country building_number masculine_street_prefix feminine_street_prefix street_prefix street_suffix
                  secondary_address postcode state state_abbr street_title masculine_street_title
                  feminine_street_title city_name city_prefix city_suffix city street_name street_address
                  full_address default_country],
         right: %i[country building_number street_suffix secondary_address postcode state street_title
                   city_name city street_name street_address default_country full_address]
       } },
       { cell_phone: { left: [:formats], right: HashDeepDiff::NO_VALUE } },
       { company: { left: %i[prefix suffix product name], right: %i[prefix suffix name] } },
       { music: { left: [:instruments], right: HashDeepDiff::NO_VALUE } },
       { artist: { left: [:names], right: HashDeepDiff::NO_VALUE } },
       { '...' => { left: [:user], right: [] } },
       { user: { left: HashDeepDiff::NO_VALUE, right: %i[few many one other] } },
       { '...' => { left: %i[gb kb mb tb], right: %i[eb gb kb mb pb tb] } },
       { format: { left: [:delimiter], right: %i[delimiter format] } }]
    end

    let(:uk_ru_change_keys) do
      [
        ['{}', :faker, '...'],
        ['{}', :faker, '{}', :address],
        ['{}', :faker, '{}', :cell_phone],
        ['{}', :faker, '{}', :company],
        ['{}', :faker, '{}', :music],
        ['{}', :faker, '{}', :artist],
        ['{}', :activerecord, '{}', :models, '...'],
        ['{}', :activerecord, '{}', :models, '{}', :user],
        ['{}', :number, '{}', :human, '{}', :storage_units, '{}', :units, '...'],
        ['{}', :number, '{}', :percentage, '{}', :format]
      ]
    end

    it 'finds difference between uk and ru examples' do
      uk, ru = load_fixture('locales/uk', 'locales/ru')

      diff = HashDeepDiff::Comparison.new(uk, ru).diff

      assert_equal(uk_ru_diff, diff)
    end

    it 'difference between uk and ru examples has correct change_keys' do
      uk, ru = load_fixture('locales/uk', 'locales/ru')

      keys = HashDeepDiff::Comparison.new(uk, ru).diff

      assert_equal(uk_ru_change_keys, keys.map(&:change_key))
    end
  end

  describe '[LOCALES]HashDeepDiff::Comparison#report' do
    let(:uk_ru_report) do
      <<~Q
        -left[{}][faker][...] = []
        +left[{}][faker][...] = [:country_code]
        -left[{}][faker][{}][address] = [:city_prefix, :city_suffix, :feminine_street_prefix, \
        :feminine_street_title, :masculine_street_prefix, \
        :masculine_street_title, :state_abbr, :street_prefix]
        +left[{}][faker][{}][address] = []
        -left[{}][faker][{}][cell_phone] = [:formats]
        -left[{}][faker][{}][company] = [:product]
        +left[{}][faker][{}][company] = []
        -left[{}][faker][{}][music] = [:instruments]
        -left[{}][faker][{}][artist] = [:names]
        -left[{}][activerecord][{}][models][...] = [:user]
        +left[{}][activerecord][{}][models][...] = []
        +left[{}][activerecord][{}][models][{}][user] = [:few, :many, :one, :other]
        -left[{}][number][{}][human][{}][storage_units][{}][units][...] = []
        +left[{}][number][{}][human][{}][storage_units][{}][units][...] = [:eb, :pb]
        -left[{}][number][{}][percentage][{}][format] = []
        +left[{}][number][{}][percentage][{}][format] = [:format]
      Q
    end

    it 'reports difference between uk and ru' do
      uk, ru = load_fixture('locales/uk', 'locales/ru')

      report = HashDeepDiff::Comparison.new(uk, ru).report

      assert_equal(uk_ru_report, report)
    end
  end
end
