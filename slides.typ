/*
 *
 *
 *
 * References:
 * https://polylux.dev/book/
 * https://github.com/Woelkchen/uni-ms-pres-schloss
 */
#import "@preview/polylux:0.4.0": *
#import "@preview/polylux:0.4.0": slide as s

#let dark = true

#let x-margin = 2em
#let y-margin = 4em

// Make the paper dimensions fit for a presentation and the text larger
#set page(
  paper: "presentation-16-9",
  //paper: "presentation-4-3",
  margin: (x: x-margin, y: y-margin),
)
#set text(size: 20pt, font: "Adwaita Sans")

// Colors
#let accent = rgb("#c64600")
#let accent2 = rgb("#9141ac")
#let yellow = rgb("#f8e45c")
#let dark-grey = rgb("#f6f5f4")
#let medium-grey = rgb("#c0bfbc")
#let light-grey = rgb("#5e5c64")
#let grey = rgb("#9a9996")
#let bg = rgb("#ffffff")

#if dark {
  accent = rgb("#c64600")
  yellow = rgb("#f8e45c")
  light-grey = rgb("#f6f5f4")
  medium-grey = rgb("#c0bfbc")
  dark-grey = rgb("#77767b")
  grey = rgb("#9a9996")
  bg = rgb("#000000")
}

#set page(fill: bg)
#set text(fill: light-grey)

// Functions
#let page-progress = {
  toolbox.progress-ratio(ratio => {
    stack(
      dir: ltr,
      line(stroke: 1pt + accent, length: ratio * 100% + 2 * x-margin),
    )
  })
}

// custom slides

#let slide(
  heading: none,
  section-name: none,
  show-section: true,
  block-height: none,
  progress: true,
  body,
) = {
  if section-name != none {
    toolbox.register-section(section-name)
  }
  // override default slide
  let content = {
    body
    if progress {
      place(bottom, dx: -x-margin, dy: y-margin - 1pt, page-progress)
      place(bottom, dy: y-margin / 2 + y-margin / 8, {
        set text(0.75em, accent)
        //h(1fr) + toolbox.current-section + h(1em) + [§] + h(1em) + toolbox.slide-number
        h(1fr) + toolbox.slide-number
      })
    }
  }
  s(content)
}

#let title-slide(body) = {
  set page(
    fill: bg,
    header: {
      set text(weight: 700, .85em)
      [Universitat de Girona] + h(1fr) + [Arnau K. Deprez]
    },
    footer: {
      set text(weight: 700, .85em)
      [Supervisor: Dr. Adrià Casamitjana] + h(1fr) + [June] + h(2em) + [2026]
    },
  )
  s(body)
}



// ------------------ document ------------------
// Title slide
#title-slide[
  #set align(horizon)
  #place(horizon, {
    set align(left)
    (
      box(
        width: 80%,
        text(
          1.75em,
          weight: 300,
        )[
          A Comparative Study \
          of Deep Learning Architectures \
          for Parkinson's Disease \ Classification \
          from DaTscan

        ],
      )
    )
  })

  #place(
    horizon + right,
    if dark {
      image("assets/figures/preliminary_concepts/HC_example_41.svg", width: 22%)
    },
  )
]

// outline slide
#slide(progress: false, {
  [*Outline*]
  v(1em)


  set enum(
    numbering: n => text(fill: accent, weight: "extrabold")[#n.],
  )
  toolbox.all-sections((sections, current) => {
    enum(..sections)
  })
})

#slide({
  align(center + horizon, {
    figure(
      box(
        grid(
          columns: (1fr, 1fr),
          column-gutter: -3em,
          image("assets/figures/preliminary_concepts/HC_example_41.svg"),
          image("assets/figures/preliminary_concepts/PD_example_33.svg"),
        )
          + v(1em),
      ),
      caption: [Healthy patient (left) next to diagnosed patient (right).],
    )
  })
})
