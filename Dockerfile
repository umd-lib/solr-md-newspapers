FROM solr:8.1.1 as builder
# Switch to root user
USER root
# Install xmlstarlet
RUN apt-get update -y && \
    apt-get install -y xmlstarlet
# Set the SOLR_HOME directory env variable
ENV SOLR_HOME=/apps/solr/data
# Create the SOLR_HOME directory and set ownership
RUN mkdir -p /apps/solr/ && \
    cp -r /opt/solr/server/solr /apps/solr/data && \
    wget --directory-prefix=/apps/solr/data/lib "https://maven.lib.umd.edu/nexus/repository/releases/edu/umd/lib/umd-solr/2.2.2-2.4/umd-solr-2.2.2-2.4.jar" && \
    wget --directory-prefix=/apps/solr/data/lib "https://maven.lib.umd.edu/nexus/repository/central/joda-time/joda-time/2.2/joda-time-2.2.jar" && \
    chown -R solr:0 "$SOLR_HOME"
# Switch back to solr user
USER solr
# Create a the md-newspapers core
RUN /opt/solr/bin/solr start && \
    /opt/solr/bin/solr create_core -c md-newspapers && \
    /opt/solr/bin/solr stop
# Replace the schema file
COPY conf /apps/solr/data/md-newspapers/conf/
# Add the data to be loaded
ADD data.csv /tmp/data.csv
# Load the data to md-newspapers core
RUN /opt/solr/bin/solr start && sleep 3 && \
    curl 'http://localhost:8983/solr/md-newspapers/update?commit=true' -H 'Content-Type: text/xml' --data-binary '<delete><query>*:*</query></delete>' && \
    curl 'http://localhost:8983/solr/md-newspapers/update/csv?commit=true&f.year_facets_list.split=true&f.year_facets_list.separator=%20' \
        --data-binary @/tmp/data.csv -H 'Content-type:text/csv; charset=utf-8' && \
    /opt/solr/bin/solr stop
# For deceasing the size of the image
FROM solr:8.1.1-slim
ENV SOLR_HOME=/apps/solr/data
USER root
RUN mkdir -p /apps/solr/ && \
    cp -r /var/solr/data /apps/solr/data && \
    chown -R solr:0 "$SOLR_HOME"
USER solr
COPY --from=builder /apps/solr/ /apps/solr/