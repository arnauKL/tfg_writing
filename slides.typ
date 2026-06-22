/*
 * slides prepared to defend the thesis on June 23
 * Author: Arnau K.
 *
 * References:
 * https://polylux.dev/book/
 * https://github.com/Woelkchen/uni-ms-pres-schloss
 */
#import "@preview/polylux:0.4.0": *
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-venn:0.2.0"
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
//#set text(size: 20pt, font: "DejaVu Sans")
#show math.equation: set text(font: "Noto Sans Math", number-type: "lining")

#set list(marker: [--])


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

#set strong(delta: 900)
#show strong: set text(tracking: .03em)

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
  advance: true,
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


#let section-slide(section) = {
  toolbox.register-section(section)
  let content = {
    set text(3em, weight: 900, tracking: 0.02em)
    place(center + horizon, {
      section
    })
  }
  s(content)
}

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
          bottom: (thickness: 0.75pt, cap: "round", paint: light-grey),
        )
      }
    },
    ..args.named(),
    ..(args.pos() + (table.hline(stroke: 0pt),)),
  )
}

#let tablec(..args) = {
  set table.hline(stroke: 0.5pt)
  set par(justify: false)
  table(
    row-gutter: .35em,
    align: (x, y) => { if (y != 0 and x == 0) { left } else { center } },
    stroke: (x, y) => {
      if (y == 0) {
        (
          top: 0pt,
          bottom: (thickness: 0.75pt, cap: "round", paint: light-grey),
        )
      }
    },
    ..args.named(),
    ..(args.pos() + (table.hline(stroke: 0pt),)),
  )
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

#section-slide([Introduction])

#slide({
  set align(center + horizon)
  v(3em)
  grid(
    columns: (1fr, 1fr),
    row-gutter: 3em,
    text(6em, [*10M*]), text(6em, [*\$82B*]),
    text(1.2em, [people living\ with Parkinson's]), text(1.2em, [U.S. Economic \ Burden 2024]),
  )
})

#slide({
  //place(top + left, [Timeline])
  set align(center + horizon)
  //line(stroke: (paint: white, thickness: 3pt, cap: "round"), length: 80%)

  set text(1.25em)
  canvas(length: 1cm, {
    import draw: *

    // ---- scale: map year -> x position ----
    let scale = 0.65 // cm per year
    let x(year) = year * scale

    // ---- line sections ----
    line((x(-22), 0), (x(0), 0), fill: accent, stroke: accent + 2pt)
    line((x(-0), 0), (x(12), 0), stroke: grey + 2pt, mark: (end: ">", fill: accent))

    // ---- data points ----
    let points = (
      (
        year: -10,
        label: "Disease begins",
        detail: "Neurodegeneration starts\n",
      ),
      (
        year: 0,
        label: "Diagnosis",
        detail: [motor symptoms appear,\ \~50% of dopaminergic \ neurons have degenerated],
      ),
    )

    for p in points {
      let px = x(p.year * 2)

      // tick + dot
      line((px, -0.1), (px, 0.1), stroke: grey + 1pt)
      circle((px, 0), radius: 0.09, fill: accent, stroke: none)

      // year label right under the axis
      content((px, -0.8), text(size: .75em, fill: grey, weight: "bold")[#p.year])

      line((px, 0.1), (px, 1.5), stroke: grey + 0.5pt)
      content((px, 1.75), anchor: "south", text(weight: "bold")[#p.label])
      content((px, 2.75), anchor: "south", text(.85em)[#p.detail])
    }

    // ---- phase brace labels ----
    content((x(-10), .5), text(.75em, fill: grey.darken(10%), style: "italic")[
      \~10 years, often undiagnosed @gaenslenPatients2011
    ])
    content((x(7), .5), text(.75em, fill: grey.darken(10%), style: "italic")[
      Diagnosed phase
    ])
  })
})


#slide({
  set align(center + horizon)
  import cetz.draw: *
  cetz.canvas(x: 5, y: 5, {
    cetz-venn.venn2(
      name: "venn",
      padding: 50em,
      stroke: light-grey,
      fill: bg,
      a-fill: accent.transparentize(50%),
    )
    content("venn.a", text(1.5em)[*PD*])
    content("venn.ab", [
      #set align(center)
      #set text(.75em)
      Tremor \ Bradykinesia \ Rigidity

    ])
    content("venn.b", text(1em)[
      *Drug-induced \ parkinsonism, \
      essential \ tremor*
    ])
  })
})

#slide({
  set align(center + horizon)
  [
    #text(3em)[*DaTscan*]

    #v(1em)

    #super[123]I-ioflupane radiotracer
  ]
})

