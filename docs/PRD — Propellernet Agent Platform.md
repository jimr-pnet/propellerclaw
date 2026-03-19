\# Product Requirements Document  
\#\# Propellernet Agent Platform

\*\*Version:\*\* 1.0    
\*\*Date:\*\* 2026-03-19    
\*\*Owner:\*\* Jim Ralley    
\*\*Status:\*\* Ready to Build

\---

\#\# 1\. Overview

Build an internal AI agent platform for Propellernet that gives Sam (CEO), Gill (Ops Director), and the Client Services team intelligent, personalised AI assistants — all sharing a common memory system, skill library, and data layer.

The platform exposes itself as an MCP server, meaning any AI tool (ChatGPT, Claude Desktop, etc.) can query it for real company data, context, and skills — without users having to switch apps or copy-paste.

\*\*What it is not:\*\* A public product. A chatbot. A content tool. A replacement for ChatGPT. It's the data/memory/execution layer that makes all of those smarter.

\---

\#\# 2\. Core Principles

\- \*\*Skills are universal.\*\* All agents share one skill library. Permissions control who can use what.  
\- \*\*Memory is persistent.\*\* Context builds across sessions. Agents remember what users told them last week.  
\- \*\*MCP is the interface.\*\* Skills follow the Anthropic MCP standard. Any compatible AI can query the platform.  
\- \*\*Security by design.\*\* RLS at DB level, allowlisted integrations, approval gates for destructive actions, full audit log.  
\- \*\*Build simple, optimize later.\*\* Anthropic cloud first. Modal/Qwen fallback only if costs exceed £500-1000/month.

\---

\#\# 3\. Users & Agents

\#\#\# Agent 1: Sam (CEO)  
Strategic intelligence. Helps Sam make faster, better-informed decisions.

