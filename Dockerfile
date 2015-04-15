FROM meteorhacks/meteord

COPY .docker/startpeakaboo /opt/meteord/
ENTRYPOINT /opt/meteord/startpeakaboo
