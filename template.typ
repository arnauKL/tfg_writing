
// template.typ
// ----------------------------------------------------
// --------------- function definitions ---------------
// ----------------------------------------------------

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
    abstract: none,
    body,
) = {
    // import "@preview/easy-typography:0.1.0": *
    // show: easy-typography

    // Metadata
    set document(title: title, author: author)

    set page(
        paper: "a4",
        margin: (x: 3.5cm, y: 3cm),
    )

    // Font definitions
    set text(
        //font: "Linux Libertine O", // Kinda like Times
        size: 12pt,
        fill: rgb("#1a1a1a"),
        lang: "en",
        fallback: true,
    )

    set heading(numbering: "1.a.i", supplement: [Chapter])
    
    show heading: set text(font: "Linux Libertine Display")
    //show heading.where(level: 1): set text(.85em)
    // show heading.where(level: 1): it => align(right)[
    //       #v(.5em)
    //       #it.body \
    //       #set text(font: "Linux Libertine Text", weight: 100, .825em)
    //       #show text: smallcaps
    //       #it.supplement #counter(heading).display()
    //       #v(.25em)
    // ]

    show heading.where(level: 1): it => {
      //pagebreak(weak: true)
      colbreak(weak: true)
      set text(weight: "regular", hyphenate: false)
      set par(first-line-indent: 0.0em)
      counter(footnote).update(0)
      counter(figure.where(kind: table)).update(0)
      align(right)[
        #block(
        inset: (left: -0.2em),
        height: 15% - 1em,
        {
          set text(size: 1.5em)
          (emph(it.body))
        }
          + if it.outlined {
            emph[
              #v(0.9em, weak: true)
              #h(0.125em)#smallcaps[Chapter] #counter(heading).display()
            ]
          },
      )
      ]
    }

    show smallcaps: set text(tracking: 0.04em)

    set par(
        justify: false,
        leading: 0.65em,
        //first-line-indent: 0pt,
        spacing: 1.15em,
    )

    // Color palette
    let accent-color = rgb("#5B3D8A")

    // Configure outline
    show outline.entry: it => {
        if it.level == 1 {
            v(0.5em) // Add space before new chapters
            strong(it) // Bold level 1
        } else {
            it
        }
    }

    // Code blocks
    show raw: set text(font: "BlexMono Nerd Font", size: 9pt, weight: "regular")
    show raw: set block(
        fill: accent-color.lighten(92%),
        inset: 8pt,
        radius: 4pt,
    )

    // Configure footnotes
    set footnote.entry(separator: line(
        stroke: .4pt + accent-color.darken(0%),
        length: 40%,
    ))

    // Links
    show link: it => {
        set text(fill: accent-color)
        it
        h(2pt)
        text(size: 0.7em)[#super()[➚]]
    }

    // GEB-specifics

    // Requirement; "Eq" is optional but recommended
    set math.equation(numbering: "(Eq. 1)", number-align: bottom)

    // Recommended but not required
    set bibliography(style: "vancouver")

    // A requirement but this is not the way
    //set figure(caption: [text(size: .8em)[]])


    set par(justify: true)
    body
}