#slide({
  align(center + horizon, box(
    inset: 1em,
    grid(
      columns: (1fr, 1fr),
      image("assets/figures/preliminary_concepts/HC_example_41.svg"),
      image("assets/figures/preliminary_concepts/PD_example_33.svg"),
    )
      + v(1em)
      + [Healthy patient (left) next to diagnosed patient (right).],
  ))
})

#slide({
  text(1.5em, [DaTscan impact @isaacsonImpact2021])
  set align(center + horizon)
  grid(
    columns: (1fr, 1fr),
    row-gutter: 3em,
    text(6em, [*50%*]), text(6em, [*33%*]),
    [change in clinical \ management], [alteration of \ final diagnosis],
  )
})

#slide({
  align(
    center,
    text(1em, [Subjective interpretation])
      + v(.25em)
      + box(
        height: 85%,
        grid(
          columns: (1fr,) * 3,
          row-gutter: 2em,
          image("assets/quiz/quiz1_class0.png", height: 80%),
          image("assets/quiz/quiz2_class1.png", height: 80%),
          image("assets/quiz/quiz3_class0.png", height: 80%),

          uncover("2-")[Healthy], uncover("2-")[Diagnosed], uncover("2-")[Healthy],
        ),
      ),
  )
})

#slide({
  place(left, [= SBR, a partial fix])
  set align(center + horizon)
  [
    #grid(
      columns: (1fr, 2em, 1fr),
      row-gutter: -1em,
      if dark { image("assets/slides/multi_axis_mip_rgb_dark_mode2.svg") } else {
        image("assets/slides/multi_axis_mip_rgb_light_mode.svg")
      },
      text(1.5em)[$-->$],
      [
        #set text(1.25em)
        #tablec(
          columns: 3,
          [],
          [Left],
          [Right],
          [Putamen],
          [2.6],
          [2.9],
          [Caudate],
          [3.3],
          [3.1],
        )
      ],

      [Full DaTscan 3D volume], [], [Striatal Binding Ratio (SBR)],
    )
  ]
  place(
    dy: y-margin / 2,
    bottom + center,
    text(
      .75em,
    )[commercial tools (DaTQUANT) are proprietary -> not reproducible for research.],
  )
})

#slide({
  set text(weight: 250, 1.125em)
  [= Research Question]
  place(center + horizon, box(width: 75%, align(left)[
    "*Can* end-to-end #strong[CNN]s operating on the complete DaTscan image volume *perform
    better* than classical machine learning methods using hand-crafted
    semi-quantitative features? And does incorporating *multimodal* clinical
    variables *offer* a significant diagnostic *advantage* over imaging alone?"
  ]))
})


#slide({
  [= Hypotheses]
  v(1em)
  grid(
    columns: (1fr,) * 3,
    column-gutter: 1em,
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*H1*] #strong[CNN]s operating on the raw image will *outperform* classical models trained on SBR-derived features.],
    ),
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*H2*] *Transfer learning* will compensate for the limited dataset size.],
    ),
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*H3*] *Multimodal* fusion with clinical variables *will improve* upon imaging alone.],
    ),
  )
})


#section-slide([Materials and Methods])

#slide({
  [= Dataset: PPMI]
  set align(center + horizon)
  grid(
    columns: (1fr,) * 2,
    column-gutter: 3em,
    if dark { image("assets/slides/Logo-PPMI-dark.png", width: 80%) } else {
      image("assets/slides/Logo-PPMI.png", width: 80%)
    },
    {
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
      v(1em)
      [Distribution of patients in selected datasets.]
    },
  )
})

