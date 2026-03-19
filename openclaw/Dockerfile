FROM ghcr.io/openclaw/openclaw:latest

USER root

COPY openclaw.json /home/node/.openclaw/openclaw.json
COPY agents/ /home/node/.openclaw/agents/

RUN chown -R node:node /home/node/.openclaw \
    && chmod 700 /home/node/.openclaw \
    && chmod 600 /home/node/.openclaw/openclaw.json

USER node

EXPOSE 18789 18790

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]
