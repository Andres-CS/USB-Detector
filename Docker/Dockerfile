FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y autoconf && apt-get clean && rm -rf /var/lib/apt-get/lists/*


RUN git clone https://gitlab.com/palisade/palisade-release.git && cd palisade-release && git submodule sync --recursive && git submodule update --init  --recursive

RUN mkdir build && cd build && cmake ..

RUN make && make install && make testall