#slide({
  [= Preprocessing pipeline]
  align(center + horizon, box({
    set align(left)
    [
      #set text(1.5em)
      rawdata -> native acquisition space \
      registered -> VICOROB in-house pipeline @casamitjanadiazAnatomicallyaware2024
    ]
  }))
})

#slide({
  [= Preprocessing pipeline]
  align(center + horizon, box({
    set text(1.5em)
    [
      Normalization \
      $arrow.b.double$ \
      Center cropping ROI: 76 $times$ 76 $times$ 76 \
      $arrow.b.double$
    ]
  }))
})

#slide({
  [= Preprocessing pipeline: 2.5D MIP]
  set align(center + horizon)
  image("assets/slides/mip_google_modified_dark.png", height: 80%)
})

#slide({
  [= Preprocessing pipeline: 2.5D MIP]
  set align(center + horizon)
  image("assets/slides/mip.svg", width: 100%)
})













#slide({
  [= Classical ML baseline]
  set align(center + horizon)
  grid(
    columns: (1fr, 1.4fr),
    column-gutter: 2em,
    [
      #set text(1.1em)
      #set align(left)
      *4 classifiers* \
      SVM (RBF) \
      Random Forest \
      Gradient Boosting \
      Logistic Regression
    ],
    [
      #set text(1em)
      #set align(left)
      Additive feature sets, mirroring the clinical workflow: \
      #v(.5em)
      Raw SBR \
      $arrow.b$ + full SBR panel \
      $arrow.b$ + engineered features \
      $arrow.b$ + demographics \
      $arrow.b$ + motor (UPDRS) \
      $arrow.b$ + olfactory (UPSIT) \
      $arrow.b$ + secondary biomarkers
    ],
  )
})

#slide({
  [= Five CNN architectures]
  set align(center + horizon)
  tablef(
    columns: (auto, auto, auto),
    column-gutter: 1em,
    [Architecture],
    [Dimensionality],
    [Pretraining],
    [2d_sum],
    [2D (slice sum)],
    [None],
    [3d_crop],
    [3D],
    [None],
    [3d_crop_deeper],
    [3D (+1 block)],
    [None],
    [25d_resnet],
    [2.5D (MIP)],
    [ImageNet],
    [med3d / med3d_encoder],
    [3D],
    [MedicalNet],
  )
})


#slide({
  [= Fusion strategies]
  v(1em)
  grid(
    columns: (1fr,) * 2,
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*Late fusion*] Averages the probability outputs of an independently trained CNN and a tabular logistic regression. No retraining, no added parameters.],
    ),
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*Feature-level fusion*] Y-shaped: frozen CNN embedding (512-d) + tabular MLP embedding (16-d), concatenated into a shared classification head.],
    ),
  )
})



#let viz-placeholder(name, height: 10em) = box(
  width: 100%,
  height: height,
  radius: .5em,
  stroke: (paint: grey, dash: "dashed"),
  align(center + horizon)[
    #set text(.8em, fill: grey, style: "italic")
    #name
  ],
)

#section-slide([Results])

#slide({
  [= Classical ML results]
  set align(center + horizon)
  grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    viz-placeholder([classical_ml_5fold_boxplot]),
    [
      #set text(.9em)
      #set align(left)
      *SVM (RBF), imaging-only* \
      Median AUC: *0.991* \
      Mean Acc / F1: *0.962*

      v(1em)

      Manual balancing $>$ sample weighting \
      (weighting biased toward majority class)

      v(.5em)

      Engineered ratios (Putamen/Caudate, \
      Asymmetry Index) $>$ raw SBR
    ],
  )
})

#slide({
  [= CNNs: raw outperforms registered]
  set align(center + horizon)
  viz-placeholder([cnn_raw_vs_registered_boxplot], height: 14em)
  v(.5em)
  text(
    .85em,
  )[Across all five architectures, raw unregistered volumes \ outperformed spatially registered ones -- consistently.]
})

