# latex-template

This is a template for latex documents. While common mathematics-related latex
commands and packages are used, the makefile will be of use for any type of
document.


## Make

Included are four make targets.

* `final`: Simply builds the document.
* `refinal`: Forcibly rebuilds the document, and if it doesn't exist, builds it
             twice. This handles changing of labels.
* `draft`: Builds the document with the macro `isdraft` defined as `1`. See below.
* `redraft`: Forcibly rebuilds the draft, as above.

