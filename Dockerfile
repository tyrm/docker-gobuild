ARG GO_VER=1.17
ARG GOSEC_VER=v2.9.5

FROM golang:${GO_VER}

RUN curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $(go env GOPATH)/bin ${GOSEC_VER}
