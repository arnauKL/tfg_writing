#import "../template.typ": *
#import "../metadata.typ": *

// ---------------------- title page ----------------------
// Inspiration taken from: https://typst.app/universe/package/red-agora

#place(top + left)[
  // Not having a publicly available svg for their
  // logo is something only this uni could do.
  #image("../images/EPS.png", width: 50%)
]

#place(horizon + center, dy: -1cm)[
  #smallcaps[ Final Year Thesis ]

  #line(stroke: .3pt, length: 60%)
  #box([

    #set text(1.6em, font: "Linux Libertine Display")

    *#ak_title*
  ])


  #line(stroke: .3pt, length: 60%)

  #v(2em)

  #box(width: 90%)[
    #grid(
      columns: 2,
      column-gutter: 1fr,
      align(left)[#smallcaps[Author] \ #text(
        size: 1.1em,
      )[Arnau K. Deprez Santamaria]],
      align(right)[#smallcaps[Tutor] \ #text(
        size: 1.1em,
      )[Adrià Casamitjana]],
    )
  ]
]

#place(bottom + center)[
  #show: smallcaps
  #set text(tracking: 0.06em)
  Biomedical Engineering \
  Computer Architecture and Technology \
  Academic Year: 2025-2026
]

#pagebreak()

