# https://hub.docker.com/r/library/mongo/tags/
FROM mongo:4.4.5

COPY assets /
CMD chmod 755 /*.sh

CMD /bin/bash
