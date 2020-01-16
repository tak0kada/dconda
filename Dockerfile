FROM archlinux/base
USER root
WORKDIR /workdir

COPY build_script.sh /build/build_script.sh
RUN bash /build/build_script.sh
