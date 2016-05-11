VERSION := $(shell cat package.json | jq -r '.version')

deps: README.html
	npm install

release:
	zip -r opszero-mailing-list-$(VERSION).zip index.js LandingPagePolicy.json LICENSE Makefile README.org www node_modules
	cp opszero-mailing-list-$(VERSION).zip output.zip
	curl -T opszero-mailing-list-$(VERSION).zip ftp://ftp.sendowl.com --user $(SENDOWL_FTP_USER):$(SENDOWL_FTP_PASSWORD)

README.html:
	emacs README.org --batch --eval '(org-html-export-to-html nil nil nil t)'  --kill
	echo "---" > docs.html.erb
	echo "title: Serverless Mailing List" >> docs.html.erb
	echo "layout: docs" >> docs.html.erb
	echo "---" >> docs.html.erb
	cat README.html >> docs.html.erb
	rm README.html
	mv docs.html.erb ../../acksin/acksin.com/source/solutions/serverless-mailing-list.html.erb
