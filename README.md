# latex-template

This is a template for latex documents. While common mathematics-related latex
commands and packages are used, the makefile will be of use for any type of
document.


## Make

Included are four make targets.

* `final`:   Simply builds the document.
* `refinal`: Forcibly rebuilds the document, and if it doesn't exist, builds it
                 twice. This handles changing of labels.
* `draft`:   Builds the document as a draft. See below.
* `redraft`: Forcibly rebuilds the document as a draft.


## Draft

If the document is built as a draft, it is built with the macro `isdraft`
defined as `1`. This triggers the following effects:

1. The document class is set with the parameter `draft`, for use with the
   `ifdraft` package.
2. Labels are shown on the left side of the page
3. The `todo` notes are displayed.
4. The current git revision is displayed below the title.

