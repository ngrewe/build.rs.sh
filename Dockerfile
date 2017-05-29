FROM debian:jessie-slim
MAINTAINER Niels Grewe <niels.grewe@halbordnung.de>
RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  musl-tools \
  --no-install-recommends \
  && mkdir -p /rust \
  && mkdir -p /target \
  && useradd -ms /bin/bash rusty \
  && chown -R rusty /rust \
  && chown -R rusty /target \
  && mkdir /.cargo \
  && echo "[build]\ntarget = \"x86_64-unknown-linux-musl\"" > /.cargo/config \
  && su - rusty -c "curl https://sh.rustup.rs -sSf" | su - rusty -c "sh -s -- -y" \
  && su - rusty -c "/home/rusty/.cargo/bin/rustup target add x86_64-unknown-linux-musl" \
  && rm -rf /home/rusty/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc/* \
  && apt-get remove -y curl ca-certificates \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /rust
USER rusty
ENV PATH=$PATH:/home/rusty/.cargo/bin \
  USER=rusty \
  HOME=/home/rusty
RUN mkdir -p /home/rusty/.cargo/registry \
  && chmod a+x /home/rusty/.cargo/registry \
  && chmod -R a+rw /home/rusty/.cargo/registry
VOLUME /rust
VOLUME /target
ADD ibuild.rs.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
