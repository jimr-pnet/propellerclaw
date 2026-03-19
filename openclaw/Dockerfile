FROM ghcr.io/openclaw/openclaw:latest

# Copy our config and agent definitions into the container
COPY openclaw.json /home/node/.openclaw/openclaw.json
COPY agents/ /home/node/.openclaw/agents/
COPY skills/ /home/node/.openclaw/skills/

EXPOSE 18789
