import gleam/io

/// As a library *cake_sqlight* cannot be invoked directly in a meaningful way.
///
@internal
pub fn main() {
  {
    "\n" <> "cake_sqlight is an adapter library and cannot be invoked directly."
  }
  |> io.println
}
