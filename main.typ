#import "lib.typ": *
#set page(paper: "a4")

//#set page(foreground: text(rgb("#4444440e"), 12em, rotate(-45deg, [Esborrany])))

#show: book.with(
  title: [Deep Learning-Based Classification \ of Parkinson's Disease Stages \ Using DaTSCAN],
  shorttitle: [DL Classification of Parkinson's Stages (DaTSCAN)],
  subsubtitle: [Bachelor's Thesis],
  tutor: "Adrià Casamitjana",
  author: "Arnau K. Deprez",
  font-style: "serif",
)

//#set outline.entry(fill: "")
#set outline.entry(fill: repeat(text(.5em)[.], gap: 0.15em))
#show outline.entry.where(level: 1): set block(above: 1.375em, breakable: true)
#show outline.entry.where(level: 2): set outline.entry(fill: "")
//#show outline.entry.where(level: 2): set outline.entry(fill: repeat(text(.25em)[.], gap: 0.15em))

// one column
#show outline: it => align(center)[#block(width: 80%)[#it]]
#heading(numbering: none, outlined: false)[Contents]
#outline(title: none)

// 2 columns
// #block(height: 60%)[
//   #columns(2, gutter: 10%)[
//     #outline()
//   ]
// ]

#v(1fr)

#smallcaps[Copyright 2026] Arnau K. Deprez Santamaria
#grid(
  columns: (auto, 1fr),
  gutter: .75em,
  image("assets/by.svg", width: 100pt),
  [
    #set text(hyphenate: false)
    This work is licensed under the _Creative Commons Attribution 4.0
    International License_. To view a copy of this license, visit #link("http://creativecommons.org/licenses/by/4.0/").
  ],
)

#pagebreak()


// ---------- Content ----------

// 1. Introducció
// 2. Conceptes previs
// 3. Estat de l’art
// 4. Hipòtesis i objectius
// 5. Materials i mètodes
// 6. Resultats
// 7. Discussió
// 8. Conclusions
// Referències.
// Annex A. Planificació
// Annex B. Codi
// Annex C. Pressupost
// Annex D. Comitè d’Ètica
#place(horizon + right)[
  #heading(outlined: false, numbering: none)[Acknowledgements]
  I'd like to thank my mom.
]


= Introduction <ch_intro>
#counter(page).update(1) // Reset page num to 1

//= Previous Concepts <ch_prev_concepts>
= Theoretical Background <ch_coneix_prev>

#lorem(33)

#lorem(33)
#lorem(33)

#lorem(33)
#lorem(43)
#lorem(34)

== a

#lorem(33)

== b

#lorem(13)
#lorem(38)

#lorem(123)

#lorem(38)

#lorem(48)

== cdfaksjfa

#lorem(148)

since when

#figure(
  image("assets/by.svg", width: 60%),
  caption: [A test],
)

#lorem(48)

#figure(
  ```c
  #include <stdio.h>

  int
  main(void)
  {
    printf("Hello, world!\n");
    return 0;
  }
  ```,
  caption: [A test],
)

#lorem(48)


= State of the Art <ch_state_of_the_art>
// = Hypothesis and Objectives <ch_hypothesis>
// = Materials and methods <ch_materials_n_methods>
// = Results <ch_results>
// = Discussion <ch_discussion>
// = Conclusions <ch_conclusions>

//= References (unnumbered section)
#bibliography("assets/references.bib", title: [References]) <ch_bibliography>

#show: appendix

#align(center, line(length: 90%, stroke: .5pt))
#v(1.5%)
#text(1.5em, style: "italic")[List of Figures]
#v(1.5%)
#outline(title: none, target: figure.where(kind: image))
#text(1.5em, style: "italic")[List of Tables]
#v(1.5%)
#outline(title: none, target: figure.where(kind: table))

// = Planning <app_planning>
// #figure(
//     image("assets/figures/gantt.svg"),
//     caption: [ Gantt diagram. ],
//     alt: "Gantt diagram",
// )

= Code <app_code>

This project has been version controlled since I started it and its hosted on GitHub. It can be found at #link("https://github.com/arnauKL/codi_tfg")[`arnauKL/tfg`].


// = Budget <app_budget>
// = Ethics committee / Ethical Considerations <app_ethics>


#heading(outlined: false)[Colophon]

This thesis was typeset in #link("https://typst.app")[Typst] using a customised version of the #link("https://typst.app/universe/package/mousse-notes")[mousse-notes] template. The body text is set in #link("https://www.linuxlibertine.org/")[Linux Libertine] and code listings in #link("https://github.com/microsoft/cascadia-code")[Caskaydia Cove]. All tools used in its production are free and open-source software.
