FROM python:3.9-alpine

ENV PIP_DISABLE_PIP_VERSION_CHECK="1"

WORKDIR /app
COPY ../requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install -r requirements.txt

COPY .. .

ENV FLASK_APP=./api/app.py
ENV FLASK_ENV=development

CMD [ "flask", "run", "--host", "0.0.0.0" ]
