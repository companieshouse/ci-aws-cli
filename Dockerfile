FROM alpine:3.24

RUN apk add --no-cache \
        aws-cli=2.34.63-r0 \
        bash=5.3.9-r1 \
        curl=8.22.0-r0 \
        jq=1.8.2-r0 \
        python3=3.14.8-r0
