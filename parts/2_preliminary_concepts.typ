#import "../assets/ak_tfg_lib.typ": *

= Preliminary Concepts

//== Parkinson's Disease
// Epidemiology: prevalence, age of onset
// Pathophysiology: focus on neurodegeneration in the substantia nigra and its
// projection to the striatum. Keep it tightly scoped to what's relevant: you're explaining *why
// dopamine loss in the striatum is what DaTscan measures, so everything should
// build toward that. You don't need to cover all PD pathology --- just the
// dopaminergic circuit. A good citation anchor here would be a major PD review
// paper.
//== DaTSCAN (#super[123]Ioflupane)
// Explain the mechanism (DAT transporter binding, SPECT imaging)
// what the resulting images look like (comma vs period visual)
// why it produces the image pattern the CNN will learn to classify
// The PPMI protocol docs and original validation papers are adequate here
//== Convolutional Neural Networks (CNNs)
// To Adrià: Should I explain basics like perceptrons and connections?
// Start with convolutional layers and explain the inductive bias that makes
// them suited to images (local feature detection, translation invariance,
// hierarchical features.
// Show the convolution equation, but frame it in terms of what it does rather

// than what it is (whatever that means).
// Then pooling, activation functions and the overall architecture concept
//== Evolution of CNNs in Medical Imaging
// Cover LeNet -> AlexNet, then talk about the shift to deeper architectures
// (VGG, ResNet with its residual connections), and then the specific adoption
// in medical imaging.
// The Litjens et al. 2017 survey "A survey on deep learning in medical image
// analysis" is the canonical citation here and covers everything you need.
//== Clasical Machine learning
// SVM, logistic regression


== Parkinson's Disease

=== Overview and Epidemiology

// I'm repeating the introduction a bit, might need rewriting/reordering?
Parkinson's disease is a progressive neurodegenerative disorder that
represents the second most common conditions of its type worldwide.
Its incidence rises sharply with age, with a median onset around 60 years,
and if affects men at a somewhat higher rate than women
@poeweParkinson2017.
Global prevalence currently stands at approximately 10 million, and
projections consistency indicate this figure will nearly double over the next
two to three decades as demographic ageing accelerates across high-income
countries @ben-shlomoEpidemiology2024.
// High-income?
Beyond its individual impact, PD imposes a substantial growing collective
burden, driven by the costs of prolongued care, loss of productivity among
patients, time spent by unpaid caregivers, and the extended diagnosticp ath
that precedes a confimed clinical diagnosis @faulkEconomic.

