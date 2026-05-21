#import "../ak_tfg_lib.typ": *
#import "@preview/timeliney:0.4.0": *

#box(width: 90%, [
  #set text(.85em)
  #timeline(
    show-grid: true,
    spacing: 4pt,
    grid-style: (
      stroke: (
        dash: "dotted",
        thickness: 0.5pt,
        paint: luma(66.66%),
      ),
    ),
    milestone-line-style: (stroke: (dash: "dashed")),
    line-style: (stroke: 8pt + luma(64%)),
    {
      headerline(group((smol[March], 2)), group((smol[April],
      2)), group((smol[April], 2)), group((smol[June], 1)))
      // headerline(
      //   smol[March],
      //   smol[April],
      //   smol[May],
      // )

      taskgroup(
        title: [*Classic ML*],
        style: (stroke: 2pt + luma(0)),
        {
          task(
            "PPMI preprocessing",
            //(from: 0, to: 2, content: text(9pt)[John (70% done)]),
            (0.3, 2),
          )
          task(
            "Traditional models",
            (1.5, 4),
          )
          task(
            "Multimodal testing",
            (4, 5.8),
          )
        },
      )

      taskgroup(
        title: [*CNN*], 
        style: (stroke: 2pt + luma(0)), {
        task(
          [custom #lin[2D and 3D]],
          (2, 4),
        )
        task(
          "ResNet and MedNet",
          (4, 5.8),
        )
        task(
          "Multimodal testing",
          (5, 6),
        )
      })

      taskgroup(title: [*Writing*],
        style: (stroke: 2pt + luma(0)), {
        task(
          "Logging",
          (0.3, 6),
        )
        task(
          "Thesis redaction",
          (4, 6.1),
        )
      })

      milestone(
        at: 0.3,
        align(center, [
          *Proposal accepted*\
          3 Mar 
        ]),
      )

      milestone(
        at: 6.1,
        align(center, [
          *Final Deadline*\
          1 June 
        ]),
      )

      // milestone(
      //   at: 3.8,
      //   style: (stroke: (dash: "dashed")),
      //   align(center, [
      //     *Presentation*\
      //     23 June 
      //   ]),
      // )
    },
  )]
)
