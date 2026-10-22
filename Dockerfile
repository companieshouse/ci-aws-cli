FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-core-runtime:latest

# Deny use of the compromised eMudhra intermediate CA certificates.
# The AL2023 distro is already distrusting the intermediate CA, but
# still trusts the root cert.  This blacklists the required roots.
# Taken from https://emudhra.we-have-a-problem.com/
RUN d=/etc/pki/ca-trust/source/blocklist; [ -d $d ] || d=/etc/pki/ca-trust/source/blacklist \
    trust extract --overwrite --format=pem-bundle \
    --filter='pkcs11:object=Comodo%20AAA%20Services%20root;type=cert' \
    $d/Comodo_AAA_Services_root.pem && \
    trust extract --overwrite --format=pem-bundle \
    --filter='pkcs11:object=emSign%20ECC%20Root%20CA%20-%20G3;type=cert' \
    $d/emSign_ECC_Root_CA_-_G3.pem && \
    update-ca-trust

RUN dnf install -y \
        awscli-2-2.32.1 \
        dnf-utils-4.3.0 \
        gzip-1.12 \
        jq-1.7.1 \
        tar-1.34 \
        unzip-6.0 && \
    dnf clean all

RUN rpm --import http://yum-repository.platform.aws.chdev.org/RPM-GPG-KEY-platform-noarch && \
    yum-config-manager --add-repo http://yum-repository.platform.aws.chdev.org/platform-noarch.repo && \
    dnf install -y \
        platform-tools-common-1.0.6 && \
    dnf clean all
