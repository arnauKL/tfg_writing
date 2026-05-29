#import "../assets/ak_tfg_lib.typ": *

= Budget

An estimation of costs has been tallied up in an effort to estimate what this
project would cost to conduct from scratch. 

As previously mentioned, the infrastructure used was a server with 3 GPUs
provided by the research group VICOROB.

As to the cost of personnel, an estimation has been done taking a biomedical
engineer profile.

Finally, there were no costs related to licensing since all software used was
free and open source (all python libraries, the OS on the server and my laptop,
the IDEs, datasets and reference implementations).

#figure(
  text(0.85em, ```
  +-----------------------------------------------------------------------------------------+
  | NVIDIA-SMI 580.159.03             Driver Version: 580.159.03     CUDA Version: 13.0     |
  +-----------------------------------------+------------------------+----------------------+
  | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
  |                                         |                        |               MIG M. |
  |=========================================+========================+======================|
  |   0  NVIDIA GeForce GTX 1080 Ti     On  |   00000000:02:00.0 Off |                  N/A |
  | 38%   73C    P2             67W /  250W |     401MiB /  11264MiB |      2%      Default |
  |                                         |                        |                  N/A |
  +-----------------------------------------+------------------------+----------------------+
  |   1  NVIDIA GeForce GTX 1080 Ti     On  |   00000000:03:00.0 Off |                  N/A |
  | 84%   88C    P2            181W /  250W |   10955MiB /  11264MiB |     74%      Default |
  |                                         |                        |                  N/A |
  +-----------------------------------------+------------------------+----------------------+
  |   2  NVIDIA GeForce GTX 1080 Ti     On  |   00000000:82:00.0 Off |                  N/A |
  | 21%   37C    P8              9W /  250W |       9MiB /  11264MiB |      0%      Default |
  |                                         |                        |                  N/A |
  +-----------------------------------------+------------------------+----------------------+
  ```
  ),
  caption: [VICOROB's GPU infrastructure.]
)

#figure(
  tablef(
    columns: 4,
    [Description],[Amount],[Price],[Total],
    [ASUS Laptop],[1],[1500 €],[1500 €],
    ["MIC1" server (VICOROB)],[300h],[10 €/h],[3000 €],
  )
)

