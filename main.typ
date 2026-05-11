// Arnau K. Deprez: source file of the report document.
#import "ak_tfg_lib.typ": *
#show: ak_tfg.with(
  title: [Deep Learning-Based \ Classification  of Parkinson's \ Disease Stages Using DaTscan],
  shorttitle: [DL Classification of Parkinson's Stages (DaTscan)],
  subsubtitle: [Bachelor's Thesis],
  tutor: "Adrià Casamitjana",
  author: "Arnau K. Deprez Santamaria",
)

// regex to catch some acronyms
#show regex("\b2D\b"): smol[2d]
#show regex("\b2.5D\b"): smol[2.5d]
#show regex("\b3D\b"): smol[3d]
#show regex("\bPD\b"): smol[pd]
#show regex("\bCNN\b"): smol[cnn]
#show regex("\bCNNs\b"): [#smol[cnn]s]
#show regex("\bML\b"): smol[ml]
#show regex("\bPPMI\b"): smol[ppmi]
#show regex("\bSPECT\b"): smol[spect]
#show regex("\bDAT\b"): smol[dat]

#include "parts/preface.typ"
#counter(page).update(1) // Reset page num to 1

// ---------- Content specified in the GEB guides ----------

// 1. Introducció
// 2. Conceptes previs
// 3. Estat de l’art
// 4. Hipòtesis i objectius
// 5. Materials i mètodes
// 6. Resultats
// 7. Discussió
// 8. Conclusions
// Referències.
// Annex A. Planificació
// Annex B. Codi
// Annex C. Pressupost
// Annex D. Comitè d’Ètica

// See `notes.md` for a file wit more in-depth
// explanations and contents


// ---------- document ----------

#include "parts/1_introduction.typ"
#include "parts/3_sota.typ"

// = Hypothesis and Objectives
// = Materials and methods
// = Results
// = Discussion
// = Conclusions
= References (unnumbered section)
#bibliography("assets/zotero_library.bib", title: [References])

#show: appendix
// = Planning
//
// Work on the thesis can be viewed in @gantt.
// The proposal was sent in late january and accepted in early march. Work on
// training the CNNs started on march and endured until the end of april.
// Multimodal integration was worked on in early may.
//
// Writing of this thesis was started in may based on log notes kept during the
// semester, while the template itself was finalised around april (see
// @colophon).
//
// #figure(
//   include "assets/figures/gantt.typ",
//   caption: [Gantt diagram showing the evolution of this thesis.],
// )<gantt>

//= Budget

= Code

This project has been version controlled since I started it and its hosted on GitHub. It can be found at #link("https://github.com/arnauKL/codi_tfg")[`arnauKL/tfg`].
It's hosted under a #smol[bsd] license.

#heading(bookmarked: false, depth: 2)[Colophon]<colophon>

This thesis was typeset in #link("https://typst.app")[Typst] using a custom template
based on
#link("https://typst.app/universe/package/mousse-notes")[mousse-notes].
The body text is set in #link("https://www.linuxlibertine.org/")[Libertinus
  Serif] and code listings in
#link("https://github.com/IBM/plex")[IBM Plex Mono]. All tools used in its production are free and open-source software.


= Ethics committee

== PPMI dataset

I was granted access to the PPMI dataset at the start of the thesis.
