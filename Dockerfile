# https://hub.docker.com/r/library/mongo/tags/
FROM mongo:5.0.0

COPY assets /
CMD chmod 755 /*.sh

CMD /bin/bash
