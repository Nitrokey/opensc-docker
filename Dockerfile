FROM ubuntu:rolling
LABEL Description="Image for building opensc"

RUN apt update
RUN apt install -y pcscd libccid libpcsclite-dev libssl-dev libreadline-dev autoconf automake build-essential docbook-xsl xsltproc libtool pkg-config zlib1g-dev
RUN apt install -y make wget file pinentry-tty ca-certificates lbzip2 bzip2 gcc

#ARG GPG_VERSION=2.2.3
# ENV GPG_VERSION "gnupg-$GPG_VERSION"

RUN mkdir -p /app
WORKDIR /app/
RUN wget -c https://github.com/OpenSC/OpenSC/releases/download/0.19.0/opensc-0.19.0.tar.gz
ADD build.sh /app/


RUN cd /app && make -f build.sh
ADD ./start-within-container.sh /app/

# RUN gpg -K
# COPY gpg-agent.conf /root/.gnupg/gpg-agent.conf
# COPY scdaemon.conf /root/.gnupg/scdaemon.conf

CMD ["/bin/bash", "/app/start-within-container.sh"]
