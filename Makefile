default: build test

build:
	dune build @install

doc:
	dune build @doc

test:
	dune runtest

all:
	dune build @all
	dune runtest

install: build
	dune install

uninstall: all
	dune uninstall

clean:
	dune clean

headache: distclean
	headache -h .header \
		-c .headache.config \
		`find $(CURDIR)/ -type d -name .git -prune -false -o -type f`

deploy: doc test
	dune-release lint
	dune-release tag
	git push --all
	git push --tag
	dune-release

.PHONY: build doc test all uninstall clean install bench deploy
