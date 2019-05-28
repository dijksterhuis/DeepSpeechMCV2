FROM tensorflow/tensorflow:latest-gpu-py3

RUN apt update && apt upgrade -y
RUN apt install -y git wget

# Get MCV2 first as it takes circa 3 hours to download
RUN cd /data && wget https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-1/en.tar.gz
RUN cd /data && tar xvzf en.tar.gz

RUN mkdir /DeepSpeech /model /data
RUN git clone https://github.com/dijksterhuis/DeepSpeech /DeepSpeech

RUN mkdir /DeepSpeech /model /data
RUN git clone https://github.com/mozilla/DeepSpeech /DeepSpeech

RUN cd /DeepSpeech \
	&& git pull origin v0.5.0-alpha.10 \
	&& git checkout v0.5.0-alpha.10

RUN python3 -u \
	/DeepSpeech/bin/import_cv2.py \
	/data/

RUN python3 \
	/DeepSpeech/util/check_characters.py \
	--csv-files \
	/data/test.tsv \
	/data/train.tsv \
	/data/dev.tsv > /model/alphabet.txt

ENTRYPOINT /bin/bash
