FROM ubuntu:rolling
LABEL Description="Image for running the latest Ubuntu's OpenSC"

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt install -qy make pcscd opensc opensc-pkcs11

RUN mkdir -p /app
WORKDIR /app/
ADD Makefile /app/


CMD ["/usr/bin/env", "bash"]
