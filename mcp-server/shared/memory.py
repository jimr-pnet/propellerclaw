"""Memory system — store and search memories in Supabase with pgvector."""

from __future__ import annotations

import os
from typing import Any

import openai

from shared.supabase_client import get_client

_openai: openai.OpenAI | None = None


def _get_openai() -> openai.OpenAI:
    global _openai
    if _openai is None:
        _openai = openai.OpenAI(api_key=os.environ["OPENAI_API_KEY"])
    return _openai


def _embed(text: str) -> list[float]:
    """Generate an embedding vector for the given text."""
    resp = _get_openai().embeddings.create(
        model="text-embedding-ada-002",
        input=text,
    )
    return resp.data[0].embedding


class MemorySystem:
    """Per-user memory backed by Supabase + pgvector."""

    def __init__(self, user_id: str):
        self.user_id = user_id
        self.db = get_client()

    def store(
        self,
        memory_type: str,
        content: str,
        source: str = "agent-session",
        metadata: dict[str, Any] | None = None,
    ) -> dict:
        """Store a memory with its embedding."""
        embedding = _embed(content)
        row = {
            "user_id": self.user_id,
            "memory_type": memory_type,
            "content": content,
            "embedding": embedding,
            "source": source,
            "metadata": metadata or {},
        }
        result = self.db.table("memories").insert(row).execute()
        return result.data[0]

    def search(self, query: str, limit: int = 5) -> list[dict]:
        """Semantic search across this user's memories."""
        embedding = _embed(query)
        result = self.db.rpc(
            "search_memories",
            {
                "query_embedding": embedding,
                "match_count": limit,
                "filter_user_id": self.user_id,
            },
        ).execute()
        return result.data

    def store_shared_context(
        self,
        context_key: str,
        context_type: str,
        content: str,
        visible_to: list[str] | None = None,
        metadata: dict[str, Any] | None = None,
    ) -> dict:
        """Store shared context visible to specified users."""
        embedding = _embed(content)
        row = {
            "context_key": context_key,
            "context_type": context_type,
            "content": content,
            "embedding": embedding,
            "visible_to": visible_to or [],
            "metadata": metadata or {},
        }
        result = self.db.table("shared_context").insert(row).execute()
        return result.data[0]

    def search_shared_context(self, query: str, limit: int = 5) -> list[dict]:
        """Semantic search across shared context visible to this user."""
        embedding = _embed(query)
        result = self.db.rpc(
            "search_shared_context",
            {
                "query_embedding": embedding,
                "match_count": limit,
                "filter_user_id": self.user_id,
            },
        ).execute()
        return result.data
