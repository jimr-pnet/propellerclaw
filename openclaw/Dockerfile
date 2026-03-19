FROM ghcr.io/openclaw/openclaw:latest

USER root

# Copy our config and agent definitions into the container
COPY openclaw.json /home/node/.openclaw/openclaw.json
COPY agents/ /home/node/.openclaw/agents/
COPY skills/ /home/node/.openclaw/skills/

# Ensure the node user owns everything and can write runtime dirs
RUN chown -R node:node /home/node/.openclaw

USER node

# Auto-fix config issues then start the gateway
CMD ["sh", "-c", "openclaw doctor --fix 2>/dev/null; exec openclaw gateway run"]

EXPOSE 18789
