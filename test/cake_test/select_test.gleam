import birdie
import cake/fragment as f
import cake/select as s
import pprint.{format as to_string}
import test_helper/sqlite_test_helper
import test_support/adapter/sqlite

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Setup                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

const const_field = "age"

fn select_query() {
  s.new()
  |> s.from_table("cats")
  |> s.selects([
    s.col("name"),
    s.string("hello"),
    s.fragment(f.literal(const_field)),
    s.alias(s.col("age"), "years_since_birth"),
  ])
  |> s.to_query
}

fn select_distinct_query() {
  s.new()
  |> s.from_table("cats")
  |> s.distinct
  |> s.selects([s.col("is_wild")])
  |> s.order_by_asc("is_wild")
  |> s.to_query
}

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Tests                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

pub fn select_test() {
  select_query()
  |> to_string
  |> birdie.snap("select_test")
}

pub fn select_prepared_statement_test() {
  let lit = select_query() |> sqlite.read_query_to_prepared_statement

  lit
  |> to_string
  |> birdie.snap("select_prepared_statement_test")
}

pub fn select_execution_result_test() {
  let lit = select_query() |> sqlite_test_helper.setup_and_run

  lit
  |> to_string
  |> birdie.snap("select_execution_result_test")
}

pub fn select_distinct_test() {
  select_distinct_query()
  |> to_string
  |> birdie.snap("select_distinct_test")
}

pub fn select_distinct_prepared_statement_test() {
  let lit = select_distinct_query() |> sqlite.read_query_to_prepared_statement

  lit
  |> to_string
  |> birdie.snap("select_distinct_prepared_statement_test")
}

pub fn select_distinct_execution_result_test() {
  let lit = select_distinct_query() |> sqlite_test_helper.setup_and_run

  lit
  |> to_string
  |> birdie.snap("select_distinct_execution_result_test")
}