\*\*Slack interface:\*\* \`@sam-agent\` in Propellernet Slack

\*\*What Sam can ask:\*\*  
\- "How are we tracking this month?" → business health dashboard  
\- "Which clients need my attention?" → retention risk analysis  
\- "What's happening in the market this week?" → competitive intel brief  
\- "Prep me for Thursday's board meeting" → auto-generated meeting pack  
\- "Research agent readiness market for our pitch" → spawns research subagent

\*\*Skill permissions:\*\*  
\`\`\`yaml  
allowed: \[business-health/\*, client-intelligence/\*, market-intel/\*, meeting-prep/\*, research-support/\*, project-health/\*, team-utilization/\*\]  
blocked: \[task-management/\*\]  
\`\`\`

\---

\#\#\# Agent 2: Gill (Operations Director)  
Operational oversight. Keeps projects and people running smoothly.

\*\*Slack interface:\*\* \`@gill-agent\` in Propellernet Slack

\*\*What Gill can ask:\*\*  
\- "Who's overloaded this week?" → team capacity dashboard  
\- "What projects need intervention?" → red/amber/green project status  
\- "What's urgent today?" → delivery risk alerts  
\- "Where are we losing time?" → process optimization analysis  
\- "Generate this week's ops report" → spawns reporting subagent

\*\*Skill permissions:\*\*  
\`\`\`yaml  
allowed: \[team-utilization/\*, project-health/\*, delivery-alerts/\*, weekly-digest/\*, task-management/\*, client-intelligence/\*\]  
blocked: \[research-support/\*\]  
\`\`\`

\---

\#\#\# Agent 3: Client Services (StatusBot Migration)  
Task management, call processing, status emails. Migrates existing StatusBot.

\*\*Slack interface:\*\* \`@status-bot\` (existing interface preserved)

\*\*What the team can do:\*\*  
\- "Add task for Client X: review landing page, Sarah, due Friday"  
\- Paste transcript → action items extracted automatically  
\- "Draft this week's status email for Client Y"  
\- "What's outstanding for Client Z?"

\*\*Skill permissions:\*\*  
\`\`\`yaml  
allowed: \[task-management/\*, call-processing/\*, status-emails/\*, client-intelligence/\*\]  
blocked: \[business-health/\*, market-intel/\*\]  
\`\`\`

\---

\#\# 4\. Architecture

\#\#\# Repository Structure

\`\`\`  
propellernet-agent-platform/          \# Private GitHub repo  
│  
├── agents/                           \# Agent configs (permissions only)  
│   ├── sam-ceo/  
│   │   └── config.yaml  
│   ├── gill-ops/  
│   │   └── config.yaml  
│   └── client-services/  
│       └── config.yaml  
│  
├── skills/                           \# UNIVERSAL SKILL POOL  
│   ├── business-health/  
│   │   ├── dashboard.py              \# MCP Tool  
│   │   ├── process.md                \# SOP  
│   │   └── SKILL.md                  \# Metadata  
│   ├── client-intelligence/  
│   │   ├── risk-analysis.py  
│   │   ├── growth-opportunities.py  
│   │   └── process.md  
│   ├── market-intel/  
│   │   ├── competitor-watch.py  
│   │   ├── news-monitor.py  
│   │   └── briefing-template.md      \# Prompt template  
│   ├── team-utilization/  
│   │   └── capacity-check.py  
│   ├── project-health/  
│   │   └── status-check.py  
│   ├── delivery-alerts/  
│   │   └── risk-scanner.py  
│   ├── task-management/  
│   │   ├── add-task.py  
│   │   └── check-overdue.py  
│   ├── call-processing/  
│   │   └── extract-actions.py  
│   ├── status-emails/  
│   │   └── generate-email.py  
│   ├── meeting-prep/  
│   │   └── generate-deck.py  
│   ├── weekly-digest/  
│   │   └── compile-summary.py  
│   └── research-support/  
│       └── market-research.py  
│  
├── shared/                           \# Shared infrastructure  
│   ├── memory/  
│   │   └── memory\_system.py          \# Supabase memory API  
│   ├── data-sources/  
│   │   ├── ga4.py  
│   │   ├── xero.py  
│   │   ├── pm-tool.py  
│   │   └── slack.py  
│   ├── middleware/  
│   │   ├── approval\_gates.py         \# Destructive action confirmation  
│   │   ├── audit\_log.py              \# Every skill call logged  
│   │   └── permission\_check.py       \# Skill access enforcement  
│   └── utils/  
│       ├── email\_formatter.py  
│       └── date\_parser.py  
│  
├── mcp\_server.py                     \# Main MCP server entrypoint  
├── config/  
│   ├── allowed-integrations.yaml     \# Integration allowlist  
│   └── subagent-limits.yaml          \# Per-user subagent controls  
│  
├── scripts/  
│   ├── setup-supabase.sql            \# Full DB schema  
│   └── SETUP-INSTRUCTIONS.md  
│  
├── .env.example                      \# Template (no real secrets)  
├── .gitignore                        \# .env always excluded  
├── requirements.txt  
└── README.md  
\`\`\`

\#\#\# Three Skill Types

\*\*1. Code Skills (MCP Tools)\*\* — Python following Anthropic MCP standard:  
\`\`\`python  
from mcp import Tool

@Tool(  
    name="check\_client\_risks",  
    description="Check which clients need attention",  
    input\_schema={  
        "type": "object",  
        "properties": {  
            "severity": {"type": "string", "enum": \["all", "high", "critical"\]}  
        }  
    }  
)  
def check\_client\_risks(severity="all"):  
    \# Pull data, analyze, return  
    return risk\_report  
\`\`\`

\*\*2. Process Skills (SOPs)\*\* — Markdown workflows:  
\`\`\`markdown  
\# Client Health Evaluation Process  
\#\# Steps  
1\. Pull GA4 metrics (last 30 days vs prior 30\)  
2\. Check Google Ads performance  
3\. Review StatusBot task completion rate  
4\. Score each signal (traffic, conversion, engagement, sentiment)  
5\. Generate recommendations  
6\. Store results in memory  
\`\`\`

\*\*3. Prompt Skills (Templates)\*\* — Reusable prompt formats:  
\`\`\`markdown  
\# Weekly Market Intelligence Brief  
\#\# Audience: Sam (CEO)  
\#\# Structure: Top 3 signals \+ Competitor activity \+ Opportunity scan  
\#\# Max 600 words. Lead with insight, not chronology.  
\`\`\`

\---

\#\# 5\. Memory System

\#\#\# Database: Supabase (PostgreSQL \+ pgvector)

\*\*Tables:\*\*

\*\*\`memories\`\*\* — Per-user facts, decisions, observations, conversation history  
\`\`\`sql  
CREATE TABLE memories (  
  id UUID PRIMARY KEY DEFAULT uuid\_generate\_v4(),  
  user\_id TEXT NOT NULL,              \-- sam, gill, client-services  
  memory\_type TEXT NOT NULL,          \-- fact, decision, observation, conversation  
  content TEXT NOT NULL,  
  embedding VECTOR(1536),             \-- semantic search  
  metadata JSONB DEFAULT '{}',  
  source TEXT,                        \-- slack, agent-session, statusbot  
  created\_at TIMESTAMPTZ DEFAULT NOW(),  
  accessed\_at TIMESTAMPTZ,  
  access\_count INT DEFAULT 0  
);  
\`\`\`

\*\*\`shared\_context\`\*\* — Cross-user intelligence (client data, project insights)  
\`\`\`sql  
CREATE TABLE shared\_context (  
  id UUID PRIMARY KEY DEFAULT uuid\_generate\_v4(),  
  context\_key TEXT NOT NULL,          \-- client:acme, project:website-rebuild  
  context\_type TEXT NOT NULL,         \-- client, project, team, insight  
  content TEXT NOT NULL,  
  embedding VECTOR(1536),  
  visible\_to TEXT\[\] DEFAULT '{}',     \-- \[sam, gill, client-services\]  
  metadata JSONB DEFAULT '{}',  
  created\_at TIMESTAMPTZ DEFAULT NOW()  
);  
\`\`\`

\*\*\`user\_todos\`\*\* — Per-user task management (Sam's tasks ≠ Gill's tasks)  
\`\`\`sql  
CREATE TABLE user\_todos (  
  id UUID PRIMARY KEY DEFAULT uuid\_generate\_v4(),  
  user\_id TEXT NOT NULL,  
  content TEXT NOT NULL,  
  status TEXT DEFAULT 'open',         \-- open, in-progress, done, blocked  
  priority TEXT,                      \-- low, medium, high  
  due\_date DATE,  
  metadata JSONB DEFAULT '{}',  
  created\_at TIMESTAMPTZ DEFAULT NOW(),  
  completed\_at TIMESTAMPTZ  
);  
\`\`\`

\*\*\`observations\`\*\* — Agent-detected patterns, anomalies, opportunities  
\`\`\`sql  
CREATE TABLE observations (  
  id UUID PRIMARY KEY DEFAULT uuid\_generate\_v4(),  
  observer TEXT NOT NULL,  
  observation\_type TEXT NOT NULL,     \-- pattern, anomaly, insight, risk, opportunity  
  content TEXT NOT NULL,  
  embedding VECTOR(1536),  
  confidence FLOAT,  
  related\_memories UUID\[\],  
  acted\_on BOOLEAN DEFAULT FALSE,  
  metadata JSONB DEFAULT '{}',  
  created\_at TIMESTAMPTZ DEFAULT NOW()  
);  
\`\`\`

\*\*\`audit\_log\`\*\* — Every skill call, with user \+ inputs  
\`\`\`sql  
CREATE TABLE audit\_log (  
  id UUID DEFAULT uuid\_generate\_v4(),  
  user\_id TEXT NOT NULL,  
  action TEXT NOT NULL,  
  skill TEXT NOT NULL,  
  input JSONB,  
  output\_summary TEXT,  
  approved\_by TEXT,  
  created\_at TIMESTAMPTZ DEFAULT NOW()  
);  
\`\`\`

\*\*RLS on every table.\*\* Users only see their own data. Shared context scoped by \`visible\_to\` array. Service role key only used server-side.

\#\#\# Memory Python API

\`\`\`python  
from propellernet\_memory import MemorySystem

memory \= MemorySystem(  
    supabase\_url=os.getenv('SUPABASE\_URL'),  
    supabase\_key=os.getenv('SUPABASE\_SERVICE\_KEY'),  
    user\_id='sam'  
)

\# Store a fact  
memory.store(type='fact', content='Client Acme budget: £5k/month', metadata={'client': 'acme'})

\# Semantic search  
results \= memory.search('Acme budget decisions', limit=5)

\# Load context for prompt injection  
context \= memory.load\_context(scope=\['client:acme', 'recent:7days'\])

\# Get patterns (observations)  
patterns \= memory.get\_observations(observation\_type='pattern', limit=10)  
\`\`\`

\---

\#\# 6\. MCP Server

The platform exposes itself as an MCP server. Sam/Gill can add it to Claude Desktop or any MCP-compatible tool and query company data directly.

\#\#\# MCP Tools (complete list)

\*\*Sam:\*\*  
\- \`get\_business\_health()\` — revenue, retention, pipeline, utilization, cashflow  
\- \`check\_client\_risks(severity)\` — at-risk clients with reasons  
\- \`get\_market\_intel(days)\` — competitor moves, opportunities  
\- \`search\_memory(query, type, limit)\` — semantic search across Sam's memories

\*\*Gill:\*\*  
\- \`check\_team\_capacity()\` — who's over/under-allocated  
\- \`get\_project\_status(filter)\` — red/amber/green projects  
\- \`check\_delivery\_risks()\` — deadline \+ resource issues  
\- \`search\_memory(query, type, limit)\` — semantic search across Gill's memories

\*\*Client Services:\*\*  
\- \`get\_client\_tasks(client)\` — all tasks for a client  
\- \`add\_task(client, description, owner, due\_date)\` — add to StatusBot  
\- \`process\_transcript(transcript)\` — extract action items  
\- \`generate\_status\_email(client)\` — draft weekly status email

\*\*Universal:\*\*  
\- \`search\_shared\_context(query, limit)\` — shared company knowledge  
\- \`get\_observations(pattern\_type)\` — agent-detected patterns

\#\#\# Claude Desktop Config (per user)

\`\`\`json  
{  
  "mcpServers": {  
    "propellernet": {  
      "command": "python3",  
      "args": \["/path/to/mcp\_server.py"\],  
      "env": {  
        "SUPABASE\_URL": "https://\[project\].supabase.co",  
        "SUPABASE\_SERVICE\_KEY": "\[key\]",  
        "USER\_ID": "sam"  
      }  
    }  
  }  
}  
\`\`\`

\---

\#\# 7\. Subagent Architecture

Complex tasks spawn background subagents (research, reporting, multi-project audits).

\#\#\# Config (per user)

\`\`\`yaml  
\# config/subagent-limits.yaml  
sam:  
  enabled: true  
  maxConcurrent: 3  
  timeoutSeconds: 1800          \# 30 min auto-kill  
  model: claude-sonnet-4-5      \# faster/cheaper for background

gill:  
  enabled: true  
  maxConcurrent: 3  
  timeoutSeconds: 1800

client-services:  
  enabled: true  
  maxConcurrent: 2  
  timeoutSeconds: 600           \# 10 min for simpler tasks  
\`\`\`

\#\#\# Flow

1\. Sam: "Research agent readiness market for our pitch"  
2\. Agent spawns research subagent with task brief  
3\. Subagent runs (web search, synthesis, formatting)  
4\. Completion signal → Slack message to Sam: "Research complete"  
5\. Sam can ask follow-up questions; subagent context is available

\---

\#\# 8\. Security

\#\#\# Infrastructure Isolation

\`\`\`  
Your Railway account  
├── Other Propellernet apps (existing — untouched)  
└── propellernet-agent-platform  ← NEW PROJECT  
      ├── mcp-server (container)  
      └── skills-runner (container)  
\`\`\`

Separate Railway project \= isolated networking. Agent containers cannot see or call other Propellernet services.

Separate Supabase project. Separate Anthropic API key with monthly spend cap.

\#\#\# Secrets Management

All secrets in GitHub Secrets. Never in code. \`.env\` always in \`.gitignore\`.

\`\`\`  
GitHub Secrets  
├── SUPABASE\_URL  
├── SUPABASE\_SERVICE\_KEY  
├── ANTHROPIC\_API\_KEY  
├── SLACK\_BOT\_TOKEN  
├── SLACK\_SIGNING\_SECRET  
└── OPENAI\_API\_KEY         \# for embeddings only  
\`\`\`

\#\#\# Integration Allowlist

\`\`\`yaml  
\# config/allowed-integrations.yaml  
integrations:  
  allowed:  
    \- supabase  
    \- slack  
    \- google-analytics      \# read-only, specific property  
    \- xero                  \# read-only  
    \- pm-tool               \# read-only  
  blocked\_patterns:  
    \- "\*-admin"  
    \- "google-drive"  
    \- "gmail"  
    \- "github"  
\`\`\`

Adding any integration requires a code change \+ PR. Cannot be done at runtime.

\#\#\# Approval Gates

\`\`\`python  
REQUIRES\_APPROVAL \= \[  
    "send\_email",  
    "post\_to\_public\_channel",  
    "update\_xero",  
    "update\_pm\_tool",  
    "delete\_\*",  
\]  
\`\`\`

Anything in this list triggers a Slack confirmation button before execution. Times out after 10 minutes (does nothing if no response).

\#\#\# What Agents Cannot Do (enforced by architecture)

| Action | Why Blocked |  
|--------|-------------|  
| Access Jim's personal files | Different machine entirely |  
| Read Jim's calendar | No Google Calendar OAuth configured |  
| Access Jim's personal Supabase | Different project, different keys |  
| Run arbitrary shell commands | MCP tools only, no exec |  
| Access other Railway apps | Separate project, isolated network |  
| Escalate privileges | Non-root container, no sudo |  
| Add new integrations at runtime | Allowlist hardcoded |  
| Bypass approval gates | Enforced in middleware, not per-skill |

\---

\#\# 9\. Infrastructure Stack

| Layer | Tech | Why |  
|-------|------|-----|  
| Runtime | Railway | Simple deploy, isolated containers, auto-scale |  
| Database | Supabase | PostgreSQL \+ pgvector, RLS, real-time, managed |  
| AI model | Anthropic (Claude Sonnet) | Best tool use, quality, reliability |  
| Embeddings | OpenAI ada-002 | 1536 dims, fast, cheap, proven |  
| Source of truth | GitHub (private repo) | Version control, secrets, branch protection |  
| User interface | Slack | Where the team already works |  
| MCP | Python MCP SDK | Anthropic standard, compatible with Claude/ChatGPT |

\*\*Cost optimization trigger:\*\* If Anthropic costs exceed £500-1000/month, route routine tasks (extraction, report generation) to Modal \+ Qwen 7B. Keep Anthropic for strategic reasoning and user-facing quality-critical tasks.

\---

\#\# 10\. Build Phases

\#\#\# Phase 1: Foundation \+ StatusBot Migration (Week 1-2)

\*\*Goal:\*\* Prove the platform works with something that already exists.

\*\*Tasks:\*\*  
\- \[ \] Create Railway project (separate from other Propellernet apps)  
\- \[ \] Create Supabase project, run schema (\`scripts/setup-supabase.sql\`)  
\- \[ \] Set up GitHub repo (private, branch protection enabled)  
\- \[ \] Add all secrets to GitHub Secrets  
\- \[ \] Build \`shared/memory/memory\_system.py\` — Supabase memory API  
\- \[ \] Build \`mcp\_server.py\` — basic MCP server skeleton  
\- \[ \] Audit existing StatusBot codebase  
\- \[ \] Migrate StatusBot skills into \`skills/task-management/\`, \`skills/call-processing/\`, \`skills/status-emails/\`  
\- \[ \] Wire up Slack bot (preserve existing \`@status-bot\` interface)  
\- \[ \] Deploy to Railway  
\- \[ \] Test: team uses StatusBot via new platform (no regression)

\*\*Success:\*\* StatusBot working through new platform. Team doesn't notice any change.

\---

\#\#\# Phase 2: Gill's Agent (Week 3-4)

\*\*Goal:\*\* Prove operational value with real data.

\*\*Tasks:\*\*  
\- \[ \] Get credentials for PM tool (read-only)  
\- \[ \] Build \`skills/team-utilization/capacity-check.py\`  
\- \[ \] Build \`skills/project-health/status-check.py\`  
\- \[ \] Build \`skills/delivery-alerts/risk-scanner.py\`  
\- \[ \] Build \`skills/weekly-digest/compile-summary.py\`  
\- \[ \] Wire up \`@gill-agent\` in Slack  
\- \[ \] Connect StatusBot data to Gill's agent (shared context layer)  
\- \[ \] Test: Gill asks "What projects need intervention?" — gets accurate answer  
\- \[ \] Set up automated Monday morning delivery risk Slack message

\*\*Success:\*\* Gill saves 2+ hours/week on manual ops checks.

\---

\#\#\# Phase 3: Sam's Agent (Week 5-8)

\*\*Goal:\*\* Strategic intelligence that changes how Sam makes decisions.

\*\*Tasks:\*\*  
\- \[ \] Get credentials: Xero (read-only), GA4, Google Ads, Search Console  
\- \[ \] Build \`skills/business-health/dashboard.py\`  
\- \[ \] Build \`skills/client-intelligence/risk-analysis.py\`  
\- \[ \] Build \`skills/market-intel/news-monitor.py\` \+ \`competitor-watch.py\`  
\- \[ \] Build \`skills/meeting-prep/generate-deck.py\`  
\- \[ \] Build \`skills/research-support/market-research.py\`  
\- \[ \] Wire up \`@sam-agent\` in Slack  
\- \[ \] Configure MCP server for Sam's Claude Desktop  
\- \[ \] Test: Sam asks "Which clients need my attention?" — gets accurate risk analysis  
\- \[ \] Set up automated Friday afternoon strategic brief

\*\*Success:\*\* Sam makes one strategic decision faster or better because of agent intel.

\---

\#\# 11\. Credentials Needed (To Get From Propellernet)

Before build starts, collect:

| System | Access Needed | Who To Ask |  
|--------|--------------|------------|  
| Xero | Read-only API key | Finance |  
| PM Tool (ClickUp/Asana/Monday?) | Read-only API key | Gill |  
| GA4 | Read-only, all properties | Digital team |  
| Google Ads | Read-only MCC access | Paid media team |  
| Search Console | Read-only | SEO team |  
| Slack | Admin can create app | IT / Sam |  
| StatusBot | Source code \+ current backend | Existing owner |

\---

\#\# 12\. Definition of Done

\#\#\# Phase 1 (StatusBot)  
\- \[ \] All existing StatusBot commands work through new platform  
\- \[ \] Zero regressions for client services team  
\- \[ \] Memory system storing and retrieving facts correctly  
\- \[ \] Audit log capturing all skill calls

\#\#\# Phase 2 (Gill)  
\- \[ \] \`@gill-agent\` deployed in Slack  
\- \[ \] Capacity check returns accurate data from PM tool  
\- \[ \] Project health shows red/amber/green with correct status  
\- \[ \] Automated Monday delivery risk alert firing  
\- \[ \] Cross-agent: StatusBot data visible in Gill's risk assessments

\#\#\# Phase 3 (Sam)  
\- \[ \] \`@sam-agent\` deployed in Slack  
\- \[ \] MCP server working with Sam's Claude Desktop  
\- \[ \] Business health dashboard pulling from Xero \+ PM tool  
\- \[ \] Client risk analysis pulling from GA4 \+ Ads  
\- \[ \] At least one strategic decision improved because of agent intel

\#\#\# Security (all phases)  
\- \[ \] All secrets in GitHub Secrets (zero in code)  
\- \[ \] RLS enabled and tested on all Supabase tables  
\- \[ \] Approval gates tested for destructive actions  
\- \[ \] Audit log verified for every skill call  
\- \[ \] Railway project confirmed isolated from other apps  
\- \[ \] Integration allowlist configured and tested

\---

\#\# 13\. Non-Goals (v1)

\- No public-facing product  
\- No email integration (not in allowlist v1)  
\- No Google Drive integration (not in allowlist v1)  
\- No real-time financial reporting (Xero \= read-only, periodic)  
\- No multi-tenant (single agency, multiple users)  
\- No mobile app  
\- No local model deployment (Qwen/Modal \= Phase 2 cost optimization only)

\---

\#\# 14\. Open Questions (To Resolve Before Build)

1\. \*\*StatusBot:\*\* What's the current tech stack? Google Sheets backend confirmed — what else?  
2\. \*\*PM Tool:\*\* Which tool does Propellernet use (ClickUp, Asana, Monday, Linear)?  
3\. \*\*Slack:\*\* Does Propellernet have a paid Slack plan (needed for some app features)?  
4\. \*\*Xero:\*\* Is Xero the accounting system? Who has API access?  
5\. \*\*Sam's priorities:\*\* Which skills are most valuable to Sam in Month 1?  
6\. \*\*Gill's priorities:\*\* What's the most painful manual ops task today?

\---

\*This PRD is the single source of truth for the build. All architectural decisions, security rules, and build phases are documented here. Reference this when briefing Claude Code.\*

\---

\*\*Document locations:\*\*  
\- Local: \`\~/.openclaw/workspace/projects/propellernet-agent/PRD.md\`  
\- Drive: https://drive.google.com/drive/folders/1DGh9nat3aeu59ENuPF6lYku4DvWfrDXF

Created: 2026-03-19 | Owner: Jim Ralley  
