Understanding Regularization in Machine Learning
================
How to deal with overfitting using regularization

Introduction
------------

In my previous [repo](https://github.com/JunWorks/Logistic-Regression-from-scratch-in-R), I only used two features (x1, x2) and the decision boundary is a straight line on a 2D coordinate. In most of the real world cases, the data set will have many more features and the decision boundary is more complicated. With so many features, we often overfit the data. Overfitting is a modeling error in a function that is closely fit to a data set. It captures the noise in the data set, and may not fit new incoming data.

To overcome this issue, we mainly have two choices: 1) remove less useful features, 2) use regularization. This repo will focus on regularization.

Example data to be classified
------------

<p float="left">
  <img src="/images/data_plot.png" width="400" />
</p>

Logistic regression with no regularization
------------
<p float="left">
  <img src="/images/no_reg.png" width="400" />
</p>

Logistic regression with regularization
------------
<p float="left">
  <img src="/images/reg.png" width="400" />
</p>

You can see the tutorial [here](https://towardsdatascience.com/understanding-regularization-in-machine-learning-5a0369ac73b9#3b9a-5d25d83f41c6).

Similar tutorial with Python can be viewed [here](https://github.com/JunWorks/ML-Algorithm-with-Python).
