FROM tensorflow/tensorflow:latest-gpu-py3

ENV MCV2_DIR=/data/mcv2
ENV MODEL_DIR=/model
ENV SRC_DIR=/DeepSpeech

RUN apt update && apt upgrade -y
RUN apt install -y git wget

RUN mkdir -p ${SRC_DIR} \
	&& mkdir -p ${MODEL_DIR} \
	&& mkdir -p ${MCV2_DIR}

# Get MCV2 first as it takes circa 3 hours to download
RUN wget -O ${MCV2_DIR}/en.tar.gz \
	https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-1/en.tar.gz

RUN cd ${MCV2_DIR} && tar xvzf en.tar.gz

RUN git clone https://github.com/mozilla/DeepSpeech ${SRC_DIR}

RUN apt install -y sox libsox-fmt-all libsox-fmt-mp3 libsox-fmt-wav
RUN pip3 install -U -r ${SRC_DIR}/requirements.txt

RUN python3 -u \
	${SRC_DIR}/bin/import_cv2.py \
	${MCV2_DIR}

RUN python3 \
	/DeepSpeech/util/check_characters.py \
	--csv-files \
	${MCV2_DIR}/test.tsv \
	${MCV2_DIR}/train.tsv \
	${MCV2_DIR}/dev.tsv > ${MODEL_DIR}/alphabet.txt

ENTRYPOINT /bin/bash
