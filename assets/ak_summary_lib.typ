// This is a modified version of the mousse_notes template
// to suit personal preferences and university requirements.
//
// Visit the original template at: https://github.com/dogeystamp/mousse-notes

// some packages that may become useful later:
// wrap-it (wrap text around figures) -> https://typst.app/universe/package/wrap-it
// supbar (subfigures in typst)       -> https://typst.app/universe/package/subpar
// meander (fancy text wrap)          -> https://typst.app/universe/package/meander

#let INDENT = 1.4em
#let debug = false
//#let debug = true
#let show_red = true


#let appendix(body) = {
  counter(heading).update(0)
  counter(page).update(0)
  set page(numbering: "1")
  {
    show heading: none
    heading(bookmarked: true, depth: 1, numbering: none)[Appendices]
  }
  body
}

// functions to create list of figures and tables
#let lof = {
  text(1.5em, style: "italic")[List of Figures]
  v(1.5%)
  outline(title: none, target: figure.where(kind: image))
}
#let lot = {
  text(1.5em, style: "italic")[List of Tables]
  v(1.5%)
  outline(title: none, target: figure.where(kind: table))
}

#let lin(it) = {
  // lining figures
  if debug {
    text(number-type: "lining", blue, it)
  } else {
    text(number-type: "lining", it)
  }
}
#let oldf(it) = {
  // old-style figures
  if debug {
    text(number-type: "old-style", blue, it)
  } else {
    text(number-type: "old-style", it)
  }
}

#let smol(it) = {
  if debug {
    text(orange, smallcaps(all: true, it))
  } else {
    smallcaps(all: true, it)
  }
}
#let caps(it) = { if debug { text(green, upper(it)) } else { upper(it) } }

#let redt(it) = { if show_red { text(red, it) } }

/// Manual override for indent (see https://github.com/typst/typst/issues/3206)
#let indent = h(INDENT)

#let title-page(
  title: none,
  subtitle: none,
  tutor: none,
  author: none,
) = {
  show smallcaps: set text(spacing: 120%, tracking: 0.08em)
  place(top + center, dy: +5%, { image("UdG_dues_linies_centrat_blau.svg", width: 40%) })
  place(horizon + center, dy: -5%, {
    set par(leading: .5em, justify: false)
    align(
      center,
      text(size: 1.85em, smallcaps(title))
      //text(size: 1.85em, font: "Libertinus Serif Display", title)
        + v(2.5%, weak: true)
        + if subtitle != none {
          text(size: 2em, smallcaps(subtitle))
          v(2.5%, weak: true)
        },
    )
    set text(size: 1.20em)

    v(3.5%, weak: true)
    //subsubtitle + [\ Document: Main Report]
    v(3.5%, weak: true)

    emph([Supervisor]) + h(.5em) + smallcaps[#tutor]
    v(1.25%, weak: true)
    emph([Author]) + h(.5em) + smallcaps[#author]
  })

  align(bottom + center)[
    #smallcaps([
      Polytechnic School \
      Department of Computer Architecture and Technology \
      Bachelor's Degree in Biomedical Engineering \
      June 2026
    ])
  ]
}

