"""Propellernet MCP Server — exposes company skills and data to OpenClaw agents."""

import os

from dotenv import load_dotenv
from mcp.server.fastmcp import FastMCP

load_dotenv()

mcp = FastMCP(
    "Propellernet",
    description="Internal skills and data for Propellernet agents",
)

# Import skills to register them with the server
from skills import ping  # noqa: F401, E402


if __name__ == "__main__":
    mcp.run(transport="sse", host="0.0.0.0", port=8080)
