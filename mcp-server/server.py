"""Propellernet MCP Server — exposes company skills and data to OpenClaw agents."""

import os

from dotenv import load_dotenv
from mcp.server.fastmcp import FastMCP

load_dotenv()

mcp = FastMCP("Propellernet", host="0.0.0.0", port=8080)

# Register skills
from skills.ping import register as register_ping  # noqa: E402

register_ping(mcp)


if __name__ == "__main__":
    mcp.run(transport="sse")
