# grep -Po '^\S+(?=:)' Makefile | tr '\n' ' '
.PHONY: install install-dev-manjaro commit test-all test-suite

install:
	DESTDIR="$${DESTDIR:-}" ./install

# install-run-manjaro:
# 	./tools/install-run-manjaro

install-dev-manjaro:
	./tools/install-dev-manjaro

commit:
	git cz

test-all:
	./tools/zunit

test-suite:
	./tools/zunit $(u)



