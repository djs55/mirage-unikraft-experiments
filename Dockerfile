FROM ocaml/opam2:4.07 AS build
# add editing tools
RUN sudo apt-get install vim bash -y
# we will need the mirage configure tool
RUN opam depext -i -y mirage

RUN mkdir /home/opam/src
WORKDIR /home/opam/src
# The pins from https://github.com/mirage/mirage/issues/998
RUN git clone https://github.com/yomimono/unikraft.git -b xen-on-freestanding-on-0.3.1
RUN cd unikraft && git checkout b63be239e3d7d7ca0d850d24eef53677a54d31f1
RUN git clone https://github.com/yomimono/io-page.git -b xen-on-freestanding
RUN cd io-page && git checkout 96d3438d73e69edd754d2c4a4553c2f04365b1eb
RUN git clone https://github.com/yomimono/mirage-bootvar-xen.git -b xen-on-freestanding
RUN cd mirage-bootvar-xen && git checkout 0201e462cd363971e2e5f681c39dbedee266f0d0
RUN git clone https://github.com/djs55/mirage-xen.git -b xen-on-freestanding-pv-only
RUN cd mirage-xen && git checkout 67a345746f34a311943e7602728fd55872f79960
RUN git clone https://github.com/yomimono/ocb-stubblr.git -b xen-on-freestanding
RUN cd ocb-stubblr && git checkout ccc67341fdfe2d9ccc109db5586a79e57e3b208c
RUN git clone https://github.com/djs55/ocaml-freestanding.git -b xen-on-freestanding
RUN cd ocaml-freestanding && git checkout db10172cbfd253e615f1ba6569203ebc24ac5321
RUN opam pin add -n xenplat unikraft
RUN opam pin add -n ocaml-freestanding ocaml-freestanding
RUN opam pin add -n io-page io-page
RUN opam pin add -n io-page-xen io-page
RUN opam pin add -n mirage-bootvar-xen mirage-bootvar-xen
RUN opam pin add -n mirage-xen mirage-xen
RUN opam pin add -n ocb-stubblr ocb-stubblr

# Install the xenplat variant of ocaml-freestanding, I don't care about the others.
RUN opam depext -i -y xenplat
RUN opam depext -i -y ocaml-freestanding

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
