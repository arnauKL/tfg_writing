#import "../assets/ak_tfg_lib.typ": *

= Budget

Despite the fact that this project was not financially compensated, an
approximate budget has been prepared to estimate the cost of carrying out the
project under professional conditions. The profile of a junior AI engineer or
research assistant has been used as a reference. @human summarizes the estimated
personnel costs.

#figure(
  tablef(
    columns: 4,
    row-gutter: 0pt,
    [ Personnel], [Hours ], [ Cost/hour ], [ Total],
    [ Junior AI Engineer / Research Assistant ], [ 450 h ], [ 18 €/h ], [ 8100 € ],
    [ Academic Supervisor ], [ 16 h ], [ 25 €/h ], [ 400 € ],
    [ *Total* ], [], [], [ *8500 €* ],
  ),
  caption: [Human Resources.]
)<human>

This section estimates the cost of the hardware and data resources used
throughout the project (@hw). The calculation includes the development workstation,
access to the computational infrastructure provided by VICOROB, and the datasets
employed, which are publicly available at no cost.

#figure(
  tablef(
    row-gutter: 0pt,
    columns: 4,
    [ Resource],[ Quantity ],[ Unit Cost ],[ Total],
    [ Development laptop/workstation ],[1],[1100 €],[ 1100 €],
    [ PPMI dataset],[1],[ 0 €],[ 0 €],
    [ VICOROB server ],[ 300 h],[ 10 €/h],[ 3000 €],
    [ *Total* ],[],[],[ *4100 €* ]
  ),
  caption: [Hardware and Data Resources.]
)<hw>

Although most software resources used in this project are open source and
therefore incur no licensing costs, they are included in the budget analysis
because they constitute essential technological resources for the development
and reproducibility of the work.

#figure(
  tablef(
    columns: 5,
    row-gutter: 0pt,
    [ Resource               ],[ Quantity ],[ Cost ],[ Total   ],[ Observations ],
    [ Linux Operating System ],[ 1        ],[ 0 €  ],[ 0 €     ],[ Used on both
  laptop and server],
    [ Python                 ],[ 1        ],[ 0 €  ],[ 0 €     ],[ Main language
  used ],
    [ PyTorch                ],[ 1        ],[ 0 €  ],[ 0 €     ],[ Deep learning
    framework used ],
    [ MONAI                  ],[ 1        ],[ 0 €  ],[ 0 €     ],[ Medical
    imaging framework ],
    [ Scikit-learn           ],[ 1        ],[ 0 €  ],[ 0 €     ],[Classical
    machine learning
  library],
    [ Git                    ],[ 1        ],[ 0 €  ],[ 0 €     ],[ Version
    control system ],
    [ Vim                    ],[ 1        ],[ 0 €  ],[ 0 €     ],[ Primary text and
    code
  editor],
    [ Codium                 ],[ 1        ],[ 0 €  ],[ 0 €     ],[ Remote
    development environment ],
    [ *Total*              ],[          ],[      ],[ *0 €* ],[ ],
  ),
  caption: [Software Resources.]
)

Below is the final summary of the project's estimated budget (@totalbudget).

#figure(
  tablef(
    row-gutter: 0pt,
    columns: 2,
    [ Category                    ],[ Total        ],
    [ Human resources             ],[ 8500 €     ],
    [ Hardware and infrastructure ],[ 4100 €      ],
    [ Software resources          ],[ 0 €          ],
    [ *Grand Total*             ],[ *12600 €* ],
  ),
  caption: [Total estimated cost of development.]
)<totalbudget>
