# Galaxy - Faang ChIP-seq
#
# VERSION       0.1

FROM bgruening/galaxy-stable:17.09

MAINTAINER Tianfu Yang tianfu@ualberta.ca

ENV GALAXY_CONFIG_BRAND="FAANG ChIP-seq"
WORKDIR /galaxy-central

# RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

#  0. Added local files
ADD faang_chip_tools.yml $GALAXY_ROOT/tools.yaml
ADD faang_chip_data.yml $GALAXY_ROOT/data.yaml
ADD ./workflow/* $GALAXY_HOME/workflows/

#  1. install tools
RUN install-tools $GALAXY_ROOT/tools.yaml > $GALAXY_ROOT/install-tools.log && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    mkdir -p $GALAXY_HOME/workflows

#  2. Add reference genomes / workflows
RUN startup_lite && \
    galaxy-wait && \
    run-data-managers --verbose --config $GALAXY_ROOT/data.yaml -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD && \
    workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD
#  3. Add custom tools into the image

#  4. Sample data


# Mark folders as imported from the host.
# VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
# EXPOSE :80
# EXPOSE :21
# EXPOSE :8800

# Autostart script that is invoked during container start
# CMD ["/usr/bin/startup"]
