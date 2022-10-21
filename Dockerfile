FROM centos:centos7

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
    && yum update -y \
    && yum install -y epel-release \
    && yum install -y \
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
    && echo "99c7f4a3473a397d824d5f591274c2a4f5ebf6dc292eea154800bbaca04ddc7e mariadb_es_repo_setup" | sha256sum -c - \
    && chmod +x mariadb_es_repo_setup \
    && ./mariadb_es_repo_setup --token="$MARIADB_TOKEN" --apply --mariadb-server-version="$MARIADB_SERVER_VERSION" \
    && yum install -y \
           MariaDB-server \
           MariaDB-client \
           galera-4 \
           MariaDB-shared \
           MariaDB-backup \
    && yum clean all \
    && rm -rf /var/cache/yum

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
