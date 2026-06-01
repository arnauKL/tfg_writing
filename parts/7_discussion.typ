#import "../assets/ak_tfg_lib.typ": *

/*
En aquest capítol s’explicaran els resultats obtinguts respecte als objectius del projecte 
(beneficis).  
 
Caldrà incloure dues seccions:  

- Limitacions: es descriuran les limitacions dels resultats obtinguts, com ara per 
exemple, la generalitat dels resultats respecte a l’abast de l’experimentació 
(i.e. s’han fet proves amb persones sanes, i no es poden extrapolar els 
resultats a tota la població).   
 
- Contribucions als objectius de desenvolupament sostenible (ODS) de les 
Nacions Unides: identificació d’almenys un ODS i com el TFG està contribuint-
hi.

Contibutions to SDG
#link("https://www.un.org/sustainabledevelopment/", "SDG")
3 and 9
*/


= Discussion

The experiments reported in this thesis pursued three questions: whether CNNs
operating on the full DaTscan volume outperform classical models trained on
semi-quantitative features; whether transfer learning compensates for the
limited dataset size; and whether multimodal fusion with clinical variables adds
diagnostic value. Read in isolation, the quantitative results support all three
hypotheses. Read alongside the interpretability analysis, a more nuanced picture
emerges: most of the CNN gain in raw AUC is not driven by the diagnostically
relevant signal, and the largest apparent multimodal improvement raises a
circularity concern. This section discusses each finding in turn.

== Classical machine learning baseline

The SVM with a non-linear RBF kernel achieved a remarkably strong performance on
DaTscan semi-quantitative features alone, reaching a median AUC of $0.998$ on
the engineered feature set. This result is consistent with prior work showing
that SBRs are already near-perfectly discriminative for manifest PD against HC in
cohorts like PPMI, where diagnoses are expert-confirmed and imaging quality is
controlled @palermoDopamine2021. The practical implication is that the binary
classification task as formulated here is not especially difficult for a
well-tuned classical model given clean semi-quantitative inputs.

Feature engineering consistently outperformed raw SBR values across all
classifiers. The Putamen-to-Caudate Ratio and asymmetry indices, which encode
the direction and lateralization of dopaminergic loss rather than its absolute
magnitude, proved particularly discriminative. This aligns with the known
pathophysiology of PD, in which putaminal degeneration precedes and exceeds
caudate involvement, making the ratio a more specific indicator of nigrostriatal
damage than either region's absolute binding value alone
@tinazSemiquantitative2018.

The finding that demographic variables (age, sex) added no measurable information
over the imaging baseline is noteworthy: despite their variability across the
PPMI cohort, they do not reduce classification error, suggesting that the DaTscan
signal alone is sufficient to separate the two groups at this disease stage and
that demographic confounders are not introducing systematic bias. /* which could
probably be more of an issue if j'd use MRI too */

== Comparison of CNN architectures

=== Quantitative performance and its caveats

All CNN architectures achieved AUC values above $0.94$, with the custom
`3d_crop_deeper` reaching $0.991 plus.minus 0.015$. On quantitative metrics
alone, this would suggest that deeper volumetric architectures offer meaningful
gains. The Grad-CAM analysis, however, reveals a fundamental problem with this
interpretation.

With the sole exception of the `25d_resnet`, none of the evaluated architectures
produced attention patterns grounded in the striatum. The `3d_crop` model showed
spatially inconsistent activation, occasionally overlapping with the striatal
region but more often localizing to small image-edge areas with no reproducible
anatomical correspondence. The `3d_crop_deeper` and `med3d` variants, despite
their architectural differences, produced virtually indistinguishable attention
maps: diffuse, dot- and line-like patterns without any consistent anatomical
focus. The `med3d_encoder` produced a distinctive ring-shaped activation
encircling the image center, but not localized to the striatum itself.

Achieving high AUC without attending to the diagnostically relevant anatomical
region suggest that the models learned dataset-specific features and might
struggle on other data. In a multicenter dataset like PPMI, plausible elements
include site-specific acquisition differences, scanner intensity distributions,
and background characteristics that may covary systematically with diagnosis
group membership. The `25d_resnet`, ranking second in aggregate AUC at $0.979
plus.minus 0.021$, is the only architecture whose classification decisions seem
to be anatomically grounded, and therefore can be interpreted with clinical
confidence.

