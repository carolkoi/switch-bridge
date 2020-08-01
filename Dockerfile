FROM postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB sla-portal
ENV POSTGRES_USER postgres
COPY newdb.sql /docker-entrypoint-initdb.d/
