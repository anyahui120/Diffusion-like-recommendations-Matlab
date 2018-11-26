# Diffusion-like-recommendations
This is a simple repo for diffusion-like recommendation algorithms. In this project, you can find the kernel functions of similarities in file ``./src/diffuseRec.m`` and the metrics precision@L, recall@L, hamming distance@L and novelty@L in ``./src/cnFun.m``; ranking score in ``rs.m``. The main script is in ``recScript.m``. You can run the ``recScript.m`` file directly. You will find they are very fast!!!
(Note that, you will need about 12GB of physical RAM when running the biggest dataset, RYM, please allocate enough memory for that dataset or you can improve my codes.)

# Datasets
We use three real world datasets: MovieLens, Netflix and RYM for evaluation. You can find one ``train.txt`` and one ``test.txt`` in each dataset, containing 90% and 10% records (userID\t itemID\t rating\t timestamp (if have)). For more details, please refer to the listed papers. 

# Please cite our papers if you use our codes. Thanks!:

[1] Nie, D. C., An, Y. H., Dong, Q., Fu, Y., & Zhou, T. (2015). Information filtering via balanced diffusion on bipartite networks.    Physica A: statistical mechanics and its applications, 421, 44-53. (<a href="http://anyahui.cn/files/PhysicA2015InformationFilteringViaBalancedDiffusionOnBipartiteNetworks.pdf">Download</a>)

[2] An, Y. H., Dong, Q., Sun, C. J., Nie, D. C., & Fu, Y. (2016). Diffusion-like recommendation with enhanced similarity of objects. Physica A Statistical Mechanics and its Applications, 461, 708-715. (<a href="http://anyahui.cn/files/Diffusion-like%20recommendation%20with%20enhanced%20similarity.pdf">Download</a>)

# Contacts:
anyahui.120@gmail.com


