FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN useradd -m appuser
USER appuser

COPY --chown=appuser:appuser tools/ .

EXPOSE 81

CMD ["python3", "server.py"]