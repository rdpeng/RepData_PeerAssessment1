My First R Markdown File
========================

This is my first R markdown file.

Here, we're going to load some data.

```{r}
library(datasets)
data(airquality)
summary(airquality)
```

Let's first make a pairs plot of the data
```{r}
pairs(airquality)
```

Here's a regression model of ozone on wind, solar radiation, and temperature

```{r fitmodel}
library(stats)
fit <- lm(Ozone ~ Wind + Solar.R + Temp, data = airquality)
summary(fit)
```
Here is a table of regression coefficients.
```{r showtable, results="asis"}
library(xtable)
xt <- xtable(summary(fit))
print(xt, type = "html")
```


Here's an unordered list:  

* First element

* Second element

```{r computetime, echo=FALSE}
time <- format(Sys.time(), "%a %b %c %X %Y")
rand <- rnorm(1)
```

The current time is `r time`. My favoriate random number is `r rand`.

Let's first simulate some data.
```{r simulatedata, echo=TRUE}
x <- rnorm(100)
y <- x + rnorm(100, sd = 0.5)
```

Here is a scatterplot of the data.
```{r scatterplot of the data, fig.height=4}
par(mar = c(5, 4, 1, 1), las = 1)
plot(x, y, main = "My Simulated Data")
```
