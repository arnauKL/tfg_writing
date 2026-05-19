#import "../assets/ak_tfg_lib.typ": *

#page(footer: none)[
  // Outline
  #heading(numbering: none, outlined: false)[Contents]
  #v(-3em)
  #outline(title: none)

  // List of Figures and List of Tables
  //#lof
  //#lot

  #v(1fr)

  // Copyright note
  #smallcaps[Copyright 2026] Arnau K. Deprez Santamaria
  #grid(
    columns: (auto, 1fr),
    gutter: .75em,
    image("../assets/by.svg", width: 100pt),
    [
      #set text(hyphenate: false)
      This work is licensed under the _Creative Commons Attribution 4.0
      International License_. To view a copy of this license, visit #link("http://creativecommons.org/licenses/by/4.0/").
    ],
  )
]

#pagebreak()

// Acknowledgements
// #page(footer: none)[
//   #place(horizon + right)[
//     #heading(outlined: false, numbering: none)[Acknowledgements]
//     I'd like to thank my mom.
//   ]
// ]
