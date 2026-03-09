// ----------------------------------------------------
// --------------- function definitions ---------------
// ----------------------------------------------------
#let license_note = {
    [ #smallcaps[Copyright 2026] Arnau K. Deprez Santamaria]
    grid(
        columns: (auto, 1fr),
        gutter: 1em,
        image("images/by.svg", width: 100pt),
        [
            This work is licensed under the _Creative Commons Attribution 4.0
            International License_. To view a copy of this license, visit #link(
                "http://creativecommons.org/licenses/by/4.0/",
            ).
        ],
    )
}

#let appendix(body) = {
    set heading(numbering: "A", supplement: [Appendix])
    counter(heading).update(0)
    body
}

// ----------------------------------------------------
// --------------------- template ---------------------
// ----------------------------------------------------

#let tfg_template_ak(
    title: [Untitled],
    short_title: [#title],
    author: [],
    tutor: [],
    thx: [],
    abstract: none,
    body,
) = {
    import "@preview/easy-typography:0.1.0": *
    show: easy-typography

    // Metadata
    set document(title: title, author: author)

    set page(
        paper: "a4",
        margin: (x: 3.5cm, y: 3cm),
    )

    set text(
        //font: "Linux Libertine O", // Kinda like Times
        size: 12pt,
        lang: "en",
        fallback: true,
    )


    set heading(numbering: "1.a.i")
    show heading: set text(font: "Inter")
    show heading.where(level: 1): set text(1em)
    // show heading.where(level: 1): it => block[
    //   #counter(heading).display(it.numbering)
    //   #it.body
    // ]

    show smallcaps: set text(tracking: 0.06em)

    set par(
        justify: false,
        leading: 0.65em,
        //first-line-indent: 0pt,
        spacing: 1.15em,
    )


    // Code blocks
    show raw: set text(font: "CaskaydiaCove NF", size: 9pt, weight: "regular")
    show raw: set block(fill: luma(240), inset: 8pt, radius: 4pt)

    // Configure Headings
    show heading: set text(fill: gray.darken(50%))

    // Links
    show link: it => {
        set text(fill: rgb("#b8860b")) // Dark Goldenrod
        it
        h(2pt)
        text(size: 0.7em)[#super()[➚]]
    }

    show ref: set text(rgb("#872050"))

    // GEB-specifics

    // Requirement; "Eq" is optional but recommended
    set math.equation(numbering: "(Eq. 1)", number-align: bottom)

    // Recommended but not required
    set bibliography(style: "vancouver")

    // A requirement but this is not the way
    //set figure(caption: [text(size: .8em)[]])

    // ---------------------- title page ----------------------

    // Inspiration taken from: https://typst.app/universe/package/red-agora

    place(top + left)[
        // Not having a publicly available svg for their
        // logo is something only this uni could do.
        #image("images/EPS.png", width: 50%)
    ]

    place(horizon + center, dy: -1cm)[
        #smallcaps[ Final Year Thesis ]

        #line(stroke: .3pt + gray, length: 60%)
        #box([#text(1.6em, font: "Libertinus Sans")[*#title*]])


        #line(stroke: .3pt + gray, length: 60%)

        #v(2em)

        #box(width: 90%)[
            #grid(
                columns: 2,
                column-gutter: 1fr,
                align(left)[#smallcaps[Author] \ #text(
                        size: 1.1em,
                    )[#author]],
                align(right)[#smallcaps[Tutor] \ #text(
                        size: 1.1em,
                    )[#tutor]],
            )
        ]
    ]

    place(bottom + center)[
        #show: smallcaps
        #set text(tracking: 0.06em)
        Biomedical Engineering \
        Computer Architecture and Technology \
        Academic Year: 2025-2026
    ]

    pagebreak()

    // ----------------- acknowledgements -----------------
    if thx != [] {
        place(horizon + right)[
            #set par(justify: false)
            #text(gray.darken(50%), 1.6em, font: "Libertinus Sans")[
                *Acknowledgements*
            ]

            #thx
        ]
    }
    pagebreak()


    // outline
    // set outline.entry(fill: "")

    align(center)[
        #show outline.entry: it => {
            if it.level == 1 {
                v(0.5em) // Add space before new chapters
                strong(it) // Bold level 1
            } else {
                it
            }
        }
        #box(
            width: 90%,
            outline(),
        )
    ]


    v(1fr)
    place(bottom)[
        #line(stroke: 0.25pt + gray, length: 100%)
        #license_note
    ]
    pagebreak()

    // Add header with pagenum
    set page(
        header: context [
            #text(.70em)[
                #v(-2em)
                #line(stroke: .25pt, length: 100%)
                #v(-.5em)
                #show: smallcaps
                #set text(tracking: 0.06em)
                #short_title
                #h(1fr)
                #counter(page).display("1 of 1", both: true)
            ]
        ],
    )
    counter(page).update(1) // Reset page num to 1

    // ----------------- actual doc -----------------

    set par(justify: true)
    body
}
