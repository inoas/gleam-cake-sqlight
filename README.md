# Adapter between `cake` and `sqlight`

[![Package <a href="https://github.com/inoas/gleam-cake-sqlight/releases"><img src="https://img.shields.io/github/release/inoas/gleam-cake-sqlight" alt="GitHub release"></a> Version](https://img.shields.io/hexpm/v/cake_sqlight)](https://hex.pm/packages/cake_sqlight)
[![Erlang-compatible](https://img.shields.io/badge/target-erlang-b83998)](https://www.erlang.org/)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/cake_sqlight/)
[![Discord](https://img.shields.io/discord/768594524158427167?label=discord%20chat&amp;color=5865F2)](https://discord.gg/Fm8Pwmy)

<!--
[![CI Test](https://github.com/inoas/gleam-cake-sqlight/actions/workflows/test.yml/badge.svg?branch=main&amp;event=push)](https://github.com/inoas/gleam-cake-sqlight/actions/workflows/test.yml)
-->

🎂[Cake](http://hex.pm/packages/cake) 🪶SQLite adapter which passes `PreparedStatement`s to the [sqlight](http://hex.pm/packages/sqlight) library for execution written in [Gleam](https://gleam.run/).

## Installation

```sh
gleam add cake_sqlight@1
```

## Example

Notice: Official cake adapters re-use the cake namespace, thus you can import them like
such: `import cake/adapter/sqlite`.

```gleam
import cake/adapter/sqlite
import cake/delete as d
import cake/insert as i
import cake/select as s
import cake/where as w
import gleam/dynamic

const sqlite_database_filename = "birds.sqlite3"

pub fn main() {
  // sqlite.with_memory_connection, fn(db_connection) { // If you only want to use an in-memory database
  sqlite.with_connection(sqlite_database_filename, fn(db_connection) {
    db_connection |> create_table_if_not_exists_birds
    db_connection |> insert_into_table_birds
    db_connection |> select_from_table_birds
    db_connection |> delete_from_table_birds
  })
}

fn create_table_if_not_exists_birds(db_connection) {
  "CREATE TABLE IF NOT EXISTS birds (
    species TEXT,
    average_weight FLOAT(8),
    is_extinct BOOLEAN
  );"
  |> sqlite.execute_raw_sql(db_connection)
  |> io.debug
}

fn insert_into_table_birds(db_connection) {
  [
    [i.string("Dodo"), i.float(14.05), i.bool(True)] |> i.row,
    [i.string("Great auk"), i.float(5.0), i.bool(True)] |> i.row,
  ]
  |> i.from_values(
      table_name: "birds",
      columns: [
        "species", "average_weight", "is_extinct",
      ]
  )
  |> i.to_query
  |> sqlite.run_write_query(dynamic.dynamic, db_connection)
  |> io.debug
}

fn select_from_table_birds(db_connection) {
  s.new()
  |> s.from_table("table")
  |> s.selects([s.col("species")])
  |> s.to_query
  |> sqlite.run_read_query(dynamic.dynamic, db_connection)
  |> io.debug
}

fn delete_from_table_birds(db_connection) {
  d.new()
  |> d.table("birds")
  |> d.where(w.col("species") |> w.eq(w.string("Dodo")))
  |> d.to_query
  |> sqlite.run_write_query(dynamic.dynamic, db_connection)
  |> io.debug
}
```

## Migrations

You may use the [storch library](http://hex.pm/packages/storch) to run SQLite
migrations.
