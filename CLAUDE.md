# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Propellerclaw (Propellernet + OpenClaw) — internal AI agent platform for Propellernet, a UK digital marketing agency. Gives team members personalised AI agents via Slack, backed by shared company data and memory.

**Owner:** Jim Ralley
**PRD:** `docs/PRD — Propellernet Agent Platform.md`

## Architecture

Two runtime components connected via MCP:

```
OpenClaw Gateway (TypeScript, Docker)
├── Agent: sam             ← CEO strategic intelligence (@sam-agent)
├── Agent: gill            ← Ops Director oversight (@gill-agent)
├── Agent: sophie          ← general-purpose, testable across roles (@sophie-agent)
├── Slack adapter          ← one Slack app per agent
├── Crons, subagents       ← full OpenClaw agent experience per user
└── MCP client ──────────→ Python MCP Server

Python MCP Server (FastMCP, Docker)
├── skills/                ← MCP tools (business-health, client-intel, etc.)
├── shared/memory.py       ← Supabase memory API with pgvector search
├── shared/supabase_client.py
└── data_sources/          ← GA4, Xero, PM tool connectors

Supabase (managed)
├── memories               ← per-user, with embeddings
├── shared_context         ← cross-user, scoped by visible_to
├── user_todos             ← per-user task management
├── observations           ← agent-detected patterns
└── audit_log              ← every skill call logged
```

**Hosting:** Railway (Pro plan). One project, two services (gateway + mcp-server) on private networking. Supabase is a separate managed project.

## Repo Structure

- `openclaw/` — OpenClaw Gateway config and agent definitions
  - `openclaw.json` — gateway config (models, Slack, MCP connection)
  - `agents/sam/SKILL.md` — Sam (CEO) agent — strategic intel, client risks, market intel
  - `agents/gill/SKILL.md` — Gill (Ops Director) agent — capacity, project health, delivery risks
  - `agents/sophie/SKILL.md` — Sophie (general-purpose) agent — testable across multiple roles
  - `skills/` — shared OpenClaw skills (markdown-based)
- `mcp-server/` — Python MCP server (the data/skills/memory layer)
  - `server.py` — FastMCP entrypoint, runs on port 8080 via SSE
  - `skills/` — Python MCP tools (each file registers tools with the server)
  - `shared/` — memory system, Supabase client
  - `data_sources/` — external API connectors
- `scripts/setup-supabase.sql` — full DB schema with RLS and vector search functions
- `docs/` — PRD and other documentation

## Development

```bash
# Local dev (both services)
docker compose up --build

# MCP server only
cd mcp-server && pip install -r requirements.txt && python server.py

# Supabase schema (run in Supabase SQL editor)
scripts/setup-supabase.sql
```

## Adding a New Skill

1. Create a file in `mcp-server/skills/` (e.g., `client_health.py`)
2. Import the `mcp` instance from `server` and decorate functions with `@mcp.tool()`
3. Import the new module in `server.py`
4. The tool is automatically available to OpenClaw agents via MCP

## Key Conventions

- **Python MCP tools** use FastMCP (`mcp.server.fastmcp.FastMCP`). Each tool is a decorated function.
- **OpenClaw skills** are markdown SKILL.md files with YAML frontmatter — they instruct the agent, not execute code.
- **Memory** uses OpenAI ada-002 embeddings (1536 dims) stored in pgvector. Search via Supabase RPC functions.
- **Secrets** go in `.env` (never committed). Railway services use env vars. Template in `.env.example`.
- **Service-to-service** communication uses Railway private networking (`mcp-server.railway.internal:8080`). In local dev, Docker networking (`mcp-server:8080`).
