/// Custom table function.
#let tablef(..args) = {
  set table.hline(stroke: 0.5pt)
  set par(justify: false)
  table(
    row-gutter: .35em,
    align: left,
    stroke: (x, y) => {
      if (y == 0) {
        (
          top: 0pt,
          bottom: (thickness: 0.75pt, cap: "round"),
        )
      }
    },
    ..args.named(),
    ..(args.pos() + (table.hline(stroke: 0pt),)),
  )
}

#import "@preview/fontawesome:0.6.1": *

#set page(paper: "presentation-16-9", margin: 0pt)
//#set page(paper: "presentation-4-3", margin: 0pt)
//#set text(font: "Libertinus Serif", size: 20pt)
#set text(font: "Adwaita Sans", size: 20pt)
#show strong: set text(weight: 900)

//#let bg-color = rgb("#fdfcf0")
#let bg-color = rgb("#ffffff")
#let accent-color = rgb("#1a4d4a")
#let text-color = rgb("#2d2d2d")
#let light-text = rgb("#6a6a6a")

#show heading: set text(fill: accent-color)

#let slide(content, background: none) = {
  set page(fill: bg-color)
  pad(x: 80pt, y: 60pt, {
    if background != none {
      //place(center + horizon, image(background, width: 100%, height: 100%, fit: "cover", opacity: 0.15))
    }
    content
  })
}

#set page()

// Slide 1: Title
#slide({
  align(center + horizon, {
    text(size: 32pt, weight: "bold", fill: text-color, [A Comparative Study of Deep Learning
      Architectures for Parkinson’s Disease
      Classification from DaTscan])
    v(20pt)
    text(size: 14pt, "Arnau K. Deprez Santamaria")
    text(size: 14pt, "\nAdvisor: Dr. Adrià Casamitjana Díaz")

    line(length: 400pt, stroke: 1pt + text-color)
    text(size: 12pt, fill: light-text, [Biomedical Engineering Department of Computer Architecture and Technology \
      Bachelor's Degree in Biomedical Engineering \
      June 2026 \
    ])
  })
})

#slide(background: "anatomy_sketch.png", {
  align(center + horizon, {
    text(size: 96pt, [*10 *])
    text(size: 48pt, [*million *])
    v(3em)

    text(size: 96pt, [*\$82*])
    text(size: 48pt, [* billion*])
  })
})

#slide({
  align(center + horizon, {
    box({ image("assets/figures/preliminary_concepts/Nigrostriatalpathway.svg", height: 100%) })
  })
})


#slide(background: "anatomy_sketch.png", {
  align(center + horizon, {
    grid(
      columns: (1fr, 1fr),
      column-gutter: 3em,
      box(
        text(size: 96pt, [*1/2*\ ]) + v(-3em) + text(size: 48pt, [Changed clinical management]),
      ),
      box(
        text(size: 96pt, [*1/3*\ ]) + v(-3em) + text(size: 48pt, [Altered \ final \ diagnosis]),
      ),
    )
  })
})

#slide(background: "anatomy_sketch.png", {
  align(center + horizon, {
    grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 5em,
      box(
        text(size: 96pt, [ \ ]),
      ),
      box(
        text(size: 96pt, [ \ ]),
      ),
      box(
        text(size: 96pt, [ ?\ ]),
      ),
    )
  })
})


#slide(background: "anatomy_sketch.png", {
  align(center + horizon, {
    text(2em, [*Research question* \ ])
    v(1em)

    align(left, text(1.25em, quote[Can end-to-end CNNs operating on the complete DaTscan image volume
      perform better than classical machine learning methods using hand-crafted
      semi-quantitative features? And does incorporating multimodal clinical
      variables offer a significant diagnostic advantage over imaging alone?]))
  })
})

#slide({
  v(2em)
  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 30pt,
    {
      box(inset: 1em, fill: luma(255), radius: 12pt, stroke: 1pt, height: 80%, [
        #set text(size: 24pt)
        #align(center, [*H1*])
        #set text(22pt)
        CNNs operating on the raw image will outperform classical models trained on SBR-derived features
      ])
    },
    {
      box(inset: 1em, fill: luma(255), radius: 12pt, stroke: 1pt, height: 80%, [
        #set text(size: 24pt)
        #align(center, [*H2*])
        #set text(22pt)
        Transfer learning will compensate for the limited dataset size
      ])
    },
    {
      box(inset: 1em, fill: luma(255), radius: 12pt, stroke: 1pt, height: 80%, [
        #set text(size: 24pt)
        #align(center, [*H3*])
        #set text(22pt)
        Multimodal fusion with clinical variables will improve upon imaging alone.
      ])
    },
  )
})



#slide(background: "anatomy_sketch.png", {
  align(center + horizon, {
    text(2em, [*Data: PPMI* \ ])
    v(4em)
    grid(
      columns: (1fr, 1fr),
      gutter: 80pt,
      //image("assets/ppmi-logo.png", width: 85%), image("assets/michaelfoxfoundation.png"),
    )
    v(3em)
  })
})

#slide(background: "anatomy_sketch.png", {
  align(center + horizon, {
    text(2em, [*Datasets* \ ]) + v(2em)
    tablef(
      columns: (auto, 3em, 3em),
      //columns: (auto, auto, auto),
      align: right,
      [Dataset],
      [HC],
      [PD],
      [rawdata],
      [158],
      [618],
      [registered],
      [124],
      [561],
      [tabular],
      [290],
      [1346],
    )
  })
})

#slide(background: "anatomy_sketch.png", {
  align(center + horizon, {
    text(2em, [*MIP* \ ])
    image("assets/figures/methods/multi_axis_mip_rgb_concept.svg")
  })
})


#slide({
  set text(32pt)
  align(center + horizon, grid(
    columns: (1fr, 1fr),
    column-gutter: 3em,
    row-gutter: 3em,
    [ `2d_sum` ], [ `3d_crop`],
    [ `3d_crop_deeper`], [ `25d_resnet`],
    [ `med3d / med3d_encoder`],
  ))
})
