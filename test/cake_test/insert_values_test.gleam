import birdie
import cake/insert as i
import pprint.{format as to_string}
import test_helper/sqlite_test_helper
import test_support/adapter/sqlite

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Setup                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

fn insert_values() {
  [[i.string("Whiskers"), i.float(3.14), i.int(42)] |> i.row]
  |> i.from_values(table_name: "cats", columns: ["name", "rating", "age"])
  |> i.returning(["name"])
}

fn insert_values_query() {
  insert_values()
  |> i.to_query
}

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Test                                                                     │
// └───────────────────────────────────────────────────────────────────────────┘

pub fn insert_values_test() {
  let lit = insert_values_query()

  lit
  |> to_string
  |> birdie.snap("insert_values_test")
}

pub fn insert_values_prepared_statement_test() {
  let lit = insert_values_query() |> sqlite.write_query_to_prepared_statement

  lit
  |> to_string
  |> birdie.snap("insert_values_prepared_statement_test")
}

pub fn insert_values_execution_result_test() {
  let lit = insert_values_query() |> sqlite_test_helper.setup_and_run_write
  lit
  |> to_string
  |> birdie.snap("insert_values_execution_result_test")
}