Achieving high AUC without apparent attention to the diagnostically relevant
anatomical region raises the concern that these models may have learned to
exploit dataset-specific confounds, such as site-related acquisition
differences, scanner intensity distributions, or background characteristics that
covary with diagnosis in the PPMI cohort. Whether this reflects genuine shortcut
learning or a limitation of Grad-CAM as an interpretability tool cannot be
established conclusively from this analysis alone; Grad-CAM provides a coarse,
gradient-weighted approximation that does not guarantee a complete picture of
what drives model decisions. Nevertheless, the finding motivates caution
regarding out-of-distribution generalizability. The `25d_resnet`, ranking second
in aggregate AUC at $0.979 plus.minus 0.021$, is the only architecture whose
attention is consistently localized to the striatum, and is therefore the more
conservative and clinically interpretable choice.


=== Transfer learning: ImageNet and MedicalNet

The superior interpretability of the `25d_resnet` relative to the 3D
architectures likely reflects the nature of its pretraining rather than its
dimensionality alone. ImageNet pretraining supplies low-level feature detectors
(edge filters, texture responses, ...) that transfer broadly across image
domains @raghuTransfusion2019. Applied to the maximum intensity projections of
DaTscan volumes, these features map directly to detecting the high-contrast
boundary between striatal uptake and the surrounding background, which is
precisely the signal distinguishing PD from HC patients. The network is thus
biased toward the relevant spatial gradients from the very start of fine-tuning.

MedicalNet pretraining, despite being domain-specific, did not confer an
equivalent advantage. Its weights were acquired from the Medical Segmentation
Decathlon, a collection of high-resolution structural CT and MRI volumes. These
structural anatomy segmentation tasks require specific detectors, different to
those required to detect localized intensity peaks of functional SPECT tracer.
When transferred to DaTscan classification, these structural detectors appear to
produce both poorer quantitative performance and non-anatomical attention. The
limited size of the available 3D DaTscan cohort further reduced the capacity of
fine-tuning to correct this initial misalignment.

== Raw vs. registered images

The consistent performance advantage of native, unregistered images over
spatially normalized volumes suggests that registration may not always benefit
end-to-end CNN classifiers. While spatial normalization is fundamental for
voxel-based neuroimaging analyses, it can introduce trade-offs that affect deep
learning performance.

DaTscan diagnosis primarily relies on localized intensity patterns within the
striatum rather than global anatomical correspondence. Consequently, the warping
and interpolation steps required for registration may smooth sharp intensity
gradients and attenuate diagnostically relevant information. Additionally,
visual inspection of the registered dataset revealed subtle streak-like patterns
(@fig-compareraw-reg), likely originating from resampling. In a data-limited setting,
high-capacity 3D CNNs may overfit to such non-biological artifacts instead of
the underlying pathological signal.

In contrast, native center-cropped volumes preserve original intensity
distributions and avoid interpolation artifacts, providing a cleaner input
representation. These findings suggest that, although registration remains
important for quantitative analyses and group-level comparisons, deep learning
models can perform effectively in native acquisition space. Future work using
registered datasets should carefully evaluate interpolation methods and employ
data augmentation to reduce the risk of artifact-driven learning.

== Multimodal integration with classical models

The additive feature set experiment confirmed that DaTscan-derived SBR features
alone provide a strong baseline, with marginal gains from progressively richer
tabular data until the motor assessment battery (MDS-UPDRS) is added. The
inclusion of UPDRS scores produced the single largest step improvement, raising
mean AUC from $0.995$ to $0.999$.

/* is this too daring of me to say? */
The MDS-UPDRS Part III is a clinician-administered motor examination whose score
constitutes one of the primary criteria by which PD is formally diagnosed. In a
cohort like PPMI, where diagnoses are expert-confirmed and UPDRS scores are
collected at the same clinical visit as imaging, the motor score is not an
independent predictor: it is, to a significant degree, a reexpression of the
diagnostic label. The performance improvement from adding UPDRS therefore
reflects circularity rather than genuine multimodal complementarity. A model
requiring UPDRS to classify PD provides no utility in early or prodromal
settings, precisely where automated tools are most needed and where motor signs
may not yet be manifest.

The olfactory test (UPSIT), by contrast, represents a genuinely complementary
non-motor prodromal marker. Its position among the top SHAP-ranked features is
clinically meaningful: hyposmia predates motor symptoms by years in many
patients @tolosaChallenges2021 and does not form part of the formal diagnostic
criteria.

== Multimodal integration with CNNs

=== Late vs. feature-level fusion

