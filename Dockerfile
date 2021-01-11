FROM ubuntu:latest

# Enviroment-Variablen
ENV PBF_URL=https://download.geofabrik.de/europe/germany/thueringen-latest.osm.pbf
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=""
ENV POSTGRES_HOST=localhost
ENV POSTGRES_PORT=5432
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt upgrade -y
RUN apt-get install -y osm2pgsql git wget

# Carto-Daten
WORKDIR /usr/local/src/
RUN git clone https://github.com/gravitystorm/openstreetmap-carto.git
RUN rm -rf /usr/local/src/openstreetmap-carto/.git

RUN apt-get purge -y git
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY run.sh /run.sh
RUN chmod a+x /run.sh

RUN useradd -s /bin/bash osm

USER osm

ENTRYPOINT ["/run.sh"]
