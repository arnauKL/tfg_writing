# Bachelor's Thesis: Deep Learning-Based Classification of Parkinson's Disease from DaTscan Images

[Typst](https://typst.app) source code and pdf for the accompanying bachelor's thesis in Biomedical Engineering at the Universitat de Girona.
The full report is available [here](report.pdf).


The experimental codebase, including CNN implementations, preprocessing pipelines, and multimodal machine learning experiments, is maintained separately at [arnauKL/code_thesis](https://github.com/arnauKL/code_thesis).

## Building

Requires the `typst` compiler.

Compilation requires the Typst compiler.

```sh
git clone https://github.com/arnauKL/tfg_writing.git
cd tfg_writing/
typst compile report.typ
```

## Structure

- `report.typ`: Main report entry point
- `parts/`: Individual chapters and appendices
- `assets/`: Figures, bibliography, logos, utility files, and template resources
- `assets/ak_tfg_lib.typ`: Custom Typst template derived from [mousse-notes](https://github.com/dogeystamp/mousse-notes)

## License

This work is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
