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

# install dependencies

# create virtual environment
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp/requirements.txt && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user


# so that we can run the app as a non-root user, from our virtual environment, without having to run the entire path
ENV PATH="/py/bin:$PATH"

USER django-user
