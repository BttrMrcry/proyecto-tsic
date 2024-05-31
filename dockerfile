FROM python:latest

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SUPERUSER_PASSWORD=12345678
ENV DJANGO_SUPERUSER_USERNAME=user
ENV DJANGO_SUPERUSER_EMAIL=user@email.com
WORKDIR /aplicationStore