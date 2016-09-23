defmodule ExcelionTest do
  use ExUnit.Case
  doctest Excelion

  def collect_filename, do: "priv/test.xlsx"
  def bad_filename, do: "priv/__not_found_file.xlsx"

  test "get sheet names" do
    ret = Excelion.get_worksheet_names(collect_filename)
    assert ret == {:ok, ["test_sheet"]}
  end

  test "get sheet names error" do
    ret = Excelion.get_worksheet_names(bad_filename)
    assert elem(ret, 0) == :error
  end

  test "parse! xlsx file" do
    sheet_number = 0
    start_row = 5
    ret = Excelion.parse!(collect_filename, sheet_number, start_row)
    expected = [
      ["ID", "name", "description", "value"],
      ["1",  "aaa",  "bbb",         "4"],
      ["2",  "ccc",  "",            "5"], # empty cell to be empty string
      ["3",  "eee",  "fff",         "6"]
    ]
    assert ret == expected
  end

  test "parse! xlsx file error" do
    assert_raise File.Error, fn ->
      Excelion.parse!(bad_filename, 0, 5)
    end
  end

  test "parse xlsx file" do
    ret = Excelion.parse(collect_filename, 0, 5)
    expected = [
      ["ID", "name", "description", "value"],
      ["1",  "aaa",  "bbb",         "4"],
      ["2",  "ccc",  "",            "5"], # empty cell to be empty string
      ["3",  "eee",  "fff",         "6"]
    ]
    assert ret == {:ok, expected}
  end

  test "parse xlsx file error" do
    ret = Excelion.parse(bad_filename, 0, 5)
    assert elem(ret, 0) == :error
  end
end
