.PHONY: all
all: nonnosus.png inferred.png

.PHONY: clean
clean:
	rm -f *.png inferred.ttl

inferred.ttl: rules.n3 nonnosus.ttl
	eye --quiet --nope $^ --pass \
	| riot --syntax ttl --formatted=ttl - \
	> $@

%.png: %.ttl
	rdf2dot $< | dot -Tpng > $@
