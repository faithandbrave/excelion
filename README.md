# excelion
Excel (xlsx) file reader for Elixir.

- Docs : <https://hexdocs.pm/excelion/>
- Hex package : <https://hex.pm/packages/excelion>

The library is [excellent](https://hex.pm/packages/excellent) like interface wrapper of [xlsx\_parser](https://hex.pm/packages/xlsx_parser).

The library provide simple 2 APIs.

`get_worksheet_names` function returns worksheet name list.

```elixir
> Excelion.get_worksheet_names("test.xlsx") |> elem(1)
> ["sheet1", "sheet2", "sheet3"]
```


`parse`/`parse!` function returns sheet values matrix.

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

