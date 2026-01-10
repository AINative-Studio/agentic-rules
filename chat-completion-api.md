# Chat Completion API Developer Guide (BYOK)
**Building Agentic Applications with Meta LLAMA & Anthropic Claude**

Version: 1.1.0
Last Updated: January 6, 2026
Issues: #623, #624, #694

---

## Table of Contents

1. [Introduction](#introduction)
2. [Quick Start](#quick-start)
3. [Authentication](#authentication)
4. [Basic Chat Completion](#basic-chat-completion)
5. [Agentic Tool Calling](#agentic-tool-calling)
6. [Available Tools](#available-tools)
7. [Code Examples](#code-examples)
8. [Best Practices](#best-practices)
9. [Error Handling](#error-handling)
10. [Advanced Patterns](#advanced-patterns)

---

## Introduction

The Chat Completion API enables developers to build sophisticated agentic applications that combine the power of LLMs (Meta LLAMA, Anthropic Claude) with **30+ production-ready tool definitions** from the AINative ecosystem.

**Important**: This guide documents the **BYOK (Bring Your Own Key)** endpoint at `/v1/chat/completions`. You provide your own provider API keys and are billed directly by the provider.

For the **managed endpoint** with AINative credits, see the internal guide: `docs/backend/MANAGED_CHAT_API_INTERNAL_GUIDE.md`

### Key Features

✅ **Multi-Provider Support**: Meta LLAMA, Anthropic Claude
✅ **Agentic Tool Calling**: Multi-iteration workflows where LLM can request tools
✅ **30+ Tool Definitions**: ZeroDB, Git, Docker, file operations, testing, deployment, and more
✅ **Token Tracking**: Monitor usage across all iterations
✅ **Flexible Integration**: OpenAI-compatible format

**Important**: This is the BYOK (Bring Your Own Key) endpoint. Tools are passed to the LLM, which returns tool_calls. Your client must execute the tools and send results back. Server-side tool execution is planned for Issue #695.

### Use Cases

- **AI-Powered IDEs**: Code generation with git operations and testing
- **Data Analysis Agents**: Query databases, generate visualizations, store insights
- **DevOps Automation**: Deploy apps, run tests, monitor services
- **Intelligent Assistants**: Memory-backed conversational agents with persistent context
- **Research Tools**: Semantic search, document analysis, knowledge management

---

## Quick Start

### 1. Install Dependencies

```bash
pip install httpx asyncio
```

### 2. Set Environment Variables

```bash
# BYOK Mode - Provide your own provider API keys
export META_API_KEY="your-meta-llama-key"  # For Meta LLAMA
export ANTHROPIC_API_KEY="your-anthropic-key"  # For Anthropic

# Optional: JWT token for user tracking (not required for BYOK)
export JWT_TOKEN="your-jwt-token"
```

### 3. Make Your First Request

```python
import httpx
import asyncio

async def chat():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.ainative.studio/v1/chat/completions",
            headers={
                "Content-Type": "application/json",
                # Optional: Include JWT token for user tracking
                # "Authorization": "Bearer your-jwt-token"
            },
            json={
                "provider": "meta_llama",
                "model": "Llama-3.3-70B-Instruct",
                "messages": [
                    {"role": "user", "content": "Hello! What is 2+2?"}
                ],
                "temperature": 0.7,
                "max_tokens": 500
            },
            timeout=60.0
        )

        result = response.json()
        print(result["choices"][0]["message"]["content"])

asyncio.run(chat())
```

---

## Authentication

### BYOK Mode (Bring Your Own Key)

This endpoint uses **BYOK mode**, meaning you provide your own provider API keys (Meta, Anthropic) directly in the request environment. The AINative API does not charge for these requests - you're billed directly by the provider.

**Authentication is optional:**
- **Without JWT**: Requests are anonymous, no user tracking
- **With JWT**: Include `Authorization: Bearer <token>` header for user-specific tracking and analytics

```http
POST /v1/chat/completions
Content-Type: application/json
Authorization: Bearer your-jwt-token  # Optional for user tracking
```

### Provider API Keys (Required)

You must set your provider API keys in the environment where your code runs:

- **Meta LLAMA**: Set `META_API_KEY` environment variable
- **Anthropic**: Set `ANTHROPIC_API_KEY` environment variable

The endpoint forwards your requests to the provider using your keys.

---

## Basic Chat Completion

### Request Schema

```json
{
  "provider": "meta_llama",
  "model": "Llama-3.3-70B-Instruct",
  "messages": [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Hello!"}
  ],
  "temperature": 0.7,
  "max_tokens": 500,
  "stream": false
}
```

### Response Schema

```json
{
  "id": "chatcmpl-abc123",
  "model": "Llama-3.3-70B-Instruct",
  "provider": "meta_llama",
  "created": 1704585600,
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you today?"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 15,
    "completion_tokens": 10,
    "total_tokens": 25
  },
  "iterations": 1,
  "total_tokens_used": 25
}
```

### Supported Models

#### Meta LLAMA
- `Llama-4-Maverick-17B-128E-Instruct-FP8` (400B params, primary)
- `Llama-3.3-70B-Instruct` (70B params)
- `Llama-3.3-8B-Instruct` (8B params, fast)

#### Anthropic
- `claude-sonnet-4-5` (Claude 3.5 Sonnet)
- `claude-opus-4` (Claude Opus 4)

---

## Agentic Tool Calling

### Overview

Agentic tool calling enables LLMs to request function calls in a multi-iteration loop:

1. **LLM analyzes** the user request and available tools
2. **LLM returns tool_calls** with appropriate parameters
3. **Your client executes** the tools and returns results
4. **Results are sent back** to LLM for processing
5. **Loop continues** until final answer or max iterations reached

**Important**: The server does NOT execute tools. It only passes tool definitions to the LLM and returns `tool_calls` in the response. Your client code must:
- Execute the requested tools
- Send tool results back in the next API call
- Continue the loop until `finish_reason: "stop"`

Server-side tool execution is planned for Issue #695.

### Basic Tool Calling Request

```python
import httpx
import asyncio

async def chat_with_tools():
    tools = [
        {
            "type": "function",
            "function": {
                "name": "get_weather",
                "description": "Get current weather for a location",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "location": {
                            "type": "string",
                            "description": "City name"
                        }
                    },
                    "required": ["location"]
                }
            }
        }
    ]

    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.ainative.studio/v1/chat/completions",
            headers={
                "Content-Type": "application/json"
                # Optional: "Authorization": "Bearer your-jwt-token"
            },
            json={
                "provider": "meta_llama",
                "model": "Llama-3.3-70B-Instruct",
                "messages": [
                    {"role": "user", "content": "What's the weather in San Francisco?"}
                ],
                "tools": tools,
                "max_iterations": 5,
                "temperature": 0.7
            },
            timeout=120.0
        )

        result = response.json()
        print(f"Iterations: {result['iterations']}")
        print(f"Total tokens: {result['total_tokens_used']}")
        print(f"Answer: {result['choices'][0]['message']['content']}")

asyncio.run(chat_with_tools())
```

### Tool Calling Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `tools` | array | List of tool definitions | `[]` |
| `tool_choice` | string | How to choose tools (`auto`, `required`, `none`) | `auto` |
| `max_iterations` | integer | Maximum agentic loop iterations | `5` |

---

## Available Tools

**Important**: These are **tool definitions** you can pass to the LLM. The server does NOT execute these tools. The LLM will return `tool_calls` in the response, and your client code must:
1. Execute the requested tools
2. Send the results back in the next API call
3. Continue the loop until `finish_reason: "stop"`

Server-side tool execution is planned for Issue #695.

### ZeroDB Tools (15 total)

#### Database Operations

**1. Create Table**
```json
{
  "name": "zerodb_create_table",
  "description": "Create a NoSQL table in ZeroDB",
  "parameters": {
    "type": "object",
    "properties": {
      "table_name": {"type": "string"},
      "schema": {"type": "object"},
      "description": {"type": "string"}
    },
    "required": ["table_name", "schema"]
  }
}
```

**2. Insert Rows**
```json
{
  "name": "zerodb_insert_rows",
  "description": "Insert data rows into a table",
  "parameters": {
    "type": "object",
    "properties": {
      "table_name": {"type": "string"},
      "rows": {"type": "array"}
    },
    "required": ["table_name", "rows"]
  }
}
```

**3. Query Table**
```json
{
  "name": "zerodb_query_table",
  "description": "Query table data with filters",
  "parameters": {
    "type": "object",
    "properties": {
      "table_name": {"type": "string"},
      "filters": {"type": "object"},
      "limit": {"type": "integer"}
    },
    "required": ["table_name"]
  }
}
```

**4. List Tables**
```json
{
  "name": "zerodb_list_tables",
  "description": "List all available tables",
  "parameters": {
    "type": "object",
    "properties": {},
    "required": []
  }
}
```

**5. Execute SQL**
```json
{
  "name": "zerodb_execute_sql",
  "description": "Execute SQL queries",
  "parameters": {
    "type": "object",
    "properties": {
      "query": {"type": "string"}
    },
    "required": ["query"]
  }
}
```

#### Vector & Search Operations

**6. Semantic Search**
```json
{
  "name": "zerodb_semantic_search",
  "description": "Search using semantic similarity",
  "parameters": {
    "type": "object",
    "properties": {
      "query": {"type": "string"},
      "table_name": {"type": "string"},
      "limit": {"type": "integer"}
    },
    "required": ["query", "table_name"]
  }
}
```

**7. Upsert Vectors**
```json
{
  "name": "zerodb_upsert_vectors",
  "description": "Store vector embeddings",
  "parameters": {
    "type": "object",
    "properties": {
      "vectors": {"type": "array"},
      "metadata": {"type": "object"}
    },
    "required": ["vectors"]
  }
}
```

**8. Generate Embeddings**
```json
{
  "name": "zerodb_generate_embeddings",
  "description": "Generate embeddings for text",
  "parameters": {
    "type": "object",
    "properties": {
      "text": {"type": "string"},
      "model": {"type": "string"}
    },
    "required": ["text"]
  }
}
```

**9. Embed and Store**
```json
{
  "name": "zerodb_embed_and_store",
  "description": "Generate embeddings and store in one call",
  "parameters": {
    "type": "object",
    "properties": {
      "text": {"type": "string"},
      "table_name": {"type": "string"},
      "metadata": {"type": "object"}
    },
    "required": ["text", "table_name"]
  }
}
```

#### AI Memory Operations

**10. Store Memory**
```json
{
  "name": "zerodb_store_memory",
  "description": "Store agent memory for persistent context",
  "parameters": {
    "type": "object",
    "properties": {
      "agent_id": {"type": "string"},
      "memory_type": {"type": "string"},
      "content": {"type": "string"},
      "metadata": {"type": "object"}
    },
    "required": ["agent_id", "memory_type", "content"]
  }
}
```

**11. Search Memory**
```json
{
  "name": "zerodb_search_memory",
  "description": "Search agent memories semantically",
  "parameters": {
    "type": "object",
    "properties": {
      "agent_id": {"type": "string"},
      "query": {"type": "string"},
      "limit": {"type": "integer"}
    },
    "required": ["agent_id", "query"]
  }
}
```

#### Agent Operations

**12. Log Agent Activity**
```json
{
  "name": "zerodb_log_agent_activity",
  "description": "Log agent actions and decisions",
  "parameters": {
    "type": "object",
    "properties": {
      "agent_id": {"type": "string"},
      "activity_type": {"type": "string"},
      "details": {"type": "object"}
    },
    "required": ["agent_id", "activity_type"]
  }
}
```

**13. Log RLHF Feedback**
```json
{
  "name": "zerodb_log_rlhf",
  "description": "Log RLHF training feedback",
  "parameters": {
    "type": "object",
    "properties": {
      "interaction_id": {"type": "string"},
      "feedback": {"type": "string"},
      "rating": {"type": "number"}
    },
    "required": ["interaction_id", "feedback"]
  }
}
```

**14. Create Event**
```json
{
  "name": "zerodb_create_event",
  "description": "Create events in event stream",
  "parameters": {
    "type": "object",
    "properties": {
      "event_type": {"type": "string"},
      "data": {"type": "object"}
    },
    "required": ["event_type", "data"]
  }
}
```

**15. Get Project Stats**
```json
{
  "name": "zerodb_get_project_stats",
  "description": "Get project usage statistics",
  "parameters": {
    "type": "object",
    "properties": {},
    "required": []
  }
}
```

### Agent Framework Tools (15+ total)

**Note**: These are example tool definitions. Your client must implement and execute these tools when the LLM requests them.

- `bash_tool` - Execute shell commands (client-side execution)
- `file_tool` - File operations (read, write, edit)
- `git_tool` - Git operations (commit, push, branch)
- `http_tool` - HTTP requests
- `code_quality_tool` - Code analysis and linting
- `testing_tool` - Run tests (pytest, jest, etc.)
- `deployment_tool` - Deploy applications
- `docker_tool` - Docker operations
- `package_manager_tool` - NPM/pip package management
- `vector_search_tool` - Vector similarity search
- `security_scan_tool` - Security vulnerability scans
- `ui_design_tool` - UI/UX design generation
- `css_styling_tool` - CSS styling and theming
- `component_generation_tool` - Generate UI components
- `asset_management_tool` - Manage assets

See Issue #695 for server-side tool execution roadmap.

---

## Code Examples

### Example 1: Simple Chat

```python
import httpx
import asyncio

async def simple_chat():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.ainative.studio/v1/chat/completions",
            headers={"Content-Type": "application/json"},
            json={
                "provider": "meta_llama",
                "model": "Llama-3.3-70B-Instruct",
                "messages": [
                    {"role": "user", "content": "Explain quantum computing in one sentence."}
                ],
                "temperature": 0.7
            }
        )
        return response.json()

result = asyncio.run(simple_chat())
print(result["choices"][0]["message"]["content"])
```

### Example 2: Multi-Tool Agentic Workflow

```python
import httpx
import asyncio

async def agentic_data_analysis():
    tools = [
        {
            "type": "function",
            "function": {
                "name": "zerodb_create_table",
                "description": "Create a NoSQL table",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "table_name": {"type": "string"},
                        "schema": {"type": "object"}
                    },
                    "required": ["table_name", "schema"]
                }
            }
        },
        {
            "type": "function",
            "function": {
                "name": "zerodb_insert_rows",
                "description": "Insert data rows",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "table_name": {"type": "string"},
                        "rows": {"type": "array"}
                    },
                    "required": ["table_name", "rows"]
                }
            }
        },
        {
            "type": "function",
            "function": {
                "name": "zerodb_query_table",
                "description": "Query table data",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "table_name": {"type": "string"},
                        "filters": {"type": "object"}
                    },
                    "required": ["table_name"]
                }
            }
        }
    ]

    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.ainative.studio/v1/chat/completions",
            headers={"Content-Type": "application/json"},
            json={
                "provider": "meta_llama",
                "model": "Llama-3.3-70B-Instruct",
                "messages": [
                    {
                        "role": "user",
                        "content": """Create a table called 'users' with schema:
                        {id: UUID PRIMARY KEY, name: TEXT, email: TEXT}.
                        Then insert 3 sample users and query all of them."""
                    }
                ],
                "tools": tools,
                "max_iterations": 5
            },
            timeout=120.0
        )

        result = response.json()
        print(f"Iterations: {result['iterations']}")
        print(f"Total tokens: {result['total_tokens_used']}")
        print(f"Result: {result['choices'][0]['message']['content']}")

asyncio.run(agentic_data_analysis())
```

### Example 3: Memory-Backed Conversational Agent

```python
import httpx
import asyncio

class MemoryAgent:
    def __init__(self, api_key: str, agent_id: str):
        self.api_key = api_key
        self.agent_id = agent_id
        self.base_url = "https://api.ainative.studio/v1/chat/completions"

        self.tools = [
            {
                "type": "function",
                "function": {
                    "name": "zerodb_store_memory",
                    "description": "Store agent memory",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "agent_id": {"type": "string"},
                            "memory_type": {"type": "string"},
                            "content": {"type": "string"}
                        },
                        "required": ["agent_id", "memory_type", "content"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "zerodb_search_memory",
                    "description": "Search agent memories",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "agent_id": {"type": "string"},
                            "query": {"type": "string"},
                            "limit": {"type": "integer"}
                        },
                        "required": ["agent_id", "query"]
                    }
                }
            }
        ]

    async def chat(self, user_message: str):
        async with httpx.AsyncClient() as client:
            response = await client.post(
                self.base_url,
                headers={"Content-Type": "application/json"},
                json={
                    "provider": "meta_llama",
                    "model": "Llama-3.3-70B-Instruct",
                    "messages": [
                        {
                            "role": "system",
                            "content": f"You are a helpful assistant with persistent memory. Your agent ID is {self.agent_id}. Always search your memory for relevant context before answering, and store important information."
                        },
                        {"role": "user", "content": user_message}
                    ],
                    "tools": self.tools,
                    "max_iterations": 5
                },
                timeout=120.0
            )

            result = response.json()
            return result["choices"][0]["message"]["content"]

# Usage
async def main():
    agent = MemoryAgent(api_key="your-api-key", agent_id="assistant_001")

    # First conversation
    response1 = await agent.chat("My name is John and I love Python programming.")
    print(f"Agent: {response1}")

    # Later conversation - agent should remember
    response2 = await agent.chat("What programming language do I prefer?")
    print(f"Agent: {response2}")

asyncio.run(main())
```

### Example 4: Code Analysis Agent

```python
import httpx
import asyncio

async def code_analysis_agent(code: str):
    tools = [
        {
            "type": "function",
            "function": {
                "name": "bash_tool",
                "description": "Execute shell commands",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "command": {"type": "string"},
                        "cwd": {"type": "string"}
                    },
                    "required": ["command"]
                }
            }
        },
        {
            "type": "function",
            "function": {
                "name": "file_tool",
                "description": "File operations",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "operation": {"type": "string"},
                        "path": {"type": "string"},
                        "content": {"type": "string"}
                    },
                    "required": ["operation", "path"]
                }
            }
        },
        {
            "type": "function",
            "function": {
                "name": "testing_tool",
                "description": "Run tests",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "test_framework": {"type": "string"},
                        "test_path": {"type": "string"}
                    },
                    "required": ["test_framework", "test_path"]
                }
            }
        }
    ]

    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.ainative.studio/v1/chat/completions",
            headers={"Content-Type": "application/json"},
            json={
                "provider": "meta_llama",
                "model": "Llama-3.3-70B-Instruct",
                "messages": [
                    {
                        "role": "user",
                        "content": f"Analyze this code, write it to a file, create a test for it, and run the test:\n\n{code}"
                    }
                ],
                "tools": tools,
                "max_iterations": 8
            },
            timeout=180.0
        )

        return response.json()

# Usage
code = """
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
"""

result = asyncio.run(code_analysis_agent(code))
print(result["choices"][0]["message"]["content"])
```

---

## Best Practices

### 1. Set Appropriate Max Iterations

```python
# Simple tasks: 1-3 iterations
{
    "max_iterations": 3,
    "tools": [single_tool]
}

# Complex multi-step workflows: 5-8 iterations
{
    "max_iterations": 8,
    "tools": [multiple_tools]
}

# Avoid setting too high (>10) to prevent excessive costs
```

### 2. Use Descriptive Tool Definitions

```python
# ❌ Bad
{
    "name": "do_thing",
    "description": "Does something"
}

# ✅ Good
{
    "name": "zerodb_semantic_search",
    "description": "Search documents using semantic similarity. Returns top N most relevant documents based on vector embeddings. Best for finding contextually similar content."
}
```

### 3. Provide Clear Instructions

```python
# ❌ Vague
{"content": "Get weather"}

# ✅ Clear
{"content": "Use the get_weather tool to check the current weather in San Francisco, CA"}
```

### 4. Monitor Token Usage

```python
result = await chat_with_tools()

print(f"Iterations: {result['iterations']}")
print(f"Total tokens: {result['total_tokens_used']}")
print(f"Cost estimate: ${result['total_tokens_used'] * 0.00001}")
```

### 5. Handle Tool Errors Gracefully

```python
# Tools return error information in their results
# LLM receives error messages and can retry or adapt
result = response.json()

if result['finish_reason'] == 'tool_use':
    # Tool may have failed, check the content
    print("Tool execution may have errors")
```

### 6. Use System Prompts for Context

```python
{
    "messages": [
        {
            "role": "system",
            "content": "You are a DevOps automation agent. You have access to bash, git, and deployment tools. Always confirm before executing destructive operations."
        },
        {"role": "user", "content": "Deploy the latest code to staging"}
    ]
}
```

### 7. Implement Timeout Handling

```python
import httpx
import asyncio

async def chat_with_timeout():
    try:
        async with httpx.AsyncClient(timeout=120.0) as client:
            response = await client.post(...)
    except httpx.TimeoutException:
        print("Request timed out - try reducing max_iterations or using simpler tools")
```

---

## Error Handling

### Common Errors

#### 1. Tool Execution Errors

**Error**: Tool fails during execution

```json
{
  "error": "Tool execution failed: Connection refused",
  "tool_name": "zerodb_query_table",
  "status": "failed"
}
```

**Solution**: Check tool parameters, network connectivity, and API keys

#### 2. Max Iterations Exceeded

**Error**: `Maximum tool calling iterations (5) exceeded without completion`

**Solution**:
- Increase `max_iterations` if task is legitimately complex
- Simplify the user request
- Provide more specific instructions

#### 3. Invalid Tool Schema

**Error**: `422 Validation error - Invalid tool parameters`

**Solution**: Ensure tool definitions match expected schema format

```python
# Correct format
{
    "type": "function",
    "function": {
        "name": "tool_name",
        "parameters": {
            "type": "object",
            "properties": {...},
            "required": [...]
        }
    }
}
```

#### 4. Provider Not Available

**Error**: `Unsupported provider: xyz`

**Solution**: Use `meta_llama` or `anthropic` as provider

#### 5. Provider API Key Errors

**Error**: `401 Unauthorized` or `Provider authentication failed`

**Solution**: Check your provider API keys are set correctly in the environment:
- **For Meta LLAMA**: Set `META_API_KEY` environment variable
- **For Anthropic**: Set `ANTHROPIC_API_KEY` environment variable

These keys must be valid and have sufficient credits with the provider. The AINative API forwards your requests to the provider using these keys.

### Error Response Format

```json
{
  "error": {
    "message": "Chat completion failed: Invalid API key",
    "type": "authentication_error",
    "code": "invalid_api_key"
  }
}
```

---

## Advanced Patterns

### Pattern 1: Multi-Agent Orchestration

```python
async def multi_agent_workflow():
    # Agent 1: Research agent
    research_tools = [
        {"type": "function", "function": {"name": "zerodb_semantic_search", ...}},
        {"type": "function", "function": {"name": "http_tool", ...}}
    ]

    research_result = await chat_with_tools(
        message="Research best practices for async Python",
        tools=research_tools
    )

    # Agent 2: Code generation agent
    code_tools = [
        {"type": "function", "function": {"name": "file_tool", ...}},
        {"type": "function", "function": {"name": "testing_tool", ...}}
    ]

    code_result = await chat_with_tools(
        message=f"Based on this research: {research_result}, generate optimized async code",
        tools=code_tools
    )

    return code_result
```

### Pattern 2: Streaming Responses (Future)

```python
# Streaming will be supported in future versions
async def stream_chat():
    async with httpx.AsyncClient() as client:
        async with client.stream(
            "POST",
            "https://api.ainative.studio/v1/chat/completions",
            headers={"Content-Type": "application/json"},
            json={
                "messages": [...],
                "stream": True
            }
        ) as response:
            async for chunk in response.aiter_bytes():
                print(chunk.decode(), end="")
```

### Pattern 3: Dynamic Tool Selection

```python
# Dynamically select tools based on user intent
def get_tools_for_intent(intent: str):
    tool_mapping = {
        "data_analysis": ["zerodb_query_table", "zerodb_semantic_search"],
        "code_generation": ["file_tool", "bash_tool", "testing_tool"],
        "deployment": ["docker_tool", "deployment_tool", "bash_tool"]
    }
    return tool_mapping.get(intent, [])

tools = get_tools_for_intent("data_analysis")
```

### Pattern 4: Persistent Context Management

```python
class PersistentContextAgent:
    def __init__(self, agent_id: str):
        self.agent_id = agent_id
        self.conversation_history = []

    async def chat(self, message: str):
        # Load relevant memories
        memories = await self.search_memories(message)

        # Add to conversation history
        self.conversation_history.append({
            "role": "user",
            "content": message
        })

        # Include memory context
        context = f"Relevant memories: {memories}\n\nUser: {message}"

        # Get response with tools
        response = await chat_with_tools(
            messages=[...self.conversation_history],
            tools=[memory_tools]
        )

        # Store important info
        await self.store_memory(response)

        self.conversation_history.append({
            "role": "assistant",
            "content": response
        })

        return response
```

### Pattern 5: Retry with Exponential Backoff

```python
import asyncio
import httpx

async def chat_with_retry(max_retries=3):
    for attempt in range(max_retries):
        try:
            async with httpx.AsyncClient() as client:
                response = await client.post(...)
                return response.json()
        except httpx.HTTPError as e:
            if attempt == max_retries - 1:
                raise

            wait_time = 2 ** attempt  # Exponential backoff
            print(f"Attempt {attempt + 1} failed, retrying in {wait_time}s...")
            await asyncio.sleep(wait_time)
```

---

## Reference

### Endpoint

```
POST https://api.ainative.studio/v1/chat/completions
```

### Headers

```
Content-Type: application/json
Authorization: Bearer <jwt-token>  # Optional - for user tracking only
```

### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `provider` | string | Yes | Provider name: `meta_llama`, `anthropic` |
| `model` | string | Yes | Model ID (e.g., `Llama-3.3-70B-Instruct`) |
| `messages` | array | Yes | Array of message objects |
| `tools` | array | No | Tool definitions (client-side execution required) |
| `temperature` | float | No | Sampling temperature (0.0-1.0) |
| `max_tokens` | integer | No | Maximum completion tokens |
| `max_iterations` | integer | No | Max tool calling iterations (default: 5) |

### Rate Limits

**BYOK mode has no AINative rate limits** - you're using your own provider API keys. Rate limits are determined by your provider account:

- **Meta LLAMA**: See your Meta API account limits
- **Anthropic**: See your Anthropic API account limits

For managed endpoint with AINative credits and rate limits, see `docs/backend/MANAGED_CHAT_API_INTERNAL_GUIDE.md`

### Model Context Windows

| Model | Context Window |
|-------|----------------|
| Llama-4-Maverick-17B | 128K tokens |
| Llama-3.3-70B-Instruct | 128K tokens |
| Llama-3.3-8B-Instruct | 128K tokens |
| Claude Sonnet 4.5 | 200K tokens |
| Claude Opus 4 | 200K tokens |

### Pricing

**BYOK mode**: You are billed directly by the provider (Meta, Anthropic) at their standard rates. AINative does not charge for BYOK requests.

Example provider pricing (subject to change - check provider websites):

| Provider | Input (per 1M tokens) | Output (per 1M tokens) |
|----------|-----------------------|------------------------|
| Meta LLAMA | ~$0.60 | ~$1.80 |
| Anthropic Claude | ~$3.00 | ~$15.00 |

For the managed endpoint with AINative credit-based pricing, see `docs/backend/MANAGED_CHAT_API_INTERNAL_GUIDE.md`

---

## Support

- **Documentation**: https://docs.ainative.studio
- **API Reference**: https://api.ainative.studio/docs-enhanced
- **GitHub Issues**: https://github.com/AINative-Studio/core/issues
- **Email**: support@ainative.studio
- **Discord**: https://discord.gg/ainative

---

## Changelog

### v1.1.0 (January 6, 2026) - Issue #694
- ✅ Fixed endpoint documentation (correct path: `/v1/chat/completions`)
- ✅ Fixed authentication section (BYOK mode with optional JWT)
- ✅ Clarified tool execution model (client-side only)
- ✅ Added reference to managed endpoint guide
- ✅ Updated pricing section for BYOK mode
- ✅ Corrected all code examples with proper headers

### v1.0.0 (January 6, 2026)
- ✅ Initial release
- ✅ Multi-provider support (Meta LLAMA, Anthropic)
- ✅ Agentic tool calling with 30+ tool definitions
- ✅ Token tracking across iterations
- ✅ OpenAI-compatible format

### Upcoming Features
- 🔄 Server-side tool execution (Issue #695)
- 🔄 Streaming responses
- 🔄 Function calling with tool_choice enforcement
- 🔄 Vision support for image analysis
- 🔄 Multi-modal tool calling

---

**Last Updated**: January 6, 2026
**Version**: 1.1.0
**Issues**: #623, #624, #694
