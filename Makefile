###---------------###
### Configuration ###
###---------------###

# Name for the generated .pdf
# Example:
# 	DOCUMENT = template
DOCUMENT = template


# All files used by the main latex document (eg your .tex and .sty files)
# Example:
# 	DEPENDENCIES = template.tex template.sty
DEPENDENCIES = template.tex mymaths.sty


# Bibliography settings. If you don't have a bibliography, remove this line.
# Example one: with one bibliography file
# 	BIBDEPENDENCIES = bibliography.bib
BIBDEPENDENCIES = bibliography.bib


# UNCOMMENT THIS LINE IF YOU DO NOT HAVE A BIBLIOGRAPHY
# .IGNORE: $(BIBTARGETS)


# COMMENT OUT THIS LINE IF YOU ARE NOT USING GIT
REVISIONINFO = .revisioninfo


# Default build target
# Example:
# 	.DEFAULT_GOAL = finalre
.DEFAULT_GOAL = draft


# Arguments to pass to pdflatex
LATEXARGS = -file-line-error -halt-on-error

###---------------###



################################################################################
### Be wary when modifying below this line #####################################
################################################################################



###-----------###
### Constants ###
###-----------###

LATEX = pdflatex $(LATEXARGS)
LATEXAUX = pdflatex -draftmode $(LATEXARGS)
BIBTEX = bibtex
DRAFTTEX = "\def\isdraft{1} \input{$(DOCUMENT).tex}"
FINALTEX = "$(DOCUMENT).tex"
BIBTARGETS = $(DOCUMENT)-draft.bbl $(DOCUMENT).bbl draftbib finalbib
###-----------###



###-------------###
### Draft build ###
###-------------###

# Single-pass
.PHONY: draft
draft: $(DOCUMENT)-draft.pdf
$(DOCUMENT)-draft.pdf: $(DEPENDENCIES) $(REVISIONINFO)
	$(LATEX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Aux only
$(DOCUMENT)-draft.aux: $(DEPENDENCIES) $(REVISIONINFO)
	$(LATEXAUX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)

# Aux with bibliography
.PHONY: .draftauxbib
.draftauxbib: $(DEPENDENCIES) $(REVISIONINFO) $(DOCUMENT)-draft.bbl
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

$(REVISIONINFO): .git
	git log -1 --oneline > $(REVISIONINFO)
###---------------- ###



###-------###
### Tools ###
###-------###

.PHONY: clean
clean:
	rm -f *.aux *.toc *.log *.blg *.bbl *.pdf $(REVISIONINFO)
###-------###

