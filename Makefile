template.pdf: template.tex .revisioninfo
	pdflatex template

.PHONY: all
all: template.pdf
	pdflatex template

.revisioninfo: .git
	git log -1 --oneline > .revisioninfo

.PHONY: clean
clean:
	rm -f *.pdf *.aux *.log *.toc .revisioninfo
