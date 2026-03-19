FROM ghcr.io/openclaw/openclaw:latest

USER root

# Copy our config and agent definitions into the container
COPY openclaw.json /home/node/.openclaw/openclaw.json
COPY agents/ /home/node/.openclaw/agents/
COPY skills/ /home/node/.openclaw/skills/

# Ensure the node user owns everything and can write runtime dirs
RUN chown -R node:node /home/node/.openclaw

USER node

EXPOSE 18789
