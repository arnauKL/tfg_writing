#import "@preview/timeliney:0.4.0"

#set page(
    height: auto,
    margin: 1em,
    // fill: luma(240),
)

#set text(size: 12pt) // Has to be same as in main doc

#timeliney.timeline(
    show-grid: true,
    {
        import timeliney: *

        headerline(group(([*2026*], 5)))
        headerline(
            [February],
            [March],
            [April],
            [May],
            [June],
        )

        taskgroup(
            title: [*Research*],
            content: text(10pt, white)[*John + Julia*],
            style: (stroke: 14pt + black),
            {
                task(
                    "Research the market",
                    (from: 0, to: 2, content: text(9pt)[John (70% done)]),
                    style: (stroke: 13pt + gray),
                )
                task(
                    "Conduct user surveys",
                    (from: 1, to: 3, content: text(9pt)[Julia (50% done)]),
                    style: (stroke: 13pt + gray),
                )
            },
        )

        taskgroup(title: [*Development*], {
            task("Create mock-ups", (2, 3), style: (stroke: 2pt + gray))
            task("Develop application", (3, 3.1), style: (stroke: 2pt + gray))
            task("QA", (3.5, 4.1), style: (stroke: 2pt + gray))
        })

        taskgroup(title: [*Report*], {
            task("Template creation", (1, 1.4), style: (stroke: 2pt + gray))
            task("Writing", (1, 4.1), style: (
                stroke: 2pt + gray,
            ))
        })

        milestone(
            at: .25,
            style: (stroke: (dash: "dashed")),
            align(center, [
                *Start of Q2*\
            ]),
        )

        milestone(
            at: 1.15,
            style: (stroke: (dash: "dashed")),
            align(center, [
                *Proposal accepted*\
                3 Mar 2026
            ]),
        )

        milestone(
            at: 4.1,
            style: (stroke: (dash: "dashed")),
            align(center, [
                *Final Deadline*\
                June 2026
            ]),
        )
    },
)
