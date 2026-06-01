- [x] Finish revision of the SOTA section
- [x] Finish the "6_results" section in full 
- [x] Add the "7_discussion" section
- [x] Add the "8_conclusion" section
- [x] Fill in appendixes:
    - [x] Code
    - [ ] Planification
    - [x] Budget
    - [x] Ethics committee


# x n Adrià

- No he posat ilustracions de corbes ROC ni del procés d'entrenament de les
  xarxes. No n'hi ha gaire de molt rellevant però en puc posar alguna a
  l'apartat de resultats extesos.
- He deixat fora el H&M
- He fet scatterplot x mostrar Grad-CAM 3d amb thresh prou alt, ns si perd massa
  detall o si serveix
- sec.6: La única xarxa que mostrava atenció a on hi havia zones rellevants ha
  sigut la ImageNet 2.5D experiment.
  - He posat moltes figures mostrant ouputs de Grad-CAM x mostrar-ho
- sec.7: Per justificar-ho, he comentat que és possible que hi hagi massa
  poques imatges.
  - he comentat també el registrat vs no-registrat mostrant la foto FIG 3 si no
    vaig malament.
- sec.8: A l'apartat de conclusions he afegit
    - un paràgraf comentat proposta (prodromals) vs resultat final
    - un paràgraf de futur proxim, mig i llunyà, posat s model de MRI -> DaTscan


- Redactant m'he adonat que al fer els models classics no vaig mirar de quina
  sessió era cada pacient, segurament hi ha bias.
- El multimodal que més m'aporta és el motor, que realment no aporta res xq és
  redundant.




Reescreiure

Amb el PPMI vist el GradCAMM potser està mirant característiques no rellevants,
cosa q potser compromet a al generalitzacció a altres sets de dades.

Mirar si puc reentrenar x treure temporals i/o reconeixer q no

Comentar com a lmitació


Figura 7 , explicar d on surt el f1 tan alt/estret
Cnaviar i fer q miri macro tb.
