TARGET = report_TFG_ArnauKDeprez2026.pdf

# figures
#FIGURE_DIR = assets/figures
#FIGURE_SOURCES = $(wildcard $(FIGURE_DIR)/*.typ)
#FIGURE_OUTPUTS = $(FIGURE_SOURCES:.typ=.svg)

all: $(TARGET)

#$(TARGET): main.typ $(FIGURE_OUTPUTS)
$(TARGET): main.typ
	typst compile main.typ $(TARGET)

# $(FIGURE_DIR)/%.svg: $(FIGURE_DIR)/%.typ
# 	typst compile $< $@

.PHONY: clean

clean:
	rm -f $(FIGURE_OUTPUTS) $(TARGET) main.pdf
# 'main.pdf' generates as an artifact when using typst watch
