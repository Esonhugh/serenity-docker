FROM golang:1.20-alpine AS builder
LABEL maintainer="nekohasekai <contact-git@sekai.icu>"
COPY . /go/src/github.com/sagernet/serenity
WORKDIR /go/src/github.com/sagernet/serenity
ARG GOPROXY=""
ENV GOPROXY ${GOPROXY}
ENV CGO_ENABLED=0
RUN go mod tidy
RUN set -ex \
    && apk add git build-base \
    && go build \
        -o /go/bin/serenity \
        ./cmd/serenity
FROM alpine AS dist
LABEL maintainer="nekohasekai <contact-git@sekai.icu>"
LABEL image_distrbutor="esonhugh <serenity-docker@eson.ninja>"
LABEL image_maintainer="esonhugh <serenity-docker@eson.ninja>"
RUN set -ex \
    && apk upgrade \
    && apk add bash tzdata ca-certificates \
    && rm -rf /var/cache/apk/*
COPY --from=builder /go/bin/serenity /usr/local/bin/serenity
# ENTRYPOINT ["serenity"]
# use CMD by default
CMD ["/usr/local/bin/serenity", "run", "-c", "/etc/serenity/serenity.json"]