#slide({
  [= CNN performance summary (raw, 5-fold)]
  set align(center + horizon)
  tablef(
    columns: (auto, auto, auto),
    [Architecture],
    [AUC],
    [F1],
    [3d_crop_deeper],
    [0.991 ± 0.015],
    [0.951],
    [25d_resnet],
    [0.979 ± 0.021],
    [0.943],
    [med3d_encoder, med3d, \ 2d_sum, 3d_crop],
    [0.944 -- 0.954],
    [--],
  )
})

#slide({
  [= Grad-CAM: 25d_resnet]
  set align(center + horizon)
  viz-placeholder([gradcam_25dresnet_pd_vs_hc_cohort_avg], height: 12em)
  v(.5em)
  text(.85em)[Cohort-averaged attention: focal at the striatum for PD, \ diffuse and broad for HC.]
})

#slide({
  [= Grad-CAM: 3D architectures]
  set align(center + horizon)
  viz-placeholder([gradcam_3d_architectures_grid], height: 12em)
  v(.5em)
  text(
    .85em,
  )[No anatomical grounding: edge artifacts (3d_crop), \ diffuse "pancake" activations (3d_crop_deeper), \ off-target ring activation (med3d_encoder).]
})

#slide({
  set align(center + horizon)
  [
    #text(1.5em)[2nd in raw AUC.]
    #v(.5em)
    #text(2em, fill: accent)[*1st in clinical trustworthiness.*]
    #v(1em)
    #text(1em)[25d_resnet becomes the backbone for all fusion experiments.]
  ]
})

#slide({
  [= Multimodal classical ML]
  set align(center + horizon)
  viz-placeholder([additive_feature_sets_auc_table5], height: 8em)
  v(.5em)
  grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #set text(.85em)
      #set align(left)
      *Motor (UPDRS)*: AUC 0.985 $arrow$ 0.998 \
      $arrow.r$ largest jump, but circular -- \
      UPDRS is part of the diagnostic criteria.
    ],
    [
      #set text(.85em)
      #set align(left)
      *Olfactory (UPSIT)*: genuinely complementary \
      3rd-highest SHAP rank, behind only \
      UPDRS and Putamen/Caudate Ratio.
    ],
  )
})

#slide({
  [= Multimodal CNN fusion]
  set align(center + horizon)
  viz-placeholder([fusion_late_vs_featurelevel_boxplot], height: 12em)
  v(.5em)
  text(
    .85em,
  )[Motor-only late fusion: median AUC *0.999*, narrowest IQR. \ Late fusion $gt.eq$ feature-level fusion throughout (n = 306).]
})

#slide({
  [= SWEDD: a specificity test]
  set align(center + horizon)
  viz-placeholder([swedd_predicted_probability_violin], height: 11em)
  v(.5em)
  grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #set text(.85em)
      *Image-only model* \
      mean $P$(PD) = 0.113, median 0.004 \
      vs. 0.954 for confirmed PD \
      (Mann–Whitney $p = 0.077$ vs. HC)
    ],
    [
      #set text(.85em)
      *+ Multimodal (UPDRS)* \
      median $P$(PD) shifts to 0.450 \
      30.4% classified as PD
    ],
  )
})

#section-slide([Conclusions])

#slide({
  [= Revisiting the hypotheses]
  v(1em)
  grid(
    columns: (1fr,) * 3,
    column-gutter: 1em,
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: (paint: grey, dash: "dashed"),
      [#align(center)[*H1*] #strong[CNN]s operating on the raw image will *outperform* classical models trained on SBR-derived features.],
    ),
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*H2*] *Transfer learning* will compensate for the limited dataset size.],
    ),
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*H3*] *Multimodal* fusion with clinical variables *will improve* upon imaging alone.],
    ),
  )
})

