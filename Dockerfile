# https://hub.docker.com/r/library/mongo/tags/
FROM mongo:4.2.9

COPY assets /
CMD chmod 755 /*.sh

CMD /bin/bash
