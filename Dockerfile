FROM nvidia/cuda:11.4.0-cudnn8-devel-ubuntu20.04

ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt install -y wget

# Prepare the global python environment
RUN apt install -y python3.8
RUN apt install -y python3-dev
RUN ln -sf /usr/bin/python3.8 /usr/bin/python
RUN apt install -y pip


# for opencv
RUN apt-get install -y libglib2.0-0 libsm6 libxrender1 libxext6 libgl1

# Install other tools
RUN apt install -y \
    rsync \
    git \
    libsm6  \
    libxext-dev \
    libxrender1 \
    unzip \
    cmake \
    libxml2 libxml2-dev libxslt1-dev \
    dirmngr gnupg2 lsb-release \
    xvfb kmod swig patchelf \
    libopenmpi-dev  libcups2-dev \
    libssl-dev  libosmesa6-dev \
    mesa-utils

# Clean up to make the resulting image smaller
RUN  rm -rf /var/lib/apt/lists/*

RUN cd /root/ && git clone https://github.com/HorizonRobotics/alf \
    && cd alf && git checkout origin/seditor_alf -B seditor \
    && pip install -e .

RUN cd /root/ && \
    git clone https://github.com/hnyu/safety-gym.git && \
    pip install -e safety-gym

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

###### Download and setup MuJoCo C library #######
RUN wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz \
    && mkdir -p /root/.mujoco \
    && tar -xzvf mujoco210-linux-x86_64.tar.gz -C /root/.mujoco \
    && rm -f mujoco210-linux-x86_64.tar.gz

ENV MUJOCO_PY_MUJOCO_PATH=/root/.mujoco/mujoco210
ENV MJLIB_PATH=/root/.mujoco/mujoco210/bin/libmujoco210.so
ENV LD_LIBRARY_PATH=/root/.mujoco/mujoco210/bin:${LD_LIBRARY_PATH}

#RUN apt install -y libglew-dev
ENV PYTHONPATH=/usr/local/lib/python3.8/dist-packages:${PYTHONPATH}
# compile and build for the first time
RUN python3 -c "import mujoco_py"

# mujoco_py>=2.0.2.13 introduces the following issue on a server (local is fine):
# "Permission denied: b'/opt/usr/local/lib/python3.7/dist-packages/mujoco_py/generated/mujocopy-buildlock'"
# So we need to remove this file first
RUN rm -f /usr/local/lib/python3.8/dist-packages/mujoco_py/generated/mujocopy-buildlock


RUN cd /root/alf/alf/examples/safety && \
    git clone https://github.com/hnyu/seditor && \
    mv /root/alf/alf/examples/safety/seditor/seditor_algorithm.py /root/alf/alf/algorithms/

WORKDIR /root/alf