-- Propellernet Agent Platform — Supabase schema
-- Run this in the Supabase SQL editor for your project.

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- =============================================================
-- Tables
-- =============================================================

-- Per-user memories (facts, decisions, observations, conversation)
CREATE TABLE memories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id TEXT NOT NULL,
    memory_type TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding VECTOR(1536),
    metadata JSONB DEFAULT '{}',
    source TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    accessed_at TIMESTAMPTZ,
    access_count INT DEFAULT 0
);

CREATE INDEX idx_memories_user_id ON memories (user_id);
CREATE INDEX idx_memories_type ON memories (user_id, memory_type);

-- Cross-user shared intelligence (client data, project insights)
CREATE TABLE shared_context (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    context_key TEXT NOT NULL,
    context_type TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding VECTOR(1536),
    visible_to TEXT[] DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_shared_context_key ON shared_context (context_key);
CREATE INDEX idx_shared_context_type ON shared_context (context_type);

-- Per-user task management
CREATE TABLE user_todos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id TEXT NOT NULL,
    content TEXT NOT NULL,
    status TEXT DEFAULT 'open',
    priority TEXT,
    due_date DATE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE INDEX idx_user_todos_user_status ON user_todos (user_id, status);

-- Agent-detected patterns, anomalies, opportunities
CREATE TABLE observations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    observer TEXT NOT NULL,
    observation_type TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding VECTOR(1536),
    confidence FLOAT,
    related_memories UUID[],
    acted_on BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_observations_type ON observations (observation_type);

-- Audit log — every skill call
CREATE TABLE audit_log (
    id UUID DEFAULT uuid_generate_v4(),
    user_id TEXT NOT NULL,
    action TEXT NOT NULL,
    skill TEXT NOT NULL,
    input JSONB,
    output_summary TEXT,
    approved_by TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_audit_log_user ON audit_log (user_id);
CREATE INDEX idx_audit_log_skill ON audit_log (skill);

-- =============================================================
-- Vector search functions
-- =============================================================

-- Semantic search across a user's memories
CREATE OR REPLACE FUNCTION search_memories(
    query_embedding VECTOR(1536),
    match_count INT DEFAULT 5,
    filter_user_id TEXT DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    user_id TEXT,
    memory_type TEXT,
    content TEXT,
    metadata JSONB,
    source TEXT,
    created_at TIMESTAMPTZ,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        m.user_id,
        m.memory_type,
        m.content,
        m.metadata,
        m.source,
        m.created_at,
        1 - (m.embedding <=> query_embedding) AS similarity
    FROM memories m
    WHERE (filter_user_id IS NULL OR m.user_id = filter_user_id)
    ORDER BY m.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- Semantic search across shared context visible to a user
CREATE OR REPLACE FUNCTION search_shared_context(
    query_embedding VECTOR(1536),
    match_count INT DEFAULT 5,
    filter_user_id TEXT DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    context_key TEXT,
    context_type TEXT,
    content TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        sc.id,
        sc.context_key,
        sc.context_type,
        sc.content,
        sc.metadata,
        sc.created_at,
        1 - (sc.embedding <=> query_embedding) AS similarity
    FROM shared_context sc
    WHERE (filter_user_id IS NULL OR filter_user_id = ANY(sc.visible_to))
    ORDER BY sc.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- =============================================================
-- Row Level Security
-- =============================================================

ALTER TABLE memories ENABLE ROW LEVEL SECURITY;
ALTER TABLE shared_context ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_todos ENABLE ROW LEVEL SECURITY;
ALTER TABLE observations ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Service role bypasses RLS (used by the MCP server).
-- These policies restrict access when using the anon key or user JWTs.

-- Memories: users can only see their own
CREATE POLICY memories_user_isolation ON memories
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true));

-- Shared context: users can see rows where they're in visible_to
CREATE POLICY shared_context_visibility ON shared_context
    FOR ALL
    USING (current_setting('app.current_user_id', true) = ANY(visible_to));

-- Todos: users can only see their own
CREATE POLICY todos_user_isolation ON user_todos
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true));

-- Observations: readable by all authenticated users
CREATE POLICY observations_read ON observations
    FOR SELECT
    USING (true);

-- Audit log: users can only see their own entries
CREATE POLICY audit_log_user_isolation ON audit_log
    FOR SELECT
    USING (user_id = current_setting('app.current_user_id', true));
