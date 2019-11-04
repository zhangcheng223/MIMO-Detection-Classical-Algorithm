# <center>  实现MIMO信号检测的经典算法</center>
## ML检测
$$
\hat{\mathbf{x}}_{M}=\underset{\mathbf{x} \in C^{N_{T}}}{\arg \min }\|\mathbf{y}-\mathbf{H x}\|
$$
**优点**：
* 理论上，在发送信号向量等概时，ML检测方法达到最大后验概率（MAP）检测的最优检测，可以提供 的分集度，并且接收天线数 越大，ML检测的性能越好；
* 可以用作其他检测方法性能的参考。

**缺点**
* 当信号星座空间大小为$M$，发射天线数为$N_{T}$时，ML检测一般通过对发送信号向量进行遍历的方法，算法复杂度为$O\left(M^{N_{\mathrm{T}}}\right)$，也就是说计算复杂度随天线数的增长成指数增加。

## ZF检测
$$
\hat{\mathbf{x}}_{Z F}=\underset{\mathbf{x} \in C^{N_{T}}}{\arg \min } J_{\mathbb{Z F}}(\mathbf{x})=\underset{\mathbf{x} \in C^{N_{T}}}{\arg \min }(\mathbf{y}-\mathbf{H x})^{H}(\mathbf{y}-\mathbf{H x})
$$

$$
\mathbf{W}_{\mathrm{ZF}}=\left(\mathbf{H}^{H} \mathbf{H}\right)^{-1} \mathbf{H}
$$

**优点**
* ZF检测是线性检测方法，只需要对接收信号作线性处理，并且检测的复杂度为$O\left(N_{\mathrm{T}}^{3}\right)$（$N$阶方阵求逆的复杂度$O\left(N^{3}\right)$），相对ML检测极大地降低了复杂度。

**缺点**
* ZF检测在抑制其他发射天线符号干扰的同时将噪声过度放大，从而影响了最终判决的性能，也就是说ZF检测算法抗噪声性能很差，只有$N_{\mathrm{R}}-N_{\mathrm{T}}+1$的分集阶数。

## MMSE检测
$$
\begin{aligned} \hat{\mathbf{x}}_{M M S E} &=\underset{\mathbf{x} \in C}{\arg \min } J_{\mathbb{Z F}}(\mathbf{x}) \\ &=\underset{\mathbf{x} \in C}{\arg \min } E\left\{\|\mathbf{x}-\mathbf{W} \mathbf{y}\|^{2}\right\} \\ &=\underset{\mathbf{x} \in L^{\mathbb{T}}}{\arg \min } E\left\{(\mathbf{x}-\mathbf{W} \mathbf{y})^{H}(\mathbf{x}-\mathbf{W} \mathbf{y})\right\} \end{aligned}
$$

$$
\mathbf{W}_{\mathrm{MMSE}}=\left(\mathbf{H}^{H} \mathbf{H}+\sigma_{z}^{2} \mathbf{I}\right)^{-1} \mathbf{H}^{H}
$$

**优点**
* MMSE检测是线性检测方法，只需要对接收信号作线性处理，并且检测的复杂度为$O\left(N_{\mathrm{T}}^{3}\right)$ （$N$阶方阵求逆的复杂度$O\left(N^{3}\right)$），相对ML检测极大地降低了复杂度；
* MMSE考虑了噪声对系统的影响，在信噪比低时，噪声在ZF检测影响会更严重，MMSE检测性能优于ZF检测。当信噪比增高时，MMSE检测逐渐收敛于ZF检测。

**缺点**
* 与ZF检测算法一样，MMSE检测算法在抑制其他发射天线符号干扰的同时将噪声过度放大，从而影响了最终判决的性能；
* 与ZF检测一样，MMSE检测算法可以提供$N_{\mathrm{R}}-N_{\mathrm{T}}+1$的分集阶数；
* MMSE检测需要噪声的统计信息也就是方差 和一次额外的矩阵加法，复杂度略高于ZF检测。