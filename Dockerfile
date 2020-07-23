FROM alpine:3

RUN apk add curl python2

# NOTE AWS CLI v2 binaries are compiled against glibc and are currently not
# compatible with musl libc, hence we install v1 here; for more information
# see https://github.com/aws/aws-cli/issues/4685
RUN curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && rm -rf ./awscli-bundle \
    && rm -f awscli-bundle.zip
