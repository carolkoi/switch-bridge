FROM postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB superbridge
ENV POSTGRES_USER postgres
COPY init.sql /docker-entrypoint-initdb.d/
