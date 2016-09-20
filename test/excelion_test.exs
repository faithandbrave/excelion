defmodule ExcelionTest do
  use ExUnit.Case
  doctest Excelion

  test "get sheet names" do
    ret = Excelion.get_worksheet_names("priv/test.xlsx")
    assert ret == {:ok, ["test_sheet"]}
  end

  test "parse xlsx file" do
    sheet_number = 0
    start_row = 5
    ret = Excelion.parse!("priv/test.xlsx", sheet_number, start_row)
    expected = [
      ["ID", "name", "description", "value"],
      ["1",  "aaa",  "bbb",         "4"],
      ["2",  "ccc",  "",            "5"], # empty cell to be empty string
      ["3",  "eee",  "fff",         "6"]
    ]
    assert ret == expected
  end
end
