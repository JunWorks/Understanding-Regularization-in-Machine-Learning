library(ggplot2)
library(dplyr)


N <- 200 # number of points per class
D <- 2 # dimensionality, we use 2D data for easy visualization
K <- 2 # number of classes, binary for logistic regression
X <- data.frame() # data matrix (each row = single example, can view as xy coordinates)
y <- data.frame() # class labels

#set.seed(290)
#set.seed(26)
set.seed(3)
#set.seed(9)

for (j in (1:K)){
  r <- rnorm(N, j-0.5, sd = 0.3*(2-j)+0.1) # radius
  t <- seq(0, pi*2-(j-1)/2, length.out = N)  # theta
  Xtemp <- data.frame(x1 =r*sin(t) , x2 = r*cos(t))
  ytemp <- data.frame(matrix(j-1, N, 1))
  X <- rbind(X, Xtemp)
  y <- rbind(y, ytemp)
}

data <- cbind(X,y)
colnames(data) <- c(colnames(X), 'label')

# create dir images
dir.create(file.path('.', 'images'), showWarnings = FALSE)

# lets visualize the data:
data_plot <- ggplot(data) + geom_point(aes(x=x1, y=x2, color = as.character(label)), size = 2) + 
  scale_colour_discrete(name  ="Label") + 
  xlim(-2, 2) + ylim(-2, 2) +
  coord_fixed(ratio = 1) +
  ggtitle('Data to be classified') +
  theme_bw(base_size = 15) +
  theme(legend.position=c(0.85, 0.87))

png(file.path('images', 'data_plot.png'))
print(data_plot)
dev.off()

#sigmoid function, inverse of logit
sigmoid <- function(z){1/(1+exp(-z))}

#cost function + regularization
cost <- function(theta, X, y, lambda){
  m <- length(y) # number of training examples
  h <- sigmoid(X %*% theta)
  theta1 <- theta
  theta1[1] <- 0
  J <- (t(-y)%*%log(h)-t(1-y)%*%log(1-h))/m + lambda*(theta1%*%theta1)/m
  J
}

#gradient function
grad <- function(theta, X, y, lambda){
  m <- length(y) 
  h <- sigmoid(X%*%theta)
  theta1 <- theta
  theta1[1] <- 0
  grad <- (t(X)%*%(h - y) + lambda * theta1)/m
  grad
}

logisticReg <- function(X, y, lambda = 0){
  #remove NA rows
  X <- na.omit(X)
  y <- na.omit(y)
  #add bias term and convert to matrix
  X <- mutate(X, bias =1)
  #move the bias column to col1
  X <- as.matrix(X[, c(ncol(X), 1:(ncol(X)-1))])
  y <- as.matrix(y)
  #initialize theta
  theta <- matrix(rep(0, ncol(X)), nrow = ncol(X))
  #use the optim function to perform gradient descent
  costOpti <- optim(theta, fn = cost, gr = grad, 
                    #method = "L-BFGS-B", 
                    method = "BFGS", 
                    X=X, y=y, lambda = lambda)
  #return coefficients
  return(costOpti$par)
}

logisticProb <- function(theta, X){
  X <- na.omit(X)
  #add bias term and convert to matrix
  X <- mutate(X, bias =1)
  X <- as.matrix(X[,c(ncol(X), 1:(ncol(X)-1))])
  return(sigmoid(X%*%theta))
}

logisticPred <- function(prob){
  return(round(prob, 0))
}

expandFeature <- function(X, power = 4){
  #expand a 2D feature matrix to polynimial features up to the power
  x1 <- X[, 1]
  x2 <- X[, 2]
  Xafter <- X
  for (i in (2:power)){
    for (j in (0:i)){
      colname <- paste("x1^", j, "*x2^", (i-j), sep = '')
      feature <- data.frame((x1**j)*(x2**(i-j)))
      names(feature)[1] <- colname
      Xafter <- cbind(Xafter, feature)
    }
  }
  return(Xafter)
}
# training
power <-6
Xtrain <- expandFeature(X, power)

lambdas <- c(0, 5)
names <- c('no_reg', 'reg')
for (i in c(1, 2)){
  theta <- logisticReg(Xtrain, y, lambda = lambdas[i]) #lambda = 5
  # generate a grid for decision boundary, this is the test set
  grid <- expand.grid(seq(-2, 2, length.out = 100), seq(-2, 2, length.out = 100))
  grid <- expandFeature(grid, power)
  # predict the probability
  probZ <- logisticProb(theta, grid)
  # predict the label
  Z <- logisticPred(probZ)
  gridPred = cbind(grid, Z)
  
  # decision boundary visualization
  p <- ggplot() + geom_point(data = data, aes(x=x1, y=x2, color = as.character(label)), size = 2, show.legend = F) + 
    geom_tile(data = gridPred, aes(x = grid[, 1],y = grid[, 2], fill=as.character(Z)), alpha = 0.3, show.legend = F)+ 
    #ylim(0, 3) +
    ggtitle('Decision Boundary for Logistic Regression') +
    coord_fixed(ratio = 1) +
    theme_bw(base_size = 15) 
  
  png(file.path('images', paste(names[i], '.png', sep = '')))
  print(p)
  dev.off()
} 
