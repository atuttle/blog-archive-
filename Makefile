dev:
	bundle exec jekyll serve

publish:
	bundle exec jekyll build
	cd _site
	git add *
	git commit -am"autopublish by makefile"
	git push

default: dev
