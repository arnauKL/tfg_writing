#import "../assets/ak_tfg_lib.typ": *

/*
En aquest annex s’han d’incloure una descripció de totes les tasques que s’han
dut a terme en el TFG, que inclogui la seva informació temporal i ús de
Recursos.

Respecte a la temporalitat, s’indicarà, per a cada tasca, la seva duració, amb
data d’inici i fi, previ a l’inici de cap desenvolupament.

Quant als recursos, s’indicaran les persones que han format part de l’equip,
hores de dedicació, així com infraestructures, serveis i equipaments que han
estat necessaris per a la consecució del TFG.

A mena de resum, ha d’incloure un diagrama de Gantt.

Si la planificació no s’ha complert i/o ha hagut variacions, caldrà
justificar-ho, i proporcionar la planificació final.
*/

/*
This appendix must include a description of all the tasks carried out as part of
the Final Degree Project, including their timeline and use of resources.
Regarding the timeline, the duration of each task---including start and end
dates---must be specified prior to the commencement of any work.

Regarding resources, list the people who were part of the team, the hours
dedicated, as well as the infrastructure, services, and equipment necessary for
the completion of the TFG.

As a summary, a Gantt chart must be included.

If the schedule was not followed and/or there were deviations, these must be
justified, and the final schedule must be provided.
*/
= Planning

The thesis was developed over approximately eighteen weeks, from the first supervisor meeting in late January 2026 to the submission deadline of 1st June 2026. Tasks overlapped considerably in practice: preprocessing and model development ran in parallel, and writing was carried out progressively throughout the semester based on implementation logs rather than in a single final phase. The timeline is summarised in @gantt and described in detail below.

== Team and resources

#show terms: set par(spacing: 1.25em)

/ Student: Arnau K. Deprez Santamaria. Sole researcher, responsible for
  literature review, data preprocessing, model implementation, experimental
  evaluation, and report writing. Estimated total: 480 hours.

/ Supervisor: Dr. Adrià Casamitjana Díaz (VICOROB, Universitat de Girona).
  Responsible for project direction, feedback on methodology and writing, and
  provision of the registered DaTscan image dataset. Estimated involvement:
  20--25 hours across weekly meetings and asynchronous feedback.

/ Computational infrastructure: GPU server provided by the VICOROB research
  group, equipped with three NVIDIA GeForce GTX 1080 Ti GPUs (11 GB VRAM each).
  Estimated usage: 300 GPU-hours. Personal ASUS laptop used for development,
  writing, and figure generation.

/ Dataset: Parkinson's Progression Markers Initiative (PPMI), accessed under
  the official PPMI data use agreement at no cost. See Appendix D for ethical
  details.

/ Software: All software used was free and open-source (Python, PyTorch, MONAI,
  scikit-learn, Typst). No licensing costs were incurred.

== Timeline

/ Initial planning and proposal (3 weeks, late January -- early March): First
  meetings with the supervisor to define the project scope and research
  questions. Study of background material on Parkinson's disease and
  convolutional neural networks. Submission of the formal thesis proposal.
  Approved by the committee on 3 March 2026. _Estimated hours: 30._

/ Literature review and state of the art (4 weeks, March): Systematic review of
  the DaTscan classification literature, deep learning for neuroimaging, and
  multimodal fusion methods. Server setup and initial CUDA environment
  configuration at VICOROB. _Estimated hours: 60._

/ Data preprocessing and initial 2D networks (4 weeks, March -- April):
  Familiarization with the PPMI dataset structure and BIDS organization.
  Construction of the subject-level cohort (mapping baseline DaTscan images to
  diagnostic labels). Implementation of the MONAI preprocessing pipeline
  (intensity normalization, center-cropping, MIP computation). First 2D CNN
  experiments based on VGG-style architectures to validate the pipeline end to
  end. _Estimated hours: 90._

/ 3D CNN development and training (5--6 weeks, March -- May): Implementation of
  custom 2D, 2.5D, and 3D CNN architectures. Integration of ImageNet and
  MedicalNet pretrained weights. Development of the unified `train.py` script
  with reproducible configuration management (seeds, timestamps, fold
  definitions). Systematic evaluation on raw and registered image sets with
  2-fold and 5-fold cross-validation. _Estimated hours: 120._

/ Classical ML baseline and multimodal fusion (3 weeks, April -- May):
  Extraction and engineering of tabular features from the PPMI curated
  spreadsheet. Training and evaluation of SVM, Random Forest, Gradient Boosting,
  and Logistic Regression classifiers across the seven additive feature sets.
  SHAP analysis on the best-performing configuration. _Estimated hours: 60._

