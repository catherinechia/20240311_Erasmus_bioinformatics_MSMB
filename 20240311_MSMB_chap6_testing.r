#Chapter 6 - Testing
#Install package
install.packages("Rlab")

#Bernouli distribution
barplot(names.arg = 0:1, height = dbinom(0:1, size = 1, p = 0.6), cex.axis=2.0, xlab = 'H=1, T=0', cex.names=2.0, cex.lab=2.0, ylab = 'Probability', main = 'Bernoulli distribution of single coin flip') 

# Importing the Rlab library
library(Rlab)

# x values for the dbern() function
x <- c(0, 1)
 
# Using dbern() function to obtain the corresponding Bernoulli PDF
y <- dbern(x, prob = 0.5)
 
# Plotting dbern values
plot(x, y, type = "o")



# 6.2 - An example: coin tossing
###########################
set.seed(0xdada)
numFlips = 100
probHead = 0.6
coinFlips = sample(c("H", "T"), size = numFlips,
  replace = TRUE, prob = c(probHead, 1 - probHead))
head(coinFlips)

#Now, if the coin were fair, we would expect half of the time to get heads. Let’s see.
table(coinFlips)

###########################
#Using Eqn 6.3 to get probability distribution
library("dplyr")
k = 0:numFlips
numHeads = sum(coinFlips == "H")
binomDensity = tibble(k = k,
     p = dbinom(k, size = numFlips, prob = 0.5))

#plot (binomDensity, cex=5.0, pch=16, ylab="Density", xlab="Number of heads", main="Probability distribution of number of heads")
library("ggplot2")
ggplot(binomDensity) +
  geom_bar(aes(x = k, y = p), stat = "identity") +
  #geom_vline(xintercept = numHeads, col = "blue") + 
  xlab("Number of H") + ylab("Density") + 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=25))

##############
#Using binomDensity  with arrange function and plot alpha
library("dplyr")
alpha = 0.05
binomDensity = arrange(binomDensity, p) |>
        mutate(reject = (cumsum(p) <= alpha))

ggplot(binomDensity) +
  geom_bar(aes(x = k, y = p, col = reject), stat = "identity") +
  scale_colour_manual(
    values = c(`TRUE` = "red", `FALSE` = "darkgrey")) +
  geom_vline(xintercept = numHeads, col = "blue") +
  theme(legend.position = "none")


##############
#Using Monte Carlo to get probability distribution
numSimulations = 10000
outcome = replicate(numSimulations, {
  coinFlips = sample(c("H", "T"), size = numFlips,
                     replace = TRUE, prob = c(0.5, 0.5))
  sum(coinFlips == "H")
})
ggplot(tibble(outcome)) + xlim(-0.5, 100.5) +
  geom_histogram(aes(x = outcome), binwidth = 1, center = 50) 
  +
  geom_vline(xintercept = numHeads, col = "blue")


#################################################################################
#Generate random number continuous
l_rand = rnorm(100, mean = 0, sd = 1)
hist(l_rand, breaks = 100, col = "lightblue", border = "black")