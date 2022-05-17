# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[LOCALES]HashDeepDiff::Comparison#raw_report in YML format' do
    let(:uk_ru_raw_report) do
      {
        additions: [{ faker: [:country_code],
                      activerecord: [{ models: [{ user: %i[few many one other] }] }],
                      number: [{ human: [{ storage_units: [{ units: %i[eb pb] }] }],
                                 percentage: [{ format: [:format] }] }] }],
        deletions: [{ faker: [{ address: %i[masculine_street_prefix feminine_street_prefix
                                            street_prefix state_abbr masculine_street_title
                                            feminine_street_title city_prefix city_suffix],
                                cell_phone: [:formats],
                                company: [:product],
                                music: [:instruments],
                                artist: [:names] }],
                      activerecord: [{ models: [:user] }] }]
      }
    end

    it 'reports difference between uk and ru as an Array or Hash' do
      uk, ru = load_fixture('locales/uk', 'locales/ru')

      report = HashDeepDiff::Comparison.new(uk, ru, reporting_engine: HashDeepDiff::Reports::Yml).raw_report

      assert_equal(uk_ru_raw_report, report)
    end
  end
end
