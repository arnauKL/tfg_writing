#import "tfg_template_ak.typ": *

#show: tfg_template_ak.with(
    title: [Deep Learning-Based Classification \ of Parkinson's Disease Stages \
        Using DaTSCAN],
    short_title: "DL Classification of Parkinson's Stages (DaTSCAN)",
    author: "Arnau K. Deprez Santamaria",
    tutor: "Adrià Casamitjana",
    thx: [ I'd like to thank my mom. ],
)
// Project structure:
// https://sitandr.github.io/typst-examples-book/book/basics/must_know/project_struct.html

// ----------------- Document -----------------

//#set heading(numbering: "(I)")

= Introduction

#lorem(2)

$ a = "b" infinity sin(b) $


#lorem(30)

#lorem(40)

#lorem(10)

#lorem(90)

= Conceptes previs

#lorem(14)

#lorem(37)

#lorem(30)

== Parkinson's Disease <parkinsons>

#lorem(14)


=== A third level

#lorem(37)

I have the higher ground. #lorem(37)

=== Another 3rd level
#lorem(37)

In @parkinsons, I said so. #lorem(21)

#lorem(30)

==== A fourth??

I never use this many levels anyway. #lorem(41)

== DaTSCAN

#lorem(24)

= I really want to use the #link("https://github.com/edgaremy/neural-netz")[neural-netz] package

Like omg I'd love to be able to show my attempts like this (@nn_test).

#figure(
    image("figures/nn_example.svg"),
    caption: [It looks so good],
)<nn_test>

#lorem(30)

#lorem(17)

#lorem(70)

= State of the art

#lorem(37)

#lorem(20)

#lorem(40)

#lorem(15)

= Now some code

Hehe here goes #lorem(49)

== Testing

My super groundbreaking program

#figure(
    ```c
    #include <stdio.h>

    int
    main(int argc, char *argv[]) {
      printf("Hello world!n");
      return EXIT_SUCCESS;
    }
    ```,
    caption: [Test],
) <test>

#lorem(28). check out my cool code at @test.




#pagebreak()

// = Hipòtesis i objectius
// = Materials i mètodes
// = Results
// = Discussió
// = Conclusions
// - Referències.
// - Annex A. Planificació
// - Annex B. Codi
// - Annex C. Pressupost
// - Annex D. Comitè d'Ètica


// Per començar la secció d'apèndixs
#show: appendix
= Budget

= Code

This project has been version controlled since I started it and its hosted on
GitHub. It can be found at #link(
    "https://github.com/arnauKL/tfg",
)[`arnauKL/tfg`].
// - Annex A. Planificació

#figure(
    image("figures/gantt.svg"),
    caption: [ Diagrama de Gantt. ],
    alt: "...",
)

// - Annex B. Codi
// - Annex C. Pressupost
// - Annex D. Comitè d'Ètica

// = Tables and Data <app1>
// = Additional Listings <app2>

#pagebreak()
*Colophon*

This thesis was typeset in #link("https://typst.app")[typst] using a custom
template inspired by the principles in the book #link(
    "https://practicaltypography.com",
)[Practical Typography by Matthew Butterick]. The body text is set in Linux
Libertine and code listings in Caskaydia Cove.

The cover was inspired by:
- #text(red)[idk the link]
