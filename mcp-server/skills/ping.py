"""Ping skill — smoke test to verify the MCP server is reachable."""

from server import mcp


@mcp.tool()
def ping() -> str:
    """Check that the Propellernet MCP server is alive and responding."""
    return "pong — Propellernet MCP server is running"
