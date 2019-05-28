FROM tensorflow/tensorflow:latest-gpu-py3

RUN apt update && apt upgrade -y
RUN apt install -y git wget

RUN mkdir -p /DeepSpeech /model /data/mcv2


# Get MCV2 first as it takes circa 3 hours to download
RUN cd /data && wget https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-1/en.tar.gz
RUN cd /data && tar xvzf en.tar.gz

RUN git clone https://github.com/dijksterhuis/DeepSpeech /DeepSpeech

RUN mkdir /DeepSpeech /model /data
RUN git clone https://github.com/mozilla/DeepSpeech /DeepSpeech

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