Late fusion consistently matched or outperformed feature-level fusion across all
clinical feature groups, with notably lower fold-to-fold variance. This outcome
is interpretable in terms of model complexity relative to available data.
Feature-level fusion introduces a tabular branch and joint classification head
that must be optimized on a fusion cohort of $N = 306$ subjects, a quite small
effective training set once split across five folds. Late fusion averages the
output probabilities of two independently pre-trained models, introducing no
additional learnable parameters. In a data-limited regime, the joint head can
overfit to fold-specific covariance structure between the image and tabular
branches. Late fusion avoids this entirely by treating each modality as an
independent expert. The gap was most pronounced for the cognitive (MoCA) feature
group, where feature-level fusion showed a substantially elongated lower whisker
in AUC. Cognitive scores carry weaker signal for binary PD--HC
classification than motor or olfactory features.

It is worth noting that the overall CNN multimodal performance is remarkably
stable across folds: the IQR are extremely narrow for the motor and olfactory
configurations. This architectural stability confirms that the model's
performance is not an artifact of a particular data split, but reflects a
consistent signal across the cohort. This interpretation is only meaningful,
however, for configurations built on the `25d_resnet` backbone, which has been
shown to attend to the correct anatomical region.

=== Combined clinical features do not outperform motor assessments alone

The combination of all available clinical features did not yield the highest
CNN multimodal performance; the motor-only configuration outperformed it on
most metrics. This mirrors the classical ML finding and carries a consistent
explanation: with a small fusion cohort, the classification head cannot learn
to discount the noisier contribution of demographic and cognitive features.
When all groups are concatenated, uninformative variables partially cancel the
signal carried by the motor and olfactory domains.

The same UPDRS circularity caveat applies here. The strong performance of the
motor-only CNN multimodal configuration reflects the near-tautological
relationship between motor examination scores and a clinician-confirmed PD
diagnosis, rather than independent informational gain.

== Inference on SWEDD patients <sec-swedd-discussion>

Post-hoc application of the trained `25d_resnet` to the SWEDD cohort ($N = 57$)
provides an independent validation of the imaging signal the model has learned.
patients in the SWEDD cohort, by definition, present normal dopamine transporter
imaging despite clinical parkinsonism, and were excluded from all training
procedures. The model assigned them a mean predicted PD probability of $0.113$,
which is statistically indistinguishable from the HC distribution ($U = 3765$,
$p = 0.077$) and far below the PD distribution ($p < 0.001$). A classifier that
genuinely learned dopaminergic signal should behave exactly this way: if the DAT
is intact, the image-based model should classify the patient as HC regardless of
their clinical presentation.

/* I made up 3 possible explanations for 10% swedds and higher std: */
The 10.5% of SWEDD patients classified as PD (P(PD)$ > 0.5$) warrants
further consideration. Three explanations are plausible and not mutually
exclusive. A subset of SWEDD patients may harbor a genuine but subtle DAT
deficit, below the clinical diagnostic threshold but detectable by a CNN
operating on the full image volume. Some SWEDD diagnoses may represent
misclassified early PD. Finally, some cases may fall at the boundary of the
model's decision surface, receiving elevated probabilities due to image features
unrelated to DAT loss. The notably higher standard deviation in this group
($sigma = 0.267$, compared to $0.136$ for HC and $0.145$ for PD) reflects genuine
heterogeneity within the SWEDD population and is consistent with the first two
explanations.

== Limitations

Several limitations of this study should be acknowledged. The analysis is
restricted to binary classification of manifest PD against HC groups using a
single cross-sectional timepoint. This formulation, while standard in the
methodological literature, does not address the most pressing clinical
challenge: distinguishing early or prodromal PD or PD from atypical parkinsonian
syndromes, where diagnostic uncertainty is greatest.

A key limitation is that all models were trained and evaluated exclusively on
PPMI. External validation on independent cohorts acquired with different
scanners and protocols is required before clinical deployment

Class imbalance required majority-class downsampling, reducing the effective
training set size and discarding informative PD cases. Alternative strategies
such as data augmentation or oversampling were not systematically evaluated.

Finally, Grad-CAM analysis suggests that the high AUC values of the 3D custom
architectures may not be backed by anatomically meaningful attention, raising
generalizability concerns for datasets acquired outside the PPMI protocol. It
should be acknowledged that Grad-CAM itself is an approximation and may not
fully reflect the features a model relies upon. These observations should
therefore be treated as a signal for caution rather than a definitive
characterization of model behavior. Only the 25d_resnet produced attention
consistently localized to the striatum

#v(-4pt)
== Contributions to the United Nations' SDGs

This thesis primarily contributes to *SDG 3: Good Health and Well-being*, which
aims to ensure healthy lives and promote well-being for people of all ages.
Parkinson's disease affects an estimated 10 million people worldwide and its
prevalence is projected to nearly double over the coming decades as populations
age @poeweParkinson2017. This work addresses the dependence on subjective visual
assessment by specialist readers, which limits access and delays diagnosis in
centers where nuclear medicine expertise is scarce.
