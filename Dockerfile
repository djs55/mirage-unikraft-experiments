FROM ocaml/opam2:4.07

RUN git clone https://github.com/yomimono/unikraft.git -b xen-on-freestanding-on-0.3.1
RUN git clone https://github.com/yomimono/io-page.git -b xen-on-freestanding
RUN git clone https://github.com/yomimono/mirage-bootvar-xen.git -b xen-on-freestanding
RUN git clone https://github.com/djs55/mirage-xen.git -b xen-on-freestanding-pv-only
RUN git clone https://github.com/yomimono/ocb-stubblr.git -b xen-on-freestanding
RUN git clone https://github.com/yomimono/ocaml-freestanding.git -b xen-on-freestanding

RUN opam pin add -n xenplat unikraft
RUN opam pin add -n ocaml-freestanding ocaml-freestanding
RUN opam pin add -n io-page io-page
RUN opam pin add -n io-page-xen io-page
RUN opam pin add -n mirage-bootvar-xen mirage-bootvar-xen
RUN opam pin add -n mirage-xen mirage-xen
RUN opam pin add -n ocb-stubblr ocb-stubblr

RUN opam depext -i -y mirage-xen mirage-bootvar-xen ocb-stubblr
