// Revision done

#import "../assets/ak_tfg_lib.typ": *

// Outline
#heading(numbering: none, outlined: false)[Contents]
#v(-3em)
#outline(title: none, depth: 3)

#v(1fr)

// Copyright note
#smallcaps[Copyright 2026 Arnau K. Deprez Santamaria]
#grid(
  columns: (auto, 1fr),
  align: horizon,
  gutter: .75em,
  image("../assets/by.svg", height: 30pt),
  text(hyphenate: false, [
    This work is licensed under the _Creative Commons Attribution 4.0
    International License_. To view a copy of this license, visit #link("http://creativecommons.org/licenses/by/4.0/").
  ])
)

// Acknowledgements
#pagebreak(weak: true)
#page()[
  #heading(numbering: none, outlined: false)[Acknowledgements]
  First and foremost, I would like to express my deepest gratitude to my
  tutor, Dr. Adrià Casamitjana, for his invaluable guidance and patience
  throughout the development of this thesis, as well as to Dr. Xavier Lladó
  and Dr. Arnau Oliver for putting me in contact with him and introducing me
  to the field of medical imaging. I am also grateful to the staff at VICOROB
  for providing the academic foundation and computational resources that made
  this thesis possible.

  I would also like to express my gratitude to Dr. Miquel Feixes and Dr.
  Màrius Vila. As my professors for MTP, they inspired me with their passion
  for teaching, which is the reason I first developed a liking for coding.

  I would also like to extend my gratitude to the members of the evaluation
  committee for taking the time to review this work.

  I owe a special debt of gratitude to my friends, with whom I’ve had the
  privilege of suffering during these years.

  Finally, I want to thank my mom; I still aspire to be like her when I grow
  up.

  
  #v(1fr)
  #line(length: 100%, stroke: (paint: black,
  cap: "round", thickness: .75pt))

  // This is a requirement, PPMI mandates that this block is in the
  // acknowledgements
  #text(9pt, [
    Data used in the preparation of this work were obtained from the
    Parkinson’s Progression Markers Initiative (#smol[PPMI]) database
    (#link("www.ppmi-info.org/data")). For up-to-date information on the study,
    visit #link("www.ppmi-info.org"). #smol[PPMI] --- a public-private
    partnership --- is funded by the Michael J. Fox Foundation for Parkinson’s
    Research and funding partners, to see the full names of all of the
    #smol[PPMI] funding partners found at
    #link("www.ppmi-info.org/fundingpartners").
  ])
]
