(* Copyright (C) 2009 Mauricio Fernandez <mfp@acm.org> *)
open OUnit

let tests = 
  "All tests" >:::
  [
    TestMarkdown.tests;
  ]

let () =
  ignore (run_test_tt_main tests)
