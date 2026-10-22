FROM centos:centos8.4.2105

# Deny use of the compromised eMudhra intermediate CA certificates.
# This version of CentOS is no longer maintained and the repositories are
# shipping old versions of ca-certificates which trusts these certs.
# Taken from https://emudhra.we-have-a-problem.com/
RUN d=/etc/pki/ca-trust/source/blocklist; [ -d $d ] || d=/etc/pki/ca-trust/source/blacklist && \
    trust extract --overwrite --format=pem-bundle \
    --filter='pkcs11:object=Comodo%20AAA%20Services%20root;type=cert' \
    $d/Comodo_AAA_Services_root.pem && \
    trust extract --overwrite --format=pem-bundle \
    --filter='pkcs11:object=emSign%20ECC%20Root%20CA%20-%20G3;type=cert' \
    $d/emSign_ECC_Root_CA_-_G3.pem && \
    update-ca-trust

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
    dnf update -y && \
    dnf install -y \
        epel-release-8 \
        jq-1.5 \
        unzip-6.0 \
        yum-utils-4.0.21 && \
    dnf clean all

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws && \
    rm -f awscliv2.zip

RUN rpm --import http://yum-repository.platform.aws.chdev.org/RPM-GPG-KEY-platform-noarch && \
    yum-config-manager --add-repo http://yum-repository.platform.aws.chdev.org/platform-noarch.repo && \
    dnf install -y \
        platform-tools-common-1.0.6 && \
    dnf clean all
