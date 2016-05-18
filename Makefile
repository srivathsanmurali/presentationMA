OUTFILE_REL = SrivathsanPresentationMA.pdf
OUTFILE_DEV = dev.pdf
JOB_DEV = dev
BUILD = build/
MAIN_TEX = main.tex

all: release

release: $(OUTFILE_REL)
dev: $(OUTFILE_DEV)
preview:
	@xdg-open $(BUILD)$(OUTFILE_DEV)

watch:
	@while true; do\
		inotifywait -e modify *.tex; \
		make dev; \
	done

$(OUTFILE_REL): $(OUTFILE_DEV)
	@gs -dQUIET -dNOPAUSE -dBATCH \
		-sDEVICE=pdfwrite \
		-dCompatibilityLevel=1.4 \
	        -dPDFSETTINGS=/printer \
		-dColorConversionStrategy=/LeaveColorUnchanged \
		-sOutputFile=$@ $(BUILD)$(OUTFILE_DEV)
	@ls -chlS $(BUILD)$< $@

$(OUTFILE_DEV): $(MAIN_TEX) *.tex
	@if [ ! -d $(BUILD) ]; then \
		mkdir $(BUILD); \
	fi
	@cd $(BUILD); \
		latexmk -jobname=$(JOB_DEV) \
		-latexoption="-shell-escape -include-directory=../" \
		-pdf ../$<

clean:
	@if [ -d $(BUILD) ]; then \
		rm -rf $(BUILD); \
		echo "rm -rf $(BUILD)"; \
	fi
	rm -f $(OUTFILE_REL)
	rm -f *.bbl *.thm *.toc *.out
