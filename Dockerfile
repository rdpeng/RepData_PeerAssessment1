FROM rocker/r-ver:4.3.0

RUN install2.r rmarkdown ggplot2 dplyr lattice

WORKDIR /app

COPY . .

CMD ["Rscript", "-e", "rmarkdown::render('PA1_template.Rmd', output_dir='docs/')"]
