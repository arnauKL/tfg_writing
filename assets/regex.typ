#let apply-regex-rules(body) = {
  // Handle standard and plural acronyms
  show regex("\\b[A-Z]{2,}s?\\b"): it => {
    let txt = it.text
    if txt.ends-with("s") {
      let base = txt.slice(0, txt.len() - 1)
      smallcaps.with(all: true)(base) + "s"
    } else {
      smallcaps.with(all: true)(txt)
    }
  }

  // Dimensions (aka, 2D, 3D, 2.5D, 3Ds)
  show regex("\\b\\d+(?:\\.\\d+)?[A-Z]+s?\\b"): it => {
    let txt = it.text
    let cluster = txt.clusters()
    let first-letter-idx = cluster.position(c => c.match(regex("[A-Z]")) != none)

    let num = txt.slice(0, first-letter-idx)
    let rest = txt.slice(first-letter-idx)

    if rest.ends-with("s") {
      let letters = rest.slice(0, rest.len() - 1)
      num + smallcaps.with(all: true)(letters) + "s"
    } else {
      num + smallcaps.with(all: true)(rest)
    }
  }

  // Protect math equations
  show math.equation: it => {
    show regex("\\b[A-Z]{2,}s?\\b"): it => math.upright(it.text)
    show regex("\\b\\d+(?:\\.\\d+)?[A-Z]+s?\\b"): it => math.upright(it.text)
    it
  }

  // link
  show link: it => {
    show regex("\\b[A-Z]{2,}s?\\b"): it => smallcaps.with(all:true)(it.text)
    show regex("\\b\\d+(?:\\.\\d+)?[A-Z]+s?\\b"): it => smallcaps.with(all:true)(it.text)
    it
  }

  body
}
