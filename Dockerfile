FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV OPENCLAW_HOME=/home/openclaw/.openclaw
ENV OPENCLAW_CONFIG=/home/openclaw/.openclaw/openclaw.json
ENV HOME=/home/openclaw

RUN apt-get update \
		&& apt-get install -y --no-install-recommends ca-certificates dumb-init \
		&& rm -rf /var/lib/apt/lists/* \
		&& npm i -g openclaw --no-fund --no-audit \
		&& useradd --create-home --shell /bin/bash openclaw \
		&& mkdir -p /home/openclaw/.openclaw/skills \
		&& chown -R openclaw:openclaw /home/openclaw

WORKDIR /home/openclaw

COPY --chown=openclaw:openclaw config/openclaw.json /home/openclaw/.openclaw/openclaw.json
COPY --chown=openclaw:openclaw skills /home/openclaw/.openclaw/skills

USER openclaw

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
	CMD openclaw --version >/dev/null 2>&1 || exit 1

ENTRYPOINT ["dumb-init", "--"]
CMD ["openclaw", "gateway", "start", "--config", "/home/openclaw/.openclaw/openclaw.json"]
