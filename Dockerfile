# https://hub.docker.com/r/library/mongo/tags/
FROM mongo:5.0.2

COPY assets /
CMD chmod 755 /*.sh

CMD /bin/bash
