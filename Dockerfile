# https://hub.docker.com/r/library/mongo/tags/
FROM mongo:5.0.2

COPY assets /
RUN chmod 755 /*.sh

CMD /bin/bash
