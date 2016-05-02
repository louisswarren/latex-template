DOCUMENT = template
DEPENDENCIES = template.tex


.DEFAULT_GOAL = draft


################################################################################



LATEX = pdflatex -file-line-error -halt-on-error
AUXONLY = "-draftmode"
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
	$(LATEX) -jobname $(DOCUMENT)-draft $(AUXONLY) $(DRAFTTEX)

# Double pass for setting references
.PHONY: redraft
redraft: $(DOCUMENT)-draft.aux $(DEPENDENCIES)
	$(LATEX) -jobname $(DOCUMENT)-draft $(DRAFTTEX)
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

# Double pass for setting references
.PHONY: refinal
refinal: $(DOCUMENT).aux $(DEPENDENCIES)
	$(LATEX) $(FINALTEX)
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
	rm -f *.pdf *.aux *.log *.toc .revisioninfo
###-------###

