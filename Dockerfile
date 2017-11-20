FROM ubuntu:16.04
MAINTAINER Sean Demura

# Update and install Curl
RUN apt-get update && \
    apt-get install -y curl

# Install salt
RUN curl -L https://bootstrap.saltstack.com | sh -s -- stable

# Clear some caches
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/*

# RUN echo "file_client: local" > /etc/salt/minion.d/masterless.conf
ADD masterless.conf /etc/salt/minion.d/masterless.conf
RUN service salt-minion restart

CMD ["/bin/bash"]
