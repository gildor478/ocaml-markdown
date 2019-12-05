OCaml-markdown markdown parser and printer written in OCaml
===========================================================

[![Travis status][travis-img]][travis]
[![AppVeyor status][appveyor-img]][appveyor]

This is a pure OCaml parser for a non-standard dialect Markdown. It was originally
written for Ocsigen but may be useful in other contexts too.

[travis]:         https://travis-ci.org/gildor478/ocaml-markdown
[travis-img]:     https://travis-ci.org/gildor478/ocaml-markdown.svg?branch=master
[appveyor]:       https://ci.appveyor.com/project/gildor478/ocaml-markdown
[appveyor-img]:   https://ci.appveyor.com/api/projects/status/4ma2vpumkqfo7cq2/branch/master?svg=true
[opam]:           https://opam.ocaml.org

Installation
------------

The recommended way to install ocaml-markdown is via the [opam package manager][opam]:

```sh
$ opam install markdown
```

Documentation
-------------

* API documentation is
  [available online](https://gildor478.github.io/ocaml-markdown).
  
Differences with standard Markdown syntax
------------------------------------------

The main differences of `ocaml-markdown` dialect with [the markdown standard](https://daringfireball.net/projects/markdown/syntax) are:
- `{{` and `}}` are used to surround code blocks
- Leading `!` are used for headings, the count defines the heading level
- `#` are used for ordered list 

For example the following Markdown text:
```
# Heading 1

    let f x y = x + y

Heading 2
---------

1. first element
2. second element
```

This text should be written the following way:
```
! Heading 1

{{
let f x y = x + y
}}

!! Heading 2

# first element
# second element
```




