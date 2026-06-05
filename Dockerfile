FROM node:18-bullseye-slim

# Install minimal packages needed and clean up
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git build-essential python3 make \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user for running OpenClaw
RUN useradd --create-home --shell /bin/bash openclaw
WORKDIR /home/openclaw

# Install OpenClaw globally
RUN npm set progress=false \
  && npm i -g openclaw --no-fund --no-audit

# Create OpenClaw config and skills directory in the container
RUN mkdir -p /home/openclaw/.openclaw/skills /home/openclaw/.openclaw/data \
  && chown -R openclaw:openclaw /home/openclaw/.openclaw

# Copy local skills and config (if present at build-time)
COPY --chown=openclaw:openclaw config/openclaw.json /home/openclaw/.openclaw/openclaw.json
COPY --chown=openclaw:openclaw skills /home/openclaw/.openclaw/skills
COPY --chown=openclaw:openclaw .env /home/openclaw/.openclaw/.env

ENV OPENCLAW_CONFIG=/home/openclaw/.openclaw/openclaw.json
ENV HOME=/home/openclaw

EXPOSE 8080

# Healthcheck: verifies the OpenClaw CLI can run and return status
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD openclaw status || exit 1

USER openclaw

# Start the gateway by default. Use docker-compose to override command for dev.
ENTRYPOINT ["openclaw", "gateway", "start", "--config", "/home/openclaw/.openclaw/openclaw.json"]

WORKDIR /home/openclaw

COPY --chown=openclaw:openclaw config/openclaw.json /home/openclaw/.openclaw/openclaw.json
COPY --chown=openclaw:openclaw skills /home/openclaw/.openclaw/skills

USER openclaw

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
	CMD openclaw --version >/dev/null 2>&1 || exit 1

ENTRYPOINT ["dumb-init", "--"]
CMD ["openclaw", "gateway", "start", "--config", "/home/openclaw/.openclaw/openclaw.json"]
