DOCUMENT = template
DEPENDENCIES = template.tex
BIBDEPENDENCIES = bibliography.bib


.DEFAULT_GOAL = draft


################################################################################



LATEX = pdflatex -file-line-error -halt-on-error
AUXONLY = -draftmode
BIBTEX = bibtex
DRAFTTEX = "\def\isdraft{1} \input{$(DOCUMENT).tex}"
FINALTEX = "$(DOCUMENT).tex"



###-------------###
### Draft build ###
###-------------###

# Single-pass
.PHONY: draft
draft: $(DOCUMENT)-draft.pdf
$(DOCUMENT)-draft.pdf: $(DEPENDENCIES) .revisioninfo
	$(LATEX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Aux only
$(DOCUMENT)-draft.aux: $(DEPENDENCIES) .revisioninfo
	$(LATEX) $(AUXONLY) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Aux with bibliography
.PHONY: draftauxbib
draftauxbib: $(DEPENDENCIES) .revisioninfo $(DOCUMENT)-draft.bbl
	$(LATEX) $(AUXONLY) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Double pass for setting references
.PHONY: redraft
redraft: draftauxbib $(DOCUMENT)-draft.bbl $(DEPENDENCIES)
	$(LATEX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Bibliography
.PHONY: draftbib
draftbib: $(DOCUMENT)-draft.bbl
$(DOCUMENT)-draft.bbl: $(DOCUMENT)-draft.aux $(BIBDEPENDENCIES)
	$(BIBTEX) $(DOCUMENT)-draft
###-------------###



###-------------###
### Final build ###
###-------------###

# Single-pass
.PHONY: final
final: $(DOCUMENT).pdf
$(DOCUMENT).pdf: $(DEPENDENCIES)
	$(LATEX) $(FINALTEX)

# Aux only
$(DOCUMENT).aux: $(DEPENDENCIES)
	$(LATEX) $(AUXONLY) $(FINALTEX)

# Aux with bibliography
.PHONY: auxbib
auxbib: $(DEPENDENCIES) $(DOCUMENT).bbl
	$(LATEX) $(AUXONLY) $(FINALTEX)

# Double pass for setting references
.PHONY: refinal
refinal: auxbib $(DEPENDENCIES)
	$(LATEX) $(FINALTEX)

# Bibliography
.PHONY: bib
bib: $(DOCUMENT).bbl
$(DOCUMENT).bbl: $(DOCUMENT).aux $(BIBDEPENDENCIES)
	$(BIBTEX) $(DOCUMENT)
###-------------###



###---------------- ###
### Git revisioning ###
###---------------- ###

.revisioninfo: .git
	git log -1 --oneline > .revisioninfo
###---------------- ###



###-------###
### Tools ###
###-------###

.PHONY: clean
clean:
	rm -f *.aux *.log *.blg *.bbl *.pdf .revisioninfo
###-------###

