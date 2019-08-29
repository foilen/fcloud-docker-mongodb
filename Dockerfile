# https://hub.docker.com/r/library/mongo/tags/
FROM mongo:4.0.12

RUN export TERM=dumb ; \
  apt-get update && apt-get install -y \
    haproxy=1.6.3-1ubuntu0.2 \
    supervisor=3.2.0-2ubuntu0.2 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY assets /
CMD chmod 755 /*.sh

CMD /bin/bash
