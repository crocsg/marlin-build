FROM python:3-slim-bookworm

RUN apt update && apt install -y curl build-essential g++ git

# Create a non-root user and group
RUN useradd -s /bin/sh -d /home/platformio -m docker
USER docker:docker

# Install PlatformIO Core
#RUN python3 -c "$(curl -fsSL https://github.com/platformio/platformio-core-installer/blob/master/get-platformio.py)"
#RUN python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
WORKDIR /tmp
RUN curl -fsSL -o /tmp/get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
RUN ls -l /tmp
RUN chmod +x /tmp/get-platformio.py
RUN python3 /tmp/get-platformio.py
ENV PATH=/home/platformio/.platformio/penv/bin/platformio:$PATH

# Clone MarlinFirmware repository, checkout latest release tag
WORKDIR /home/platformio
RUN git clone https://github.com/braillerap/MarlinBraille2.git Marlin\
  && cd Marlin/ \
  && git checkout BrailleRAP
#  && git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

COPY build-marlin.sh .
RUN pwd
RUN ls -l .
CMD ["bash", "/home/platformio/build-marlin.sh"]
