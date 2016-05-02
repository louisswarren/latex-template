DOCUMENT = template
DEPENDENCIES = template.tex
BIBDEPENDENCIES = bibliography.bib


.DEFAULT_GOAL = draft

LATEXARGS = -file-line-error -halt-on-error


################################################################################



LATEX = pdflatex $(LATEXARGS)
LATEXAUX = pdflatex -draftmode $(LATEXARGS)
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
	$(LATEXAUX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Aux with bibliography
.PHONY: .draftauxbib
.draftauxbib: $(DEPENDENCIES) .revisioninfo $(DOCUMENT)-draft.bbl
	$(LATEXAUX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Double pass for setting references
.PHONY: draftre
draftre: .draftauxbib $(DOCUMENT)-draft.bbl $(DEPENDENCIES)
	$(LATEX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Bibliography
.PHONY: draftbib
draftbib: $(DOCUMENT)-draft.bbl
$(DOCUMENT)-draft.bbl: $(DOCUMENT)-draft.aux $(BIBDEPENDENCIES)
	$(BIBTEX) $(DOCUMENT)-draft

# Full build
.PHONY: draftall
draftall: draftbib draftre
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
	$(LATEXAUX) $(FINALTEX)

# Aux with bibliography
.PHONY: .finalauxbib
.finalauxbib: $(DEPENDENCIES) $(DOCUMENT).bbl
	$(LATEXAUX) $(FINALTEX)

# Double pass for setting references
.PHONY: finalre
finalre: .finalauxbib $(DEPENDENCIES)
	$(LATEX) $(FINALTEX)

# Bibliography
.PHONY: finalbib
finalbib: $(DOCUMENT).bbl
$(DOCUMENT).bbl: $(DOCUMENT).aux $(BIBDEPENDENCIES)
	$(BIBTEX) $(DOCUMENT)

# Full build
.PHONY: finalall
finalall: finalbib finalre
###-------------###



###-----###
### All ###
###-----###

.PHONY: all
all: draftall finalall
###-----###



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
	rm -f *.aux *.toc *.log *.blg *.bbl *.pdf .revisioninfo
###-------###

