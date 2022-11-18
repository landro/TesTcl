FROM alpine:latest as build

ENV JTCL_VERSION 2.8.0
ENV JTCL_IRULE_VERSION 0.9

RUN \
  wget -q -O - https://github.com/jtcl-project/jtcl/releases/download/${JTCL_VERSION}-release/jtcl-${JTCL_VERSION}-bin.zip \
  | busybox unzip -d /opt - && \
  mv -v /opt/jtcl-${JTCL_VERSION} /opt/jtcl

ADD https://github.com/landro/jtcl-irule/releases/download/v${JTCL_IRULE_VERSION}/jtcl-irule-${JTCL_IRULE_VERSION}.jar /opt/jtcl-irule-${JTCL_IRULE_VERSION}.jar

RUN sed -i -e "s/export CLASSPATH/export CLASSPATH=\/opt\/jtcl-irule-${JTCL_IRULE_VERSION}.jar:\$CLASSPATH/g" /opt/jtcl/jtcl

COPY . /opt/TesTcl
RUN chmod -R 755 /opt/TesTcl/tests.sh /opt/jtcl/jtcl

FROM openjdk:slim

COPY --from=build /opt/ /opt/

ENV TCLLIBPATH=/opt/TesTcl
ENV PATH=/opt/jtcl:/opt/test:/app:$PATH

WORKDIR /app

CMD ["/opt/TesTcl/tests.sh", "jtcl"]