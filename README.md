# DeepSpeech x Mozilla Common Voice 2

Dockerfile to automate builds for DeepSpeech images with MCV2.

Tags currently tracking deepspeech changes (as it's faster than the MCV dataset changes). Will eventually be handled (although I've probably given myself more work when it happens).

Build on a private Jenkins server and pushed to dockerhub @ `dijksterhuis/deepspeech_mcv2:<tag>`.

Will also be building an image for [DeepSpeechAdversaries](https://github.com/dijksterhuis/DeepSpeech/)

## TODO

- Include any Jenkins build configurations here so that this can be replicated
- Automate checkout of new DeepSpeech tags
- Automate url generation for MCV2
