FROM nvidia/cuda:11.7.1-base-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y libgl1 libglib2.0-0 wget git git-lfs python3-pip python-is-python3 libcairo2-dev pkg-config python3-dev && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

ENV INDEX_URL https://mirrors.aliyun.com/pypi/simple
RUN mkdir ~/.pip && echo "[global]\nindex-url = https://mirrors.aliyun.com/pypi/simple" > ~/.pip/pip.conf
# RUN pip3 install --upgrade pip
RUN pip3 install torch torchvision torchaudio --extra-index-url https://mirrors.aliyun.com/pypi/simple
# RUN pip install xformers==0.0.20

RUN git clone -b master --depth=1 https://ghproxy.com/https://github.com/wlchn/stable-diffusion-webui.git

RUN cd stable-diffusion-webui && pip3 install -r requirements_versions.txt

RUN cd stable-diffusion-webui && pip3 install -r requirements.txt

# RUN cd stable-diffusion-webui && python3 launch.py --skip-torch-cuda-test --no-download-sd-model --no-half --use-cpu all

EXPOSE 7860

CMD cd /app/stable-diffusion-webui && python3 webui.py --listen --enable-insecure-extension-access --no-download-sd-model
