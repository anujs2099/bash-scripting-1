FROM registry.redhat.io/ubi8/ubi-minimal

RUN microdnf install wget shadow-utils \
    && wget https://github.com/cdr/code-server/releases/download/v3.9.3/code-server-3.9.3-amd64.rpm \
    && rpm -i code-server-3.9.3-amd64.rpm \
    && rm code-server-3.9.3-amd64.rpm

ENV CODE_HOME=/home/project

RUN groupadd -r -f -g 1001 code \
    && useradd -u 1001 -r -g code -m -d ${CODE_HOME} -s /sbin/nologin code \
    && chown -R code:code ${CODE_HOME} \
    && chmod -R 755 ${CODE_HOME}

USER code

WORKDIR ${CODE_HOME}

EXPOSE 8080

ENTRYPOINT ["code-server","--auth","none"]
