FROM python:3.10

ARG REPO_DIR
ARG COMMAND
WORKDIR ${REPO_DIR}

RUN echo "$(pwd)"
RUN pip install AutoTransform
RUN pip install autotransform/requirements.txt

CMD ./autotransform/run_autotransform.sh ${COMMAND}