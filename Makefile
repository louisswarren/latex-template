DOCUMENT = template

LATEX = pdflatex -file-line-error -halt-on-error




# Draft build
.PHONY: draft
draft: $(DOCUMENT)-draft.pdf

$(DOCUMENT)-draft.pdf: *.tex .revisioninfo
	$(LATEX) -jobname $(DOCUMENT)-draft "\def\isdraft{1} \input{$(DOCUMENT).tex}"


# Final build
.PHONY: final
final: $(DOCUMENT).pdf

$(DOCUMENT).pdf: *.tex
	$(LATEX) "$(DOCUMENT).tex"


.PHONY: all
all: $(DOCUMENT).pdf
	$(LATEX) "$(DOCUMENT).tex"

.revisioninfo: .git
	git log -1 --oneline > .revisioninfo

.PHONY: clean
clean:
	rm -f *.pdf *.aux *.log *.toc .revisioninfo
