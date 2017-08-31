defmodule Excelion do
  @moduledoc """
  Excel (xlsx) file reader for Elixir.

  The library is [excellent](https://hex.pm/packages/excellent) like interface wrapper of [xlsx\_parser](https://hex.pm/packages/xlsx_parser).
  """

  @doc """
  The function returns worksheet name list of specifiled .xlsx file. If fail get content, return `:error`.

  ## Parameters
  - `path` : .xlsx file path
  - `zip` : An optional parameter of the zip processing module is allowed (for testing purposes).

  ## Example
  ```elixir
  > Excelion.get_worksheet_names("test.xlsx") |> elem(1)
  > ["sheet1", "sheet2", "sheet3"]
  ```
  """
  @spec get_worksheet_names(String.t, module) :: {:ok, [String.t]} | {:error, String.t}
  def get_worksheet_names(path, zip \\ :zip) do
    XlsxParser.get_worksheet_names(path, zip)
  end

  @doc """
  The function parse .xlsx file. If fail get content, return `:error.`

  ## Parameters
  - `path` : .xlsx file path
  - `sheet_number` : 0-based sheet number
  - `start_row` : first use row number (1-based)
  - `zip` : An optional parameter of the zip processing module is allowed (for testing purposes).

  ## Example
  ```elixir
  > sheet_number = 0
  > start_row = 5
  > Excelion.parse("test.xlsx", sheet_number, start_row) |> elem(1)
  > [
  >   ["ID", "name", "description", "value"],
  >   ["1",  "aaa",  "bbb",         "4"],
  >   ["2",  "ccc",  "",            "5"], # empty cell to be empty string
  >   ["3",  "eee",  "fff",         "6"]
  > ]
  ```
  """
  @spec parse(String.t, integer, integer, module) :: {:ok, [[String.t]]} | {:error, String.t}
  def parse(path, sheet_number, start_row, zip \\ :zip) do
    case XlsxParser.get_sheet_content(path, sheet_number + 1, zip) do
      {:error, reason} -> {:error, reason}
      {:ok, ret} ->
        filtered = Enum.filter(ret, fn {_colname, row, _value} -> row >= start_row end)
        max_col = Enum.max_by(filtered, fn {colname, _row, _value} -> colname end) |> elem(0)
        max_row = Enum.max_by(filtered, fn {_colname, row, _value} -> row end) |> elem(1)
        map = Enum.into(filtered, %{}, fn x -> {{elem(x, 0), elem(x, 1)}, elem(x, 2)} end)

        index_list = for row <- start_row..max_row, col <- 0..alpha_to_index(max_col), do:  {col, row}
        padded_list = Enum.map(index_list, fn {col_index, row} ->
          x = map[{index_to_alpha(col_index), row}]
          if x == nil do
            ""
          else
            x
          end
        end)

      {:ok, Enum.chunk(padded_list, alpha_to_index(max_col) + 1)}
    end
  end

  @doc """
  The function parse .xlsx file. If fail get content, raise `File.Error` exception.

  ## Parameters
  - `path` : .xlsx file path
  - `sheet_number` : 0-based sheet number
  - `start_row` : first use row number (1-based)
  - `zip` : An optional parameter of the zip processing module is allowed (for testing purposes).

  ## Example
  ```elixir
  > sheet_number = 0
  > start_row = 5
  > Excelion.parse!("test.xlsx", sheet_number, start_row)
  > [
  >   ["ID", "name", "description", "value"],
  >   ["1",  "aaa",  "bbb",         "4"],
  >   ["2",  "ccc",  "",            "5"], # empty cell to be empty string
  >   ["3",  "eee",  "fff",         "6"]
  > ]
  ```
  """
  @spec parse!(String.t, integer, integer, module) :: [[String.t]] | no_return
  def parse!(path, sheet_number, start_row, zip \\ :zip) do
    case parse(path, sheet_number, start_row, zip) do
      {:ok, ret} -> ret
      {:error, reason} -> raise File.Error, reason: reason, action: "open", path: path
    end
  end

  @spec alphas() :: [String.t]
  defp alphas do
    ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
     "AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS",
     "AT","AU","AV","AW","AX","AY","AZ"]
  end

  @spec alpha_to_index(String.t) :: integer
  defp alpha_to_index(alpha) do
    Enum.find_index(alphas, fn x -> x == alpha end)
  end

  @spec index_to_alpha(integer) :: String.t
  defp index_to_alpha(index) do
    Enum.at(alphas, index)
  end
end
