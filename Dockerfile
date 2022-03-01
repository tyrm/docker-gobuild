ARG GO_VER=1.17
ARG GOSEC_VER=v2.9.5

FROM golang:${GO_VER}

RUN go install github.com/goreleaser/goreleaser@latest

RUN apt-get update && apt-get install -y \
    lsb-release \
  && rm -rf /var/lib/apt/lists/*

COPY docker-archive-keyring.gpg /usr/share/keyrings/docker-archive-keyring.gpg
COPY postgres-keyring.gpg /usr/share/keyrings/postgres-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
  && echo "deb [signed-by=/usr/share/keyrings/postgres-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update && apt-get install -y \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-compose \
    git \
    npm \
    postgresql-client-14 \
  && rm -rf /var/lib/apt/lists/*

RUN npm install snyk@latest -g

RUN curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $(go env GOPATH)/bin ${GOSEC_VER}
