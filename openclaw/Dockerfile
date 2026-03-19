FROM ghcr.io/openclaw/openclaw:latest

USER root

# Copy our config and agent definitions into the container
COPY openclaw.json /home/node/.openclaw/openclaw.json
COPY agents/ /home/node/.openclaw/agents/
COPY skills/ /home/node/.openclaw/skills/

# Ensure the node user owns everything and can write runtime dirs
RUN chown -R node:node /home/node/.openclaw

USER node

# Fix permissions, run doctor, then start gateway in foreground
CMD ["sh", "-c", "chmod 700 /home/node/.openclaw && chmod 600 /home/node/.openclaw/openclaw.json && openclaw doctor --fix 2>/dev/null; exec openclaw gateway run --foreground"]

EXPOSE 18789
