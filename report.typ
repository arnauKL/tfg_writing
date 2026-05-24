// Arnau K. Deprez: source file of the report document.
#import "assets/ak_tfg_lib.typ": *
#show: ak_tfg.with(
  title: [Deep Learning-Based \ Classification  of Parkinson's Disease \ from DaTscan Images],
  shorttitle: [DL Classification of Parkinson's Disease (DaTscan)],
  subsubtitle: [Bachelor's Thesis],
  tutor: "Adrià Casamitjana",
  author: "Arnau K. Deprez Santamaria",
)

/*
different title options:
1. Deep Learning-Based Classification of Parkinson's Disease from DaTscan Images
2. Automated DaTscan Classification of Parkinson's Disease: A Comparative Study
   of CNN Architectures and Multimodal Fusion.
3. Convolutional Neural Networks for DaTscan-Based Parkinson's Disease
   Classification with Multimodal Clinical Data
*/

//#include "parts/preface.typ"
#counter(page).update(1) // Reset page num to 1

// ---------- document ----------

#include "parts/1_introduction.typ"
#include "parts/2_preliminary_concepts.typ"
//#include "parts/3_sota.typ"
#include "parts/4_hypothesis_and_objectives.typ"

#bibliography("assets/references.bib", title: [References])

#show: appendix
#include "parts/app_planning.typ"
#include "parts/app_code.typ"
//#include "parts/app_budget.typ"
//#include "parts/app_ethics.typ"
