FROM node:18-alpine

WORKDIR /app
RUN npm i -g openclaw --no-fund --no-audit

COPY config/openclaw.json /root/.openclaw/openclaw.json
COPY skills /root/.openclaw/skills
COPY .env.example /root/.openclaw/.env.example

ENV HOME=/root
ENV OPENCLAW_CONFIG=/root/.openclaw/openclaw.json

CMD ["sh", "-c", "openclaw gateway start --config $OPENCLAW_CONFIG"]
