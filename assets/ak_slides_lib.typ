#import "@preview/polylux:0.4.0": *
#import "@preview/polylux:0.4.0": slide as s

// Main colors off of GNOME's HIC palette
#let accent = rgb("#c64600")
#let yellow = rgb("#f8e45c")
#let light-grey = rgb("#f6f5f4")
#let medium-grey = rgb("#c0bfbc")
#let dark-grey = rgb("#77767b")
#let grey = rgb("#9a9996")

#let x-margin = 2cm

#let title-slide(
  title: none,
  author: none,
  date: none,
  subtitle: none,
  max-width: 90%,
) = {
  set page(margin: 0%, header: none, footer: none)
  let content = context {
    place(top + left, image(
      "decorations/tool-dissectional-alex-grey-watermarked.jpg",
      width: 100%,
      height: 100%,
      fit: "cover",
    ))
    place(top + left, rect(width: 100%, height: 100%, fill: accent.transparentize(10%)))

    //The White Top Decorative Shape
    place(top + left, curve(
      fill: black,
      curve.move((0%, 0%)),
      curve.line((70%, 0%)),
      curve.line((0%, 30%)),
    ))

    // University Logo (top left)
    place(top + left, dx: 0.6cm, dy: 0.4cm, image("UdG_dues_linies_esq_blanc.svg", width: 5cm))

    // Main Title and Author (Center Left)
    place(left + horizon, dx: 0.6cm, dy: 1.2cm, block(width: max-width, {
      //set text(fill: white)
      set par(justify: false)

      block(width: 90%, height: 4cm)[
        #text(weight: "bold", 1.75em)[
          #title
        ]
      ]
    }))

    // Author
    place(top + right, dx: -0.6cm, dy: +0.6cm, text()[
      Arnau K. Deprez \
      Supervisor:  Adrià Casamitjana Díaz.])

    // Right footer
    place(bottom + right, dx: -0.6cm, dy: -0.6cm, align(right, {
      set text(weight: 600)
      // Date
      [June] + h(2em) + [2026]
    }))
  }
  s(content)
  counter("logical-slide").update(0)
}

/// Base for the rest of the slides
#let slide(
  heading: none,
  show-section: true,
  block-height: none,
  body,
) = {
  // Main-Content of the slide starts here
  let content = {
    // HEADING ON SLIDE
    if heading != none {
      block(
        below: 25pt,
        text(size: 1.2cm, fill: accent)[*#heading*],
      )
      block(
        width: 100%,
        height: if block-height == none { 85% } else { block-height },
        body,
      )
    } else {
      // NO HEADING ON SLIDE
      block(
        width: 100%,
        height: if block-height == none { 100% } else { block-height },
        body,
      )
    }
  }
  //SLIDE
  s(content)
}

#let ak-slides(
  text-lang: "en",
  text-size: 20pt,
  author: [],
  title: [],
  shorttitle: [],
  date: [],
  body,
) = {
  set text(
    font: "Adwaita Sans",
    lang: text-lang,
    size: text-size,
    fill: light-grey,
  )

  set par(
    justify: true,
  )

  // Global styling for bullet lists (Itemize)
  set list(marker: (
    text(size: 29pt, fill: accent)[--]
  ))

  // Global styling for numbered lists (Enumerate)
  set enum(
    numbering: n => text(fill: accent, weight: "extrabold")[#n.], // Level 1: 1.
  )

  // Global font and default text color for all code
  show raw: set text(font: "Iosevka NFM", fill: grey)

  // Color links
  show link: it => {
    if type(it.dest) == str {
      // Styling for external URL links
      set text(yellow)
      show link: underline
      it
    } else {
      // Internal links
      set text(grey)
      it
    }
  }

  // Footnote Size
  show footnote.entry: set text(size: .75em)

  set page(
    margin: (top: 20%, bottom: 10%, left: x-margin, right: x-margin),
    fill: black,
    header-ascent: 2%,
    paper: "presentation-16-9",
    header: context {
      // Left
      place(top + left, dy: 1cm, dx: 0.6cm - x-margin, align(center, {
        //image("UdG_reduit_blanc.svg", width: 2cm)
      }))

      // Right
      //place(horizon + right, dx: x-margin - 0.6cm, align(center, { }))
    },

    footer: context {
      set text(
        size: 0.8em,
        fill: grey,
      )
      let current-array = counter("logical-slide").get()
      let total-array = counter("logical-slide").final()

      // Pull integer out
      let current = if current-array.len() > 0 { current-array.first() } else { 1 }
      let total = if total-array.len() > 0 { total-array.first() } else { 1 }

      // Calculate the progress ratio
      let ratio = if total == 0 { 0 } else { current / total }
      let ratio_plus_1 = if total == 0 { 0 } else if current == total { 1 } else { (current + 1) / total }

      // Progress Overlay
      place(bottom, dy: -1pt, dx: -x-margin, line(
        stroke: 2pt + gradient.linear((accent, 0%), (accent, ratio * 100%), (black, ratio * 100%), (black, 100%)),
        length: (100% + 2 * x-margin),
      ))

      // Right (Slide Numbers)
      place(bottom + right, dy: -0.4cm, dx: x-margin - 0.6cm, align(center, {
        text(fill: dark-grey)[#current / #total]
      }))
    },
  )
  show heading: set text(size: 1.2cm, fill: accent)
  show heading: set block(above: 25pt, below: 25pt)

  title-slide(author: author, title: title)

  body
}


/// Slide to show an outline
#let outline-slide(heading: none) = {}
