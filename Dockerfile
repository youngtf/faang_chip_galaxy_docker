# Galaxy - Faang ChIP-seq
#
# VERSION       0.1

FROM bgruening/galaxy-stable

MAINTAINER Tianfu Yang tianfu@ualberta.ca

ENV GALAXY_CONFIG_BRAND="FAANG ChIP-seq"
WORKDIR /galaxy-central

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'


#  1. Install tools
## 1.1 add configure files into the image
ADD faang_chip.yml $GALAXY_ROOT/tools.yaml

## 1.2 install tools based on the configure files 
RUN install-tools $GALAXY_ROOT/tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf

#  2. Install reference genomes

#  3. Add custom tools into the image

#  4. Add workflows to the Docker image

#  5. Sample data


# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]