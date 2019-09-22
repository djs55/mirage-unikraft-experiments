
.PHONY: hello.xen hello.xl
hello.xen hello.xl:
	docker pull djs55/mirage-unikraft-experiments:latest
	docker run -v $(shell pwd):/output djs55/mirage-unikraft-experiments:latest cp /hello.xen /output/
	docker run -v $(shell pwd):/output djs55/mirage-unikraft-experiments:latest cp /hello.xl /output/

.PHONY: build
build:
	docker build -t djs55/mirage-unikraft-experiments:latest .

.PHONY: push
push: build
	docker push djs55/mirage-unikraft-experiments:latest

.PHONY: clean
clean:
	rm -f hello.xen hello.xl
