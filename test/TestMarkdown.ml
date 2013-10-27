(* Copyright (C) 2009 Mauricio Fernandez <mfp@acm.org> *)
open OUnit2
open Markdown
open Printf

let aeq_pars ?msg expected actual =
  assert_equal ?msg expected actual

let check expected input =
  aeq_pars ~msg:(sprintf "With input:\n%s\n" (BatString.strip input))
    expected (parse_text input)

let test_read_list test_ctxt =
  check
    [Ulist ([Normal [Text "foo "; Bold "bar"]], [[Normal [Text "baz"]]])]
    "* foo\n*bar*\n* baz";
  check
    [Ulist ([Normal [Text "foo bar baz"]], [[Normal [Text "baz"]]])]
    "* foo\nbar \n   baz\n* baz";
  check
    [Ulist ([Normal [Text "foo"]; Normal [Text "bar"]], [[Normal [Text "baz"]]])]
    "* foo\n\n bar\n* baz";
  check
    [Ulist ([Normal [Text "foo"]], [])]
    "* foo";
  check
    [Ulist ([Normal [Text "foo"]], [[Normal [Text "bar"]]])]
    "* foo\n* bar";
  check
    [Ulist ([Normal [Text "foo"]], [[Normal [Text "bar"]]])]
    "* foo\n\n* bar";
  check
    [Ulist ([Normal [Text "foo"]; Ulist ([Normal [Text "bar"]], [])],
            [])]
    "* foo\n\n * bar";
  check
    [Ulist ([Normal [Text "foo"]; Ulist ([Normal [Text "bar"]], []);
             Olist ([Normal [Text "1"]], [[Normal [Text "2"]]])],
            []);
     Olist ([Normal [Text "3"]], [])]
    "* foo\n\n * bar\n # 1\n # 2\n# 3";
  check
    [Ulist ([Normal [Text "foo"]; Ulist ([Normal [Text "bar"]], []);
             Olist ([Normal [Text "1"]], [[Normal [Text "2 #3"]]])],
            [])]
    "* foo\n\n * bar\n # 1\n # 2\n#3";
  check
    [Ulist
       ([Normal [Text "some paragraph"]; Normal [Text "And another one."]],
        [[Normal [Text "two"]]; [Normal [Text "three"]]])]
    "
     *   some
         paragraph

         And another one.

     *   two
     *   three
    ";
  check
    [Ulist ([Normal [Text "foo "; Bold "bar baz"]; Normal [Text "xxx"]],
            [[Normal [Text "baz"]]])]
    "*\tfoo\n*bar\n baz*\n\n xxx\n\n* baz";
  check
    [Normal [Text "foo"]; Ulist ([Normal [Text "bar"]], [])]
    "foo\n*\tbar";
  check
    [Olist ([Normal [Text "one"]],
            [[Normal [Text "two"]]; [Normal [Text "three"]]])]
    "
     #\tone
     #\ttwo
     #\tthree"

let test_read_normal test_ctxt =
  check [Normal [Text "foo "; Struck [Text " bar baz "]; Text " foobar"]]
    "foo == bar\nbaz == foobar";
  check
    [Normal
       [Text "foo "; Bold "bar"; Text " "; Bold "baz"; Text " ";
        Emph "foobar"; Text " _foobar_";
        Link { href_target = "target"; href_desc = "desc"};
        Image { img_src = "image"; img_alt = "alt"};
        Text "."]]
    "foo *bar* *baz* __foobar__ _foobar_[desc](target)![alt](image).";
  check
    [Normal [Bold "foo"; Text " "; Struck [Bold "foo"; Emph "bar"; Text "_baz_"]]]
    "*foo* ==*foo*__bar___baz_==";
  check
    [Normal
       [Link { href_target = "http://foo.com"; href_desc = "http://foo.com" }]]
    "[http://foo.com]()";
  check [Normal [Text ""]] "[]()";
  check
    [Normal
       [Text "foo "; Anchor "internal-link"; Text ". ";
        Link { href_target = "#internal-link"; href_desc = "back" }]]
    "foo [](#internal-link). [back](#internal-link)"

let test_read_normal_unmatched test_ctxt =
  check [Normal [Text "foo * bar"]] "foo * bar";
  check [Normal [Text "foo _ bar"]] "foo _ bar";
  check [Normal [Text "foo __ bar"]] "foo __ bar";
  check [Normal [Text "foo == bar"]] "foo == bar";
  check [Normal [Text "foo == bar"]; Normal [Text "baz =="]] "foo == bar\n\nbaz =="

