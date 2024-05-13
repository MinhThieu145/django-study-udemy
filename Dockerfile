FROM python:3.11-alpine3.18
LABEL maintainer="Thieu Nguyen"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app

EXPOSE 8000

# DEV. But when you run this through the Docker Compose, it will overwrite that 
ARG DEV=false

# install dependencies and create virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps gcc libc-dev linux-headers postgresql-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    apk del .tmp-build-deps && \
    rm -rf /tmp/requirements.txt /tmp/requirements.dev.txt && \
    adduser -D -H django-user

# Environment settings to run the app as a non-root user, from our virtual environment
ENV PATH="/py/bin:$PATH"

USER django-user
