FROM debian:jessie-slim
MAINTAINER Niels Grewe <niels.grewe@halbordnung.de>
RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  musl-tools \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/* \
  && mkdir -p /rust \
  && mkdir -p /target \
  && useradd -ms /bin/bash rusty \
  && chown -R rusty /rust \
  && chown -R rusty /target \
  && mkdir /.cargo && \
  echo "[build]\ntarget = \"x86_64-unknown-linux-musl\"" > /.cargo/config
USER rusty
WORKDIR /rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
  && /home/rusty/.cargo/bin/rustup target add x86_64-unknown-linux-musl
ENV PATH=$PATH:/home/rusty/.cargo/bin \
  USER=rusty
VOLUME /rust
VOLUME /target
ADD ibuild.rs.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