#slide({
  [= Revisiting the hypotheses]
  v(1em)
  grid(
    columns: (1fr,) * 3,
    column-gutter: 1em,
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      fill: red.transparentize(65%),
      stroke: light-grey,
      [#align(center)[*H1* _Partially refuted_] CNNs *do not exceed* the SVM baseline in raw AUC, but operate without hand-crafted features.],
    ),
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: (paint: grey, dash: "dashed"),
      [#align(center)[*H2*] *Transfer learning* will compensate for the limited dataset size.],
    ),
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*H3*] *Multimodal* fusion with clinical variables *will improve* upon imaging alone.],
    ),
  )
})

#slide({
  [= Revisiting the hypotheses]
  v(1em)
  grid(
    columns: (1fr,) * 3,
    column-gutter: 1em,
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      fill: red.transparentize(65%),
      stroke: light-grey,
      [#align(center)[*H1* _Partially refuted_] CNNs *do not exceed* the SVM baseline in raw AUC, but operate without hand-crafted features.],
    ),
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      fill: yellow.transparentize(65%),
      [#align(center)[*H2* _Mixed_] Supported *for ImageNet, not for MedicalNet*. Domain mismatch between imaging modalities.],
    ),
    box(
      inset: 1.5em,
      radius: 10pt,
      height: 80%,
      stroke: (paint: grey, dash: "dashed"),
      [#align(center)[*H3*] *Multimodal* fusion with clinical variables *will improve* upon imaging alone.],
    ),
  )
})

#slide({
  [= Revisiting the hypotheses]
  v(1em)
  grid(
    columns: (1fr,) * 3,
    column-gutter: 1em,
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      fill: red.transparentize(65%),
      stroke: light-grey,
      [#align(center)[*H1* _Partially refuted_] CNNs *do not exceed* the SVM baseline in raw AUC, but operate without hand-crafted features.],
    ),
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      fill: yellow.transparentize(65%),
      [#align(center)[*H2* _Mixed_] Supported *for ImageNet, not for MedicalNet*. Domain mismatch between imaging modalities.],
    ),
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      fill: green.transparentize(65%),
      [#align(center)[*H3* _Supported, with caveat_] Largest gain (motor) reflects label circularity; olfactory gain is genuine.],
    ),
  )
})

#slide({
  set align(center + horizon)
  [
    #text(1.75em)[*AUC alone is an insufficient \ evaluation criterion for clinical AI.*]
    #v(1em)
    #text(
      .9em,
      fill: grey,
    )[Highest AUC (3d_crop_deeper) $arrow.r$ no anatomical grounding. \ Slightly lower AUC (25d_resnet) $arrow.r$ attends to the striatum, passes the SWEDD test.]
  ]
})

#slide({
  [= Limitations]
  v(1em)
  set text(.95em)
  list(
    [Binary manifest PD vs. HC only -- the clinically least ambiguous task],
    [No external validation on independent cohorts / scanners],
    [Grad-CAM is indicative, not definitive],
  )
})

#slide({
  [= Future work]
  v(1em)
  grid(
    columns: (1fr,) * 3,
    column-gutter: 1em,
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*Short term*] Re-run on an updated PPMI extract including prodromal DaTscan data.],
    ),
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*Medium term*] Grad-CAM consistency loss. Penalize attention outside an anatomical striatal mask.],
    ),
    box(
      inset: 1.5em,
      radius: .5em,
      height: 80%,
      stroke: light-grey,
      [#align(center)[*Ambitious*] MRI $arrow.r$ DaTscan synthesis on healthy subjects; deviation = subject-specific abnormality score.],
    ),
  )
})

#slide({
  [= Summary]
  v(1em)
  set text(.95em)
  list(
    [Classical SBR baseline is already near-ceiling for manifest PD vs. HC],
    [25d_resnet: the only model combining competitive performance with anatomically grounded decisions],
    [Raw, unregistered images consistently outperform registered ones],
    [Multimodal fusion improves performance -- olfactory genuinely, motor circularly],
    [SWEDD inference validates the dopaminergic signal, not a cohort artifact],
  )
})

#slide(progress: false, {
  set align(center + horizon)
  text(2em)[*Thank you.*]
  v(.5em)
  text(1.2em, fill: grey)[Questions?]
})



#slide({
  [= References]
  set text(14pt)
  bibliography("assets/references.bib", title: none)
})
