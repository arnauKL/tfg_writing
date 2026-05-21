// Arnau K. Deprez: source file of the report document.
#import "assets/ak_tfg_lib.typ": *
#show: ak_tfg.with(
  title: [Deep Learning-Based \ Classification  of Parkinson's \ Disease Stages Using DaTscan],
  shorttitle: [DL Classification of Parkinson's Stages (DaTscan)],
  subsubtitle: [Bachelor's Thesis],
  tutor: "Adrià Casamitjana",
  author: "Arnau K. Deprez Santamaria",
)

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
#include "parts/2_preliminary_concepts.typ"
// #include "parts/3_sota.typ"
//
// = 4 Hypothesis and Objectives
// = 5 Materials and methods
// = 6 Results
// = 7 Discussion
// = 8 Conclusions
#show: appendix
= References
#bibliography("assets/references.bib", title: none)
#include "parts/app_planning.typ"
#include "parts/app_code.typ"
//= Budget
//#include "parts/app_ethics.typ"

// ---------- document ----------

// = 1 Introduction
// = 2 Preliminary Concepts
// = 3 State of the Art
// = 4 Hypothesis and Objectives
// = 5 Materials and methods
// = 6 Results
// = 7 Discussion
// = 8 Conclusions
// ---- appendices ----
// = References
// = A. Planning.typ"
// = B. Code
// = C. Budget
// = D. Ethics comittee (I guess this means ethical considerations)