let test_read_pre test_ctxt =
  check
    [Normal [Text "foo * bar"];
     Pre("a\n b\n  c\n", None);
     Pre("a\\0\\1\\2\n b\n  c\n", Some "whatever")]
    "foo * bar\n{{\na\n b\n  c\n}}\n\n{{whatever\na\\0\\1\\2\n b\n  c\n}}\n  ";
  check
    [Pre("a\n b\n  c\n", Some "foobar")]
    "{{foobar
     a
      b
       c
     }}";
  check
    [Pre("a\n b\n  c\n", Some "foo")]
    "  {{foo
         a
          b
           c
         }}";
  check
    [Pre("a\n }}\n  \\}}\n   }}}\n", None)]
    "{{
       a
        \\}}
         \\\\}}
          }}}
     }}"

let test_heading test_ctxt =
  for i = 1 to 6 do
    check
      [Heading (i, [Text "foo "; Link { href_target = "dst"; href_desc = "foo" }])]
    (String.make i '!' ^ "foo [foo](dst)")
  done

let test_quote test_ctxt =
  check [Quote [Normal [Text "xxx"]]] "> xxx";
  check [Quote [Normal [Text "xxx"]]] "> \n> xxx\n> ";
  check [Normal [Text "foo says:"];
         Quote [Normal [Text "xxx:"];
                Ulist ([Normal [Text "xxx yyy"]],
                       [[Normal [Emph "2"]]; [Normal [Text "_2_"]]; [Normal [Bold "3"]]]);
                Quote [Normal [Text "yyy"]; Quote [Normal [Text "zzz"]];
                       Normal [Text "aaa"]]]]
    "foo says:\n\
     \n\
     > xxx:\n\
     > * xxx\n\
     >   yyy\n\
     > * __2__\n\
     > * _2_\n\
     > * *3*\n\
     > > yyy\n\
     > > > zzz\n\
     > > aaa\n\
     \n\
     ";
  check [Quote [Ulist ([Normal [Text "one"]; Normal [Text "xxx"]],
                       [[Normal [Text "two"]]])]]
    "> * one\n\
     >\n\
     >   xxx\n\
     > * two\n\
     \n"

let test_oasis test_ctxt = 
check 
[Normal 
   [Text "OASIS generates a full configure, build and install system \
          for your application. It starts with a simple ";
    Code "_oasis";
    Text " file at the toplevel of your project and creates everything \
          required."];
 Normal 
   [Text "It uses external tools like OCamlbuild and it can be considered \
          as the glue between various subsystems that do the job. It \
          should support the following tools:"];

 Ulist
   ([Normal [Text "OCamlbuild"]],
    [[Normal [Text "OMake (todo)"]];
     [Normal [Text "OCamlMakefile (todo)"]];
     [Normal [Text "ocaml-autoconf (todo)"]]]);

 Normal
   [Text "It also features a do-it-yourself command line invocation and an \
          internal configure/install scheme. Libraries are managed through \
          findlib. It has been tested on GNU Linux and Windows."];

 Normal
   [Text "It also allows to have standard entry points and description. It \
          helps to integrates your libraries and software with third parties \
          tools like GODI."]]

"OASIS generates a full configure, build and install system for your
application. It starts with a simple `_oasis` file at the toplevel of your
project and creates everything required.

It uses external tools like OCamlbuild and it can be considered as the glue
between various subsystems that do the job. It should support the following
tools: 

- OCamlbuild
- OMake (todo)
- OCamlMakefile (todo)
- ocaml-autoconf (todo)

It also features a do-it-yourself command line invocation and an internal 
configure/install scheme. Libraries are managed through findlib. It has been
tested on GNU Linux and Windows.

It also allows to have standard entry points and description. It helps to 
integrates your libraries and software with third parties tools like GODI."

let tests =
  "Simple_markup" >:::
  [
    "Normal" >:: test_read_normal;
    "Normal, unmatched delimiters" >:: test_read_normal_unmatched;
    "Ulist and Olist" >:: test_read_list;
    "Pre" >:: test_read_pre;
    "Heading" >:: test_heading;
    "Quote" >:: test_quote;
    "OASIS" >:: test_oasis;
  ]
