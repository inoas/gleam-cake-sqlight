import birdie
import cake/delete as d
import cake/where as w
import pprint.{format as to_string}
import test_helper/sqlite_test_helper
import test_support/adapter/sqlite

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Setup                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

fn delete() {
  d.new()
  |> d.table("owners")
  |> d.where(w.col("owners.name") |> w.eq(w.string("Alice")))
}

fn delete_sqlite() {
  delete()
  |> d.returning(["owners.id"])
}

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Tests                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

pub fn delete_test() {
  let lit = delete_sqlite() |> d.to_query

  lit
  |> to_string
  |> birdie.snap("delete_test")
}

pub fn delete_prepared_statement_test() {
  let lit =
    delete_sqlite() |> d.to_query |> sqlite.write_query_to_prepared_statement

  lit
  |> to_string
  |> birdie.snap("delete_prepared_statement_test")
}

pub fn delete_execution_result_test() {
  let lit =
    delete_sqlite() |> d.to_query |> sqlite_test_helper.setup_and_run_write

  lit
  |> to_string
  |> birdie.snap("delete_execution_result_test")
}