/ Multimodal CNN fusion and explainability (2 weeks, May): Implementation of
  late fusion and feature-level fusion architectures using the best image-only
  CNN backbone. Grad-CAM visualization for all evaluated architectures. SWEDD
  post-hoc inference. _Estimated hours: 60._

/ Report writing and figure generation (2 weeks, mid-May -- 1 June):
  Writing of all thesis sections based on implementation logs and experimental
  notes kept throughout the semester. Generation of all figures using
  Matplotlib, styled for consistency with the document typography. Final
  revision and submission. _Estimated hours: 60._

The development timeline is summarised in @gantt. Most tasks overlapped in
practice; the boundaries above reflect the period of primary focus for each
activity.

#figure(
  include "../assets/figures/gantt.typ",
  caption: [Gantt chart summarising the main development stages of the thesis
    project.],
)<gantt>

== Deviations from the original plan

The original proposal targeted multi-stage classification including prodromal
patients alongside healthy controls and manifest PD. Approximately six weeks
into the project it became apparent that the version of the PPMI dataset
accessible through the research group did not include prodromal DaTscan images,
as these were added to PPMI at a later date. The scope was consequently
reoriented toward a systematic comparison of CNN architectures, transfer
learning strategies, spatial preprocessing choices, and multimodal fusion
paradigms for binary HC versus PD classification. This reorientation is
reflected in the research gap and objectives stated in Section 4. No significant
deviations from the revised timeline occurred. The report writing phase was
slightly compressed relative to the original plan, as figure generation and
formatting required more time than anticipated.

/*
= Planning


The proposal was submitted in late January and formally approved in early March.
Preprocessing of the PPMI dataset and implementation of the classical machine
learning baselines began shortly afterward, followed by development and training
of the CNN architectures throughout March and April. Multimodal fusion
experiments were conducted during early May. Thesis writing was carried out
progressively based on implementation logs and experimental notes collected
during the semester, while the document template and report structure were
finalized in parallel.

The redaction of this report started in May based on log notes kept during the
semester, while the template itself was finalized around April.



== Timeline

#show terms: set par(spacing: 1.5em)

/ Initial planning and proposal (3 weeks): Work started late-january, when I
  first got together with my tutor. We met a few times to write and define a
  concrete thesis proposal. At this same time I worked on learning about
  Parkinson's disease and CNNs.

/ Literature review and state of the art (4 weeks): Once defined the proposal
  and being accepted by the committee in early march, work started on early
  March. I focused on establishing a solid foundation in deep neural networks
  and machine learning. I ran some simple tests on the VICOROB server to get
  things up and running while learning to debug CUDA.

/ First networks, preprocessing pipeline and familiarization with PPMI (4 weeks):
  I did some simple 2d CNNs based on VGGs from what I had found in the
  literature so far, which were a quick way to test my knowledge, the depth of
  the nets, work on the different transformations and preprocessing steps,
  visualizations. I also created the datasets I'd be using throughout this whole
  thesis, mapping `ses-BL` DaTscan images to their labels extracted from the
  metadata files.

/ Training of 3D CNNs (5--6 weeks): I started to try out different sets of
  architectures, look for ImageNet and MedNet weights, start trying out
  approaches with different image sets and transformations (cropping, padding,
  both, normalization, etc). Here I wrote the training scripts found in the
  repository. I spent some days working on the main `train.py` script in order
  to have a reproducible setup by storing configuration alongside state
  (timestamps, seeds, batch-size, n_folds, architectures, dataset chosen)


/ Classical ML and multimodal integration (3 weeks): To establish a baseline to
  the later mutlimodal CNN tests I started to train some classical ML (SVMs, LR,
  GB) and extracting the different sets of features from the PPMI tabular data.

/ Multimodal CNNs and explainability via Grad-CAM (2 weeks):
  I started work on creating scripts to train mutlimodal CNNs following the late
  and feature-level fusion approaches mentioned.

/ Redaction of this report (2 weeks): On the last two weeks before the deadline
  I started writing this report and generating most of the figures in it using
  matplotlib to match the document (fonts, consistency across figures, etc). I

The development timeline of the thesis is summarized in @gantt. There was some
overlap between most of these tasks.

#figure(
  include "../assets/figures/gantt.typ",
  caption: [Gantt chart summarizing the main development stages of the thesis
    project.],
)<gantt>
*/
