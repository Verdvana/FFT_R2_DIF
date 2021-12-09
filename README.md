# 位宽和点数可定制的基2的频域抽取并行FFT
#### 代码介绍
    位宽和抽取点数可定制的基2的频域抽取并行FFT模块，计算速度为4个时钟周期，占用资源较多。

* V1.0   `2019.11.19`
    * 输入信号位宽可定制；
    * 抽取点数可定制（需事先计算旋转因子）；
    * Radix 2；
    * DIF；
    * N点全部输入后四个时钟周期即可得出结果；
    * 占用内部DSP较多。

![img1](https://raw.githubusercontent.com/Verdvana/FFT_B2_DIF/master/Simulation/FFT_B2_DIF_TB/wave.jpg)


* V2.0  `2021.12.06`
    * FFT butterfly transformation is update to pipeline;
    * Data stream.