#let ak_summ(
  title: none,
  shorttitle: none,
  author: none,
  subtitle: none,
  subsubtitle: none,
  tutor: none,
  epigraph: none,
  debug: false,
  body,
) = {
  let text-font = "Libertinus Serif"

  show smallcaps: set text(spacing: 120%, tracking: 0.04em)
  set text(font: text-font, 11pt, fill: rgb("#141414"))
  set text(number-type: "old-style")

  set par(
    first-line-indent: (amount: INDENT, all: false),
    justify: true,
    spacing: 1em,
    leading: 0.55em + 1pt,
    justification-limits: (
      // allow adjusting spaces to fix justification
      // spacing -> spaces between words
      spacing: (min: 100% * 2 / 3, max: 150%), // defaults
      // spacing -> spaces between chars in a word
      tracking: (min: -0.01em, max: 0.01em), // custom
    ),
  )
  //set enum(indent: INDENT, numbering: "1.")
  set list(indent: .75em, marker: [--], body-indent: .75em)
  set terms(hanging-indent: INDENT)
  set page(paper: "a4")
  show list: set block(breakable: true)

  // --- CODE BLOCKS
  show raw: set block(
    fill: luma(240),
    radius: 4pt,
    //stroke: .5pt + luma(205),
    inset: (left: 2em, right: 2em, top: 1.5em, bottom: 1.5em),
    //above: 1em,
    //below: 1em,
    //width: 80%,
  )
  show raw.where(block: true): set text(size: 0.8em)
  show raw.where(block: true): it => align(center)[#it]
  // inline raw
  show raw: it => h(1pt) + box(it , outset: 1.5pt, fill: luma(240), radius: 3pt)+ h(1pt)

  set document(author: if author != none { author } else { () }, title: shorttitle)

  set bibliography(style: "ieee", title: [References])

  set page(
    margin: (x: 3cm, y: 2.5cm),
    footer: context {
      let page = counter(page).display()
      set text(size: 9pt)
      place(center + horizon, page)
    },
    header: context {
      let page_num = counter(page).get().at(0)
      if page_num == 1 {
        return
      }

      let page = counter(page).display()

      set text(size: 9pt)
    },
  )

  // offset the numbering by one because single star could be ambiguous in math, maybe
  set footnote(numbering: n => numbering("*", n + 1))

  show link: it => {
    if type(it.dest) != str {
      // local link
      it
    } else if (it.body == [#it.dest]) {
      // URL (no custom text)
      set text(rgb("#449"))
      show text: emph
      box(it)
    } else {
      // URL (custom text)
      set text(rgb("#449"))
      show text: emph
      box(it)
    }
  }

  // title-page(
  //   author: author,
  //   title: title,
  //   shorttitle: shorttitle,
  //   subtitle: subtitle,
  //   subsubtitle: subsubtitle,
  //   tutor: tutor,
  //   epigraph: epigraph,
  // )

  // configure outlines
  show outline.entry.where(level: 1): set block(above: 1.75em, breakable: true)
  show outline.entry.where(level: 1): set text(weight: 600)
  show outline.entry.where(level: 2): set block(above: 1em, breakable: true)
  show outline: it => align(center)[#block(width: 80%, [
     #it
  ])]

  // old outline
  // show outline.entry.where(level: 1): set block(above: 1.375em, breakable: true)
  // show outline.entry.where(level: 2): set block(above: .75em, breakable: true)
  show outline.entry: set outline.entry(fill: "")
  show outline.entry.where(level: 1): set outline.entry(fill: repeat(text(.5em)[.], gap: 0.15em))
  show outline.entry: it => link(
    it.element.location(),
    it.indented(lin(it.prefix()), lin(it.inner()))
  )

  // new attempt ? more clean ?
  // show outline.entry: it => link(it.element.location(), {
  //   let pagenum = it.inner().children.at(5)
  //   let pgwidth = measure(pagenum).width
  //   set outline.entry(fill: "")
  //   set text(number-type: "lining")
  //   grid(
  //     box(
  //       if pgwidth < 10pt {
  //         if it.level == 1 { h(measure([*10*]).width - pgwidth) }
  //         else { h(measure([10]).width - pgwidth)}
  //       } +
  //       strong(pagenum) + h(INDENT) +
  //       [$dot$] + h(INDENT) +
  //       if it.prefix() != none { it.prefix() + h(INDENT) } +
  //       {
  //         set text(number-type: "old-style")
  //         if it.level == 1 { text(1.25em, it.element.body) }
  //         else { it.element.body }
  //       }
  //       + h(1fr)
  //     )
  //   )
  // })

  // configure headings

  let heading-func = (body-fmt: strong, use-line: false, it) => {
    block(
      sticky: true,
      (
        //emph(text(size: 0.8em, lin(counter(heading).display())))
        v(1em) +
          body-fmt(it.body)
          + if use-line {
            box(width: 1fr, align(right, line(length: 100% - 0.8em, start: (0%, -0.225em), stroke: (
              paint: black,
              cap: "round",
            ))))
          }
      ),
    )
  }

  show heading.where(level: 2): heading-func.with(body-fmt: emph, use-line: true)
  show heading.where(level: 2): it => {
    set block(above: 1.675em, below: 1em)
    text(size: 1.1em, it)
  }

  show heading.where(level: 3): heading-func
  show heading.where(level: 3): it => {
    set block(above: 0em, below: 0em)
    v(1.25em, weak: true) + it + v(0.75em, weak: true)
  }

  show heading.where(level: 4): heading-func

  set heading(supplement: [Section])
  show heading.where(level: 1): it => {
    set text(weight: "regular", hyphenate: false)
    set par(first-line-indent: 0.0em)
    counter(footnote).update(0)
    counter("moussethm-thmlike").update(0)
    counter("moussethm-example").update(0)
    //counter(figure.where(kind: table)).update(0)
    block(
      inset: (left: -0.2em),
      height: 10%,
      {
        set text(size: 2em)
        (emph(it.body))
      }
        + if it.numbering != none and it.outlined {
          emph[
            #v(0.9em, weak: true)
            //#h(0.125em)#smallcaps[#it.supplement]
            //#counter(heading).display()
          ]
        },
    )
  }
  show enum: it => { v(0.9em, weak: true) + it + v(0.9em, weak: true) }

  // figures
  show figure: it => { v(1.25em, weak: true) + align(center, box(width: 98%, it)) + v(1.25em, weak: true) }
  show figure.caption: it => {
    set text(0.85em)
    smallcaps(it.supplement) + " " + context lin(it.counter.display(it.numbering)) + [: ] + it.body
  }

  body
}
