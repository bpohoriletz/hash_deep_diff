# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[BIG]HashDeepDiff::Comparison#report' do
    let(:expectation) do
      <<~Q
        -left[b][c][e] = [{}]
        +left[b][c][e] = [1, 2, 3]
        -left[b][c][e][f] = {}
        -left[b][c][e][f][g] = [1, 2, 3]
        -left[b][c][e][h] = {}
        -left[b][c][e][h][i] = {}
        -left[b][c][e][h][i][j] = {}
        -left[b][c][e][h][i][j][k] = k
        -left[b][c][e][h][i][j][l] = l
        -left[b][c][e][h][i][m] = m
        -left[b][c][e][h][n] = n
        -left[b][c][e][o] = o
        -left[b][c][e][p] = [1, 2, 3]
        -left[b][c][r] = r
        -left[b][c][s] = {}
        -left[b][c][s][t] = t
        -left[b][c][s][u] = u
        -left[b][c][s][v] = {}
        -left[b][c][s][v][w] = w
        -left[b][c][s][v][x] = {}
        -left[b][c][s][v][x][y] = {}
        -left[b][c][s][v][x][y][z] = z
        +left[h][i][j] = {}
        +left[h][i][j][k] = k
        +left[h][i][j][l] = l
        -left[h][i][j] = j
        -left[h][i][k] = k
        -left[h][i][l] = l
        -left[h][i][m] = {}
        +left[h][i][m] = m
        -left[h][i][m][n] = n
        +left[h][n] = n
        +left[g] = [1, 2, 3]
      Q
    end

    it 'builds git diff like report with Reports::Diff engine' do
      left, right = load_fixture('n_level/huge', 'n_level/big')

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(expectation, report)
    end
  end
end
