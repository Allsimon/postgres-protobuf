FROM namely/protoc as protobuf-compiler

WORKDIR /tmp
COPY proto/ .
RUN protoc -I=. actual_price_value.proto --descriptor_set_out=schema.pb --include_imports

FROM curlimages/curl as downloader

WORKDIR /tmp

RUN curl -L https://github.com/mpartel/postgres-protobuf/releases/download/v0.2.1/postgres-protobuf-v0.2.1-linux-x86_64-for-pg12.tar.gz -o postgres-protobuf.tar.gz
RUN tar -xvf postgres-protobuf.tar.gz

FROM postgres:12.5

# Needed to import dumps from prod
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen

COPY --from=downloader --chown=0:0 /tmp/postgres-protobuf-v0.2.1-linux-x86_64-for-pg12/lib/ /usr/lib/postgresql/12/lib/
COPY --from=downloader --chown=0:0 /tmp/postgres-protobuf-v0.2.1-linux-x86_64-for-pg12/extension/ /usr/share/postgresql/12/extension/
COPY --from=protobuf-compiler /tmp/schema.pb /tmp/schema.pb

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
