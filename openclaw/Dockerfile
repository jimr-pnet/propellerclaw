FROM ghcr.io/openclaw/openclaw:latest

USER root

# Copy our config and agent definitions into the container
COPY openclaw.json /home/node/.openclaw/openclaw.json
COPY agents/ /home/node/.openclaw/agents/
COPY skills/ /home/node/.openclaw/skills/

# Fix permissions and create required dirs
RUN chown -R node:node /home/node/.openclaw \
    && chmod 700 /home/node/.openclaw \
    && chmod 600 /home/node/.openclaw/openclaw.json \
    && mkdir -p /home/node/.openclaw/agents/main/sessions \
    && chown -R node:node /home/node/.openclaw

USER node

EXPOSE 18789
