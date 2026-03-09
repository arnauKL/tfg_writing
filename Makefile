TARGET = report.pdf

# figures
FIGURE_DIR = figures
FIGURE_SOURCES = $(wildcard $(FIGURE_DIR)/*.typ)
FIGURE_OUTPUTS = $(FIGURE_SOURCES:.typ=.svg)


all: $(TARGET)

$(TARGET): report.typ $(FIGURE_OUTPUTS)
	typst compile report.typ $(TARGET)

$(FIGURE_DIR)/%.svg: $(FIGURE_DIR)/%.typ
	typst compile $< $@


.PHONY: clean

clean:
	rm -f $(FIGURE_OUTPUTS) report.pdf
