.PHONY: browse

RMDFILE = PA1_template

browse: $(RMDFILE).html
	Rscript -e "require(knitr); browseURL(paste('file://', file.path(getwd(),'$(RMDFILE).html'), sep=''))"

$(RMDFILE).html: $(RMDFILE).md
	Rscript -e "require(markdown); markdownToHTML('$(RMDFILE).md', '$(RMDFILE).html', options=c('use_xhtml', 'base64_images'))"

$(RMDFILE).md: $(RMDFILE).Rmd
	Rscript -e "require(knitr); require(markdown); knit('$(RMDFILE).Rmd', '$(RMDFILE).md')"
