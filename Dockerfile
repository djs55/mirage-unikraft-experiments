FROM ocaml/opam2:4.07 AS build
# add editing tools
RUN sudo apt-get install vim bash -y
# we will need the mirage configure tool
RUN opam depext -i -y mirage

RUN mkdir /home/opam/src
WORKDIR /home/opam/src
# The pins from https://github.com/mirage/mirage/issues/998
RUN git clone https://github.com/yomimono/unikraft.git -b xen-on-freestanding-on-0.3.1
RUN git clone https://github.com/yomimono/io-page.git -b xen-on-freestanding
RUN git clone https://github.com/yomimono/mirage-bootvar-xen.git -b xen-on-freestanding
RUN git clone https://github.com/djs55/mirage-xen.git -b xen-on-freestanding-pv-only
RUN git clone https://github.com/yomimono/ocb-stubblr.git -b xen-on-freestanding
RUN git clone https://github.com/djs55/ocaml-freestanding.git -b xen-on-freestanding
RUN opam pin add -n xenplat unikraft
RUN opam pin add -n ocaml-freestanding ocaml-freestanding
RUN opam pin add -n io-page io-page
RUN opam pin add -n io-page-xen io-page
RUN opam pin add -n mirage-bootvar-xen mirage-bootvar-xen
RUN opam pin add -n mirage-xen mirage-xen
RUN opam pin add -n ocb-stubblr ocb-stubblr

# For a hello world app:
RUN git clone https://github.com/mirage/mirage-skeleton

# Check the base platform installs
RUN opam depext -i -y mirage-xen mirage-bootvar-xen ocb-stubblr

WORKDIR mirage-skeleton/tutorial/hello
RUN opam exec mirage -- configure -t xen
# Remove the bad < 0.6.0 version constraint on mirage-bootvar-xen
COPY mirage-unikernel-hello-xen.opam .
RUN opam exec make depends
RUN opam exec mirage build -- -v

FROM alpine
COPY --from=build /home/opam/src/mirage-skeleton/tutorial/hello/hello.xen /
COPY --from=build /home/opam/src/mirage-skeleton/tutorial/hello/hello.xl /
