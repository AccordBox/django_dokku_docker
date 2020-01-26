# Please remember to rename django_dokku_docker to your project directory name
FROM python:3.6-stretch

# WORKDIR sets the working directory for docker instructions, please not use cd
WORKDIR /app

EXPOSE 8000

# sets the environment variable
ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=config.settings.production \
    PORT=8000 \
    WEB_CONCURRENCY=3

# Install operating system dependencies.
RUN apt-get update -y && \
    apt-get install -y apt-transport-https rsync gettext libgettextpo-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python requirements.
COPY requirements/production.txt requirements/base.txt ./
RUN pip install -r production.txt

# Copy application code.
COPY . .

# Install assets
RUN python manage.py collectstatic --noinput --clear

# Run application
CMD gunicorn config.wsgi:application
