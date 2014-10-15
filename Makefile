SRC=.

test: $(wildcard test/test_*.tcl)
	for tcl in $^ ; do \
		TCLLIBPATH=$(SRC) tclsh $$tcl ; \
	done

.PHONY: test
