ARG GO_VER=1.17
ARG GOSEC_VER=v2.9.5

FROM golang:${GO_VER}

COPY docker-archive-keyring.gpg /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bullseye stable" > /etc/apt/sources.list.d/docker.list \
  && apt-get update && apt-get install -y \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-compose \
    git \
    npm \
  && rm -rf /var/lib/apt/lists/*

RUN npm install snyk@latest -g

RUN curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $(go env GOPATH)/bin ${GOSEC_VER}
