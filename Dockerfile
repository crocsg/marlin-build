FROM python:3-slim-bookworm

RUN apt update && apt install -y curl build-essential g++ git

# Create a non-root user and group
RUN useradd -s /bin/sh -d /home/platformio -m docker
USER docker:docker

# Install PlatformIO Core
#RUN python3 -c "$(curl -fsSL https://github.com/platformio/platformio-core-installer/blob/master/get-platformio.py)"
#RUN python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
WORKDIR /tmp
RUN curl -fsSL -o get-platformio.py https://github.com/platformio/platformio-core-installer/blob/master/get-platformio.py
RUN python3 -m get-platformio.py
ENV PATH=/home/platformio/.platformio/penv/bin:$PATH
ENV PATH=$PATH:$HOME/.local/bin
RUN ln -s ~/.platformio/penv/bin/platformio ~/.local/bin/platformio
RUN ln -s ~/.platformio/penv/bin/pio ~/.local/bin/pio
RUN ln -s ~/.platformio/penv/bin/piodebuggdb ~/.local/bin/piodebuggdb

# Clone MarlinFirmware repository, checkout latest release tag
WORKDIR /home/platformio
RUN git clone https://github.com/braillerap/MarlinBraille2.git Marlin\
  && cd Marlin/ \
  && git checkout BrailleRAP
#  && git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

COPY build-marlin.sh .
CMD ["bash", "/home/platformio/build-marlin.sh"]
