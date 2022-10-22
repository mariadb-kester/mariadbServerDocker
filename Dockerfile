FROM rockylinux:9-minimal

#################################################################################
# PLEASE NOTE YOU MUST HAVE AN ENTERPRISE MARIADB LICENSE FOR THIS INSTALLATION #
#################################################################################


# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG MARIADB_SERVER_VERSION
ARG MARIADB_TOKEN
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="mariadb-server" \
      org.label-schema.description="MariaDB $MARIADB_SERVER_VERSION Server" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="Kester Riley" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      maintainer="Kester Riley <kesterriley@hotmail.com>" \
      architecture="AMD64/x86_64" \
      mariadbVersion=$MARIADB_SERVER_VERSION

RUN set -x \
    && groupadd -r mysql && useradd -r -g mysql mysql \
    && microdnf update -y \
    && microdnf install -y epel-release \
    && microdnf install -y \
      wget \
      curl \
      nmap \
      pigz \
      pv \
      iproute \
      socat \
      bind-utils \
      pwgen \
      psmisc \
      hostname \
      which \
      perl-Digest-SHA \
    && rm -rf /tmp/* \
    && mkdir /etc/my.cnf.d \
    && wget https://dlm.mariadb.com/enterprise-release-helpers/mariadb_es_repo_setup \
    && chmod +x mariadb_es_repo_setup \
    && ./mariadb_es_repo_setup --token="$MARIADB_TOKEN" --apply --mariadb-server-version="$MARIADB_SERVER_VERSION" \
    && microdnf install -y \
           MariaDB-server \
           MariaDB-client \
           galera-4 \
           MariaDB-shared \
           MariaDB-backup \
    && microdnf clean all \
    && rm -rf /var/cache/dnf

COPY bin/*.sh /usr/local/bin/
COPY my.cnf /etc/

RUN set -ex \
    && mkdir -p /etc/my.cnf.d \
    && chown -R root:root /etc/my.cnf.d \
    && chown -R root:root  /etc/my.cnf \
    && chmod -R 644 /etc/my.cnf.d \
    && chmod -R 644 /etc/my.cnf \
    && chmod -R 777 /usr/local/bin/*.sh \
    && sed -i '$d' /etc/passwd \
    && rm -rf /var/lib/mysql \
    && chmod g=u /etc/passwd \
    && find /etc/my.cnf.d/ -name '*.cnf' -print0 \
        | xargs -0 grep -lZE '^(bind-address|log)' \
        | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
    && /usr/local/bin/fix-permissions.sh /var/lib/  \
    && /usr/local/bin/fix-permissions.sh /var/run/

USER 100020100
STOPSIGNAL SIGTERM
ENTRYPOINT ["start.sh"]
