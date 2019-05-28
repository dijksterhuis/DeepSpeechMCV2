FROM tensorflow/tensorflow:latest-gpu-py3

RUN apt update && apt upgrade -y
RUN apt install -y git wget

RUN mkdir -p /DeepSpeech /model /data/mcv2

RUN cd /data \
        && wget -b -O /data/en.tar.gz \
        https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-1/en.tar.gz

RUN cd /data && tar xvzf en.tar.gz

RUN git clone https://github.com/mozilla/DeepSpeech /DeepSpeech

RUN cd /DeepSpeech \
	&& git pull origin v0.5.0-alpha.10 \
	&& git checkout v0.5.0-alpha.10

RUN python3 -u \
	/DeepSpeech/bin/import_cv2.py \
	/data/mcv2/

RUN python3 \
	/DeepSpeech/util/check_characters.py \
	--csv-files \
	/data/mcv2/test.tsv \
	/data/mcv2/train.tsv \
	/data/mcv2/dev.tsv > /model/alphabet.txt

ENTRYPOINT /bin/bash
