// main.typ
#import "template.typ": *
#import "metadata.typ": *

#show: tfg_template_ak.with(
    title: ak_title,
    short_title: ak_short_title,
    author: ak_author,
    tutor: ak_tutor,
)

// Project structure:
// https://sitandr.github.io/typst-examples-book/book/basics/must_know/project_struct.html


// --------------------------------------------
// ----------------- Document -----------------
// --------------------------------------------

#include "chapters/titlepage.typ"

// ---------- Outline & License Note ----------

//#set outline.entry(fill: repeat([.], gap: 0.15em))// default
#set outline.entry(fill: repeat([~], gap: 0.15em))

#align(center)[#box(
  // Might change later on to a 2-column layout if it gets long
  width: 80%,
  outline()
)]

#v(1fr)
#line(stroke: 0.25pt + gray, length: 100%)
#include "chapters/license-note.typ"

#pagebreak()

// ----------  ----------

#place(horizon + right)[
  #set par(justify: false)
  #text(1.6em, font: "Linux Libertine Display")[
    *Acknowledgements*
  ]
]
#pagebreak()


#counter(page).update(1) // Reset page num to 1

// // Add header with pagenum
// #set page(
//     header: context [
//         #text(.70em)[
//             #show: smallcaps
//             #ak_short_title
//             #h(1fr)
//             #context(counter(page).display("1 of 1", both: true))
//             // #v(-2em)
//             #v(-.75em)
//             #line(stroke: .25pt, length: 100%)
//         ]
//     ],
// )
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

= Introduction
= Previous Concepts
= State of the Art
= Hypothesis and Objectives (goals?)
= Materials and methods
= Results
= Discussion
= Conclusions
= References (unnumbered section)

// Annex A. Planning
// Annex B. Code
// Annex C. Budget
// Annex D. Ethics committee

// Per començar la secció d'apèndixs
#show: appendix

// Annex A. Planning
= Planning

#figure(
    image("images/figures/gantt.svg"),
    caption: [ Gantt diagram. ],
    alt: "Gantt diagram",
)

// Annex B. Code
= Code

This project has been version controlled since I started it and its hosted on
GitHub. It can be found at #link("https://github.com/arnauKL/codi_tfg")[`arnauKL/tfg`].

// Annex C. Budget
= Budget


// Annex D. Ethics committee
= Ethics Committee


#include "chapters/colophon.typ"
