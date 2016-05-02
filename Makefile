DOCUMENT = template
DEPENDENCIES = template.tex


.DEFAULT_GOAL = draft


################################################################################



LATEX = pdflatex -file-line-error -halt-on-error
DRAFTMODE = "\def\isdraft{1} \input{$(DOCUMENT).tex}"



# Draft build
.PHONY: draft
draft: $(DOCUMENT)-draft.pdf
$(DOCUMENT)-draft.pdf: $(DEPENDENCIES) .revisioninfo
	$(LATEX) -jobname $(DOCUMENT)-draft $(DRAFTMODE)

.PHONY: redraft
redraft: $(DOCUMENT)-draft.pdf
	$(LATEX) -jobname $(DOCUMENT)-draft $(DRAFTMODE)
###



# Final build
.PHONY: final
final: $(DOCUMENT).pdf
$(DOCUMENT).pdf: $(DEPENDENCIES)
	$(LATEX) "$(DOCUMENT).tex"

.PHONY: refinal
refinal: $(DOCUMENT).pdf
	$(LATEX) "$(DOCUMENT).tex"
###



# Git revisioning
.revisioninfo: .git
	git log -1 --oneline > .revisioninfo
###



# Tools
.PHONY: clean
clean:
	rm -f *.pdf *.aux *.log *.toc .revisioninfo
###

