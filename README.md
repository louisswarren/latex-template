latex-template
==============

This is a template for latex documents. While common mathematics-related latex
commands and packages are used, the makefile will be of use for any type of
document.


If you just want to easily compile latex documents and aren't interested in the
draft version capabilities (see below), you may wish to try
[latexmk](https://www.ctan.org/pkg/latexmk/) instead.  In terms of simply
compiling documents, the primary difference between this project and latexmk is
that I don't know how to use latexmk.



Make
----

Included are several make targets:

* `final`:    Simply builds the document.
* `finalbib`: Build the bibliography.
* `finalre`:  Forcibly rebuilds the document, and if it doesn't exist, builds it
                  twice. This handles changing of labels.
* `finalall`: Performs a complete build (equivalent to `finalbib` + `finalre`).

In short: use `make final` after normal changes, use `make finalre` after
changes involving labels, and use `make finalall` after modifying the
bibliography.

There are also the targets `draft`, `draftbib`, `draftre`, and `draftall`,
which do the same but build draft versions (see below).  Finally, there is the
`all` target, which will build both the draft and final versions.

The default build target is `draft`, though this is easily modifiable. This is
for convenience, as it will be by far the most used target when writing
documents.



Draft and final versions
------------------------

If the document is built as a draft, it is built with the macro `isdraft`
defined as `1`. This triggers the following effects:

1. The document class is set with the parameter `draft`, for use with the
   `ifdraft` package.
2. Labels are shown on the left side of the page
3. The `\todo` notes are displayed.
4. The command `\noref` will produce a red question mark.
5. The current git revision is displayed below the title.

On final builds, the above are all hidden.



Bibliography
------------

The makefile contains all the information required for configuring it. Take
note of how to build a document with no bibliography; you must remove the
`BIBDEPENDENCIES` line and *uncomment* the `.IGNORE: $(BIBTARGETS)` line. If
you do this, you can perform full builds using `finalre` and `draftre` (though
`all` will still work, performing redundant steps).



Git
---

By default, when in draft mode, the generated document will display the most
recent git commit short SHA1 and message. This is done by writing to
`.revisioninfo` inside the makefile. The filename used can be modified by
changing it once `Makefile` and once in `template.tex` (you will probably want
to change it in `.gitignore` too). To disable the output all together (for
example if you aren't using git), simply delete these sections.



Build explanation
-----------------

A full build (eg `finalall`) consists of the following steps:

1. Use `pdflatex` to build the `.aux` file, containing all used citations
2. Use `bibtex` to build the `.bbl` file using the `.aux` file. This contains
   the required bibliography entries.
3. Use `pdflatex` to rebuild the `.aux` file by adding the found citations from
   the `.bbl` file.
4. Use `pdflatex` to produce the final `.pdf` file from the `.aux` file.
