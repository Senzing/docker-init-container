ARG BASE_IMAGE=senzing/senzing-base:1.5.2
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2020-07-07

LABEL Name="senzing/init-container" \
      Maintainer="support@senzing.com" \
      Version="1.5.5"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

RUN apt update \
 && apt -y install \
      odbc-postgresql \
 && rm -rf /var/lib/apt/lists/*

# Copy files from repository.

COPY ./rootfs /
COPY init-container.py /app

# Make non-root container.

USER 1001:1001

# Runtime execution.

WORKDIR /app
ENTRYPOINT ["/app/init-container.py"]
CMD ["initialize"]
