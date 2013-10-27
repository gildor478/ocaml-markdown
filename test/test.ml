(* Copyright (C) 2009 Mauricio Fernandez <mfp@acm.org> *)
open OUnit2

let tests =
  "Markdown" >:::
  [
    TestMarkdown.tests;
  ]

let () =
  run_test_tt_main tests
