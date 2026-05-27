// Arnau K. Deprez: source file of the report document.
#import "assets/ak_tfg_lib.typ": *
#show: ak_tfg.with(
  title: [Deep Learning-Based \ Classification  of Parkinson's Disease \ from DaTscan Images],
  shorttitle: [DL Classification of Parkinson's Disease (DaTscan)],
  subsubtitle: [Bachelor's Thesis],
  tutor: "Adrià Casamitjana Díaz",
  author: "Arnau K. Deprez Santamaria",
)

#include "parts/preface.typ"
#set page(numbering: "1") // this forces reset on pdf viewers too
#counter(page).update(1) // Reset page num to 1


// ---------- document ----------
#include "parts/1_introduction.typ"
#include "parts/2_preliminary_concepts.typ"
#include "parts/3_sota.typ"
#include "parts/4_hypothesis_and_objectives.typ"
#include "parts/5_materials_and_methods.typ"
#include "parts/6_results.typ"
//#include "parts/7_discussion.typ"
//#include "parts/8_conclusions.typ"

#bibliography("assets/references.bib", title: [References])

#show: appendix
#include "parts/app_planning.typ"
#include "parts/app_code.typ"
#include "parts/app_budget.typ"
#include "parts/app_ethics.typ"
#include "parts/app_colophon.typ"
