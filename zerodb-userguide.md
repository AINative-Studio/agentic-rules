# ZeroDB Platform Developer Guide

> **Last Updated:** December 13, 2025

## 📚 Quick Navigation

| Section | Description | Time to Complete |
|---------|-------------|------------------|
| [🚀 Quick Start](#-quick-start-5-minutes) | Get started in 5 minutes | 5 min |
| [📋 Prerequisites](#-prerequisites--setup) | What you need before starting | 2 min |
| [💡 Common Use Cases](#-common-use-cases) | Real-world examples (RAG, CRUD, Analytics) | 10 min |
| [📖 Complete API Reference](#-complete-api-reference) | Full endpoint documentation | Reference |
| [🔍 Troubleshooting](#-troubleshooting) | Common errors and solutions | Reference |
| [🚀 Best Practices](#-best-practices) | Production-ready patterns | 10 min |

---

## 🚀 Quick Start (5 Minutes)

Get started with ZeroDB in 5 minutes. This example creates a project, stores a document with AI embeddings, and performs semantic search.

> **💡 Tip:** Free tier allows 3 projects. If you already have projects, jump to [Option B](#option-b-use-existing-project) in Step 2.

---

### Step 1: Get Your API Key

1. Sign up at **https://ainative.studio**
2. Navigate to **Settings → API Keys**
3. Click **Create API Key** and copy it

**Example:**
```
Your API Key: kLPiP0bzgKJ0CnNYVt1wq3qxbs2QgDeF2XwyUnxBEOM
```

---

### Step 2: Get a Project ID

You need a project ID for all API calls. Choose Option A or B:

#### Option A: Create New Project

```bash
curl -X POST "https://api.ainative.studio/v1/public/projects" \
  -H "X-API-Key: YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My First Project",
    "description": "Getting started with ZeroDB",
    "tier": "free",
    "database_enabled": true
  }'
```

**Success Response:**
```json
{
  "id": "a9b717be-f449-43c6-abb4-18a1a6a0c70e",
  "name": "My First Project",
  "tier": "free",
  "status": "ACTIVE"
}
```

**✅ Success Check:** Look for `"status": "ACTIVE"`. Copy the `id` value!

**Error Response (Project Limit):**
```json
{
  "detail": "Project limit reached for free tier (3 max)"
}
```

**❌ Got this error?** Use Option B instead ↓

---

#### Option B: Use Existing Project

```bash
# List your existing projects
curl "https://api.ainative.studio/v1/public/projects" \
  -H "X-API-Key: YOUR_API_KEY_HERE"
```

**Response:**
```json
{
  "items": [
    {
      "id": "f3bd73fe-8e0b-42b7-8fa1-02951bf7724f",
      "name": "My Existing Project",
      "status": "ACTIVE"
    }
  ]
}
```

**✅ Success Check:** Copy any `id` from the list.

---

**💡 IMPORTANT: You now have your `PROJECT_ID`. Let's use it!**

**Example values we'll use:**
- `PROJECT_ID`: `a9b717be-f449-43c6-abb4-18a1a6a0c70e`
- `API_KEY`: `kLPiP0bzgKJ0CnNYVt1wq3qxbs2QgDeF2XwyUnxBEOM`

---

### Step 3: Store a Document with Embeddings

Now replace `YOUR_PROJECT_ID` and `YOUR_API_KEY` with your actual values from above:

**Template (what you copy):**
```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/embeddings/embed-and-store" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "documents": [
      {
        "id": "doc_1",
        "text": "ZeroDB is a unified database platform with PostgreSQL, vectors, and AI.",
        "metadata": {
          "category": "documentation",
          "tags": ["database", "ai"]
        }
      }
    ],
    "namespace": "knowledge_base",
    "upsert": true
  }'
```

**Example (with real values):**
```bash
curl -X POST "https://api.ainative.studio/v1/public/a9b717be-f449-43c6-abb4-18a1a6a0c70e/embeddings/embed-and-store" \
  -H "X-API-Key: kLPiP0bzgKJ0CnNYVt1wq3qxbs2QgDeF2XwyUnxBEOM" \
  -H "Content-Type: application/json" \
  -d '{
    "documents": [
      {
        "id": "doc_1",
        "text": "ZeroDB is a unified database platform with PostgreSQL, vectors, and AI.",
        "metadata": {
          "category": "documentation",
          "tags": ["database", "ai"]
        }
      }
    ],
    "namespace": "knowledge_base",
    "upsert": true
  }'
```

**Success Response:**
```json
{
  "success": true,
  "vectors_stored": 1,
  "embeddings_generated": 1,
  "model": "BAAI/bge-small-en-v1.5",
  "dimensions": 384
}
```

**✅ Success Check:** Look for `"success": true` and `"dimensions": 384`.

---

### Step 4: Search Your Knowledge Base

```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/embeddings/search" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What is ZeroDB?",
    "top_k": 5,
    "namespace": "knowledge_base"
  }'
```

**Example (with real values):**
```bash
curl -X POST "https://api.ainative.studio/v1/public/a9b717be-f449-43c6-abb4-18a1a6a0c70e/embeddings/search" \
  -H "X-API-Key: kLPiP0bzgKJ0CnNYVt1wq3qxbs2QgDeF2XwyUnxBEOM" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What is ZeroDB?",
    "top_k": 5,
    "namespace": "knowledge_base"
  }'
```

**Response:**
```json
{
  "results": [
    {
      "id": "doc_1",
      "score": 0.92,
      "text": "ZeroDB is a unified database platform with PostgreSQL, vectors, and AI.",
      "metadata": {
        "category": "documentation",
        "tags": ["database", "ai"]
      }
    }
  ],
  "total_results": 1,
  "model": "BAAI/bge-small-en-v1.5"
}
```

**✅ Success Check:** Look for `"total_results": 1` and a score near 0.9.

---

### 🎉 Congratulations! You Did It!

You've just completed your first ZeroDB integration in under 5 minutes:

- ✅ Got a project ID (created new or used existing)
- ✅ Stored a document with AI embeddings (384 dimensions)
- ✅ Performed semantic search using natural language

---

### 🚀 What's Next? Choose Your Path:

| Path | Description | Time | Link |
|------|-------------|------|------|
| **1. Build a RAG System** | Create a chatbot that answers from your docs | 10 min | [RAG Tutorial](#use-case-1-rag-retrieval-augmented-generation) |
| **2. Manage Customer Data** | Store and query customer data with NoSQL | 10 min | [CRUD Tutorial](#use-case-2-customer-data-management-nosql) |
| **3. Track Analytics** | Real-time event tracking dashboard | 10 min | [Analytics Tutorial](#use-case-3-real-time-event-tracking) |
| **4. Explore API** | Browse all 40+ endpoints available | - | [API Reference](#-complete-api-reference) |
| **5. Learn Best Practices** | Production-ready patterns and tips | 10 min | [Best Practices](#-best-practices) |

---

### ❓ Need Help?

**Common Issues:**

1. **"Project limit reached"** → Use [Option B](#option-b-use-existing-project) to list existing projects
2. **"Not authenticated"** → Check your API key is correct
3. **"404 Not Found"** → Make sure you replaced `YOUR_PROJECT_ID` with actual ID
4. **Need more help?** → See [Troubleshooting](#-troubleshooting) section

---

## 🎯 Multi-Dimension Vector Support

**NEW in 2025:** ZeroDB now supports 4 vector dimension tiers for cost-optimized AI applications.

### Dimension Comparison Table

| Dimension | Model | Storage/Vector | Search Speed | Quality (MTEB) | Cost | Use Case |
|-----------|-------|----------------|--------------|----------------|------|----------|
| **384** | BAAI/bge-small-en-v1.5 | 1.5 KB | ⚡⚡⚡ Very Fast | 62.4 | FREE | General-purpose (80% of users) |
| **768** | BAAI/bge-base-en-v1.5 | 3 KB (2x) | ⚡⚡ Fast | 63.6 | FREE | Higher quality search (15% of users) |
| **1024** | BAAI/bge-large-en-v1.5 | 4 KB (2.7x) | ⚡ Medium | 64.2 | FREE | Mission-critical apps (4% of users) |
| **1536** | OpenAI/Custom | 6 KB (4x) | N/A | Varies | Varies | Legacy compatibility (1% of users) |

**All models are FREE!** (Self-hosted on Railway)

---

### Model Selection Guide

#### When to Use 384 Dimensions (Default)

**Model:** `BAAI/bge-small-en-v1.5`

```bash
curl -X POST "${API_URL}/${PROJECT_ID}/embeddings/generate" \
  -H "X-API-Key: ${API_KEY}" \
  -d '{
    "texts": ["Your text here"]
    // No model parameter = defaults to 384-dim
  }'
```

**Pros:**
- Smallest storage (1.5 KB per vector)
- Fastest search performance
- Good quality for most use cases (62.4 MTEB score)
- FREE (no API costs)

**When to use:**
- General-purpose semantic search
- High-volume document storage (>10K vectors)
- Real-time search requirements
- Cost-sensitive projects

---

#### When to Use 768 Dimensions

**Model:** `BAAI/bge-base-en-v1.5`

```bash
curl -X POST "${API_URL}/${PROJECT_ID}/embeddings/generate" \
  -H "X-API-Key: ${API_KEY}" \
  -d '{
    "texts": ["Your text here"],
    "model": "BAAI/bge-base-en-v1.5"
  }'
```

**Response:**
```json
{
  "embeddings": [[0.1, 0.2, ...768 values]],
  "model": "BAAI/bge-base-en-v1.5",
  "dimensions": 768,
  "count": 1
}
```

**When to use:**
- E-commerce product search
- Legal/medical document retrieval
- Business-critical applications
- When accuracy matters more than speed

---

#### When to Use 1024 Dimensions (Premium)

**Model:** `BAAI/bge-large-en-v1.5`

```python
import requests

response = requests.post(
    f"{API_URL}/{PROJECT_ID}/embeddings/generate",
    headers={"X-API-Key": API_KEY},
    json={
        "texts": ["Premium quality embeddings"],
        "model": "BAAI/bge-large-en-v1.5"
    }
)

data = response.json()
# {"dimensions": 1024, "model": "BAAI/bge-large-en-v1.5", ...}
```

**When to use:**
- Research applications
- Mission-critical search systems
- When highest accuracy is paramount
- Low-volume, high-value documents

---

#### When to Use 1536 Dimensions (Legacy)

**Model:** `text-embedding-3-small` or custom

**When to use:**
- Migrating from OpenAI embeddings
- Already have 1536-dim vectors
- Specific custom model requirements

**Note:** Consider migrating to 384/768/1024 to reduce storage costs.

---

### Important: Model Consistency

**CRITICAL:** Always use the SAME model for storing and searching!

```python
# ✅ CORRECT - Same model for store and search
MODEL = "BAAI/bge-base-en-v1.5"

# Store with base model (768-dim)
response = requests.post(
    f"{API_URL}/{PROJECT_ID}/embeddings/embed-and-store",
    json={
        "documents": [{"id": "doc_1", "text": "Document", "metadata": {}}],
        "model": MODEL,  # 768-dim
        "namespace": "docs"
    }
)

# Search with SAME model (768-dim)
response = requests.post(
    f"{API_URL}/{PROJECT_ID}/embeddings/search",
    json={
        "query": "Find documents",
        "model": MODEL,  # Same model!
        "namespace": "docs"
    }
)
```

```python
# ❌ WRONG - Different models for store vs search
# Store with base model (768-dim)
requests.post(..., json={"model": "BAAI/bge-base-en-v1.5", ...})

# Search with small model (384-dim) - DIMENSION MISMATCH!
requests.post(..., json={"model": "BAAI/bge-small-en-v1.5", ...})  # ❌ Poor results!
```

**Why?** Different models produce incompatible embeddings. Mixing them results in poor search quality.

---

### Backward Compatibility

**Old code without `model` parameter still works:**

```python
# Old code (pre-2025)
{
  "texts": ["test"]
  # No model parameter
}

# ✅ Still works! Defaults to BAAI/bge-small-en-v1.5 (384-dim)
```

All existing integrations continue working without changes.

---

## 📋 Prerequisites & Setup

### What You Need

| Requirement | Where to Get It | Time |
|-------------|-----------------|------|
| **Account** | Sign up at https://ainative.studio | 1 min |
| **API Key** | Settings → API Keys → Create | 1 min |
| **Project ID** | See [Quick Start](#step-2-create-your-first-project) | 1 min |
| **HTTP Client** | curl, Postman, or any language | Already installed |

### Authentication: Which Method Should I Use?

**Option 1: API Key (Recommended)**
```bash
-H "X-API-Key: YOUR_API_KEY_HERE"
```

**When to use:**
- ✅ Production applications
- ✅ Server-to-server communication
- ✅ Scripts and automation
- ✅ Backend services

**When NOT to use:**
- ❌ Browser-based apps (exposes your key)
- ❌ Mobile apps (key can be extracted)

---

**Option 2: JWT Bearer Token**
```bash
# Step 1: Get token
curl -X POST "https://api.ainative.studio/v1/public/auth/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=your@email.com&password=YourPassword123"

# Response: {"access_token": "eyJhbGci...", "token_type": "bearer"}

# Step 2: Use token in requests
curl "https://api.ainative.studio/v1/public/projects" \
  -H "Authorization: Bearer eyJhbGci..."
```

**When to use:**
- ✅ User-specific sessions
- ✅ Mobile applications
- ✅ Temporary access

**When NOT to use:**
- ❌ Server-to-server communication
- ❌ Long-running background jobs

---

### Understanding Projects

Every API call needs a `project_id`. Projects provide:

- **Data Isolation** - Your data never mixes with other projects
- **Resource Limits** - Based on tier (free: 10K vectors, pro: 100K, etc.)
- **Billing Scope** - Usage tracked per project

**Get your projects:**
```bash
curl "https://api.ainative.studio/v1/public/projects" \
  -H "X-API-Key: YOUR_API_KEY"
```

---

### API Endpoint Structure

All ZeroDB endpoints follow this pattern:
```
https://api.ainative.studio/v1/public/{project_id}/{resource}/{action}
```

**Examples:**
```
https://api.ainative.studio/v1/public/a9b717be-f449-43c6-abb4-18a1a6a0c70e/embeddings/search
https://api.ainative.studio/v1/public/a9b717be-f449-43c6-abb4-18a1a6a0c70e/database/vectors/upsert
https://api.ainative.studio/v1/public/a9b717be-f449-43c6-abb4-18a1a6a0c70e/database/tables/customers/rows
```

---

## 💡 Common Use Cases

### Use Case 1: RAG System (Retrieval Augmented Generation)

**Goal:** Build a chatbot that answers questions using your documents.

**Complete working example:**

```python
import requests

# Configuration
API_KEY = "your_api_key"
PROJECT_ID = "your_project_id"
BASE_URL = "https://api.ainative.studio/v1/public"
headers = {"X-API-Key": API_KEY, "Content-Type": "application/json"}

# Step 1: Load your knowledge base
documents = [
    {
        "id": "faq_1",
        "text": "How do I reset my password? Click 'Forgot Password' on the login page.",
        "metadata": {"type": "faq", "category": "authentication"}
    },
    {
        "id": "faq_2",
        "text": "How do I upgrade my plan? Visit Settings > Billing > Change Plan.",
        "metadata": {"type": "faq", "category": "billing"}
    },
    {
        "id": "faq_3",
        "text": "How do I contact support? Email support@example.com or use live chat.",
        "metadata": {"type": "faq", "category": "support"}
    }
]

response = requests.post(
    f"{BASE_URL}/{PROJECT_ID}/embeddings/embed-and-store",
    headers=headers,
    json={
        "documents": documents,
        "namespace": "customer_support",
        "upsert": True
    }
)
print(f"✅ Stored {response.json()['vectors_stored']} documents\n")

# Step 2: Search when user asks a question
user_question = "I can't log in to my account"

search_response = requests.post(
    f"{BASE_URL}/{PROJECT_ID}/embeddings/search",
    headers=headers,
    json={
        "query": user_question,
        "top_k": 3,
        "namespace": "customer_support",
        "similarity_threshold": 0.7
    }
)

print(f"🔍 Question: {user_question}\n")
print("📚 Relevant answers:")
for result in search_response.json()['results']:
    print(f"  • Score: {result['score']:.2f} - {result['text']}")
```

**Expected Output:**
```
✅ Stored 3 documents

🔍 Question: I can't log in to my account

📚 Relevant answers:
  • Score: 0.88 - How do I reset my password? Click 'Forgot Password' on the login page.
  • Score: 0.72 - How do I contact support? Email support@example.com or use live chat.
```

---

### Use Case 2: Customer Data Management

**Goal:** Store and query customer data with NoSQL tables.

**Complete working example:**

```bash
# Set your credentials
export API_KEY="your_api_key"
export PROJECT_ID="your_project_id"

# Step 1: Create a customer table
curl -X POST "https://api.ainative.studio/v1/public/${PROJECT_ID}/database/tables" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "customers",
    "description": "Customer information",
    "schema": {
      "id": "UUID PRIMARY KEY",
      "name": "TEXT NOT NULL",
      "email": "TEXT UNIQUE",
      "tier": "TEXT",
      "created_at": "TIMESTAMP DEFAULT NOW()"
    }
  }'

echo "✅ Table created"

# Step 2: Insert customer data
curl -X POST "https://api.ainative.studio/v1/public/${PROJECT_ID}/database/tables/customers/rows" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "row_data": {
      "name": "John Doe",
      "email": "john@example.com",
      "tier": "pro"
    }
  }'

echo "✅ Customer added"

# Step 3: Query customers
curl "https://api.ainative.studio/v1/public/${PROJECT_ID}/database/tables/customers/rows?limit=100" \
  -H "X-API-Key: ${API_KEY}"
```

---

### Use Case 3: Real-Time Event Tracking

**Goal:** Track user events for analytics dashboard.

**Complete working example:**

```python
import requests
from datetime import datetime

API_KEY = "your_api_key"
PROJECT_ID = "your_project_id"
BASE_URL = "https://api.ainative.studio/v1/public"
headers = {"X-API-Key": API_KEY, "Content-Type": "application/json"}

def track_event(event_type, user_id, data):
    """Track a user event"""
    response = requests.post(
        f"{BASE_URL}/{PROJECT_ID}/database/events",
        headers=headers,
        json={
            "event_type": event_type,
            "data": {"user_id": user_id, **data},
            "timestamp": datetime.utcnow().isoformat() + "Z"
        }
    )
    if response.status_code == 200:
        print(f"✅ Tracked: {event_type} for user {user_id}")
    return response.json()

# Track various user events
track_event("page_view", "user_123", {
    "page": "/dashboard",
    "referrer": "/login",
    "duration_seconds": 45
})

track_event("feature_used", "user_123", {
    "feature": "export_data",
    "success": True
})

track_event("purchase", "user_456", {
    "product_id": "prod_789",
    "amount": 99.99,
    "currency": "USD"
})
```

**Output:**
```
✅ Tracked: page_view for user user_123
✅ Tracked: feature_used for user user_123
✅ Tracked: purchase for user user_456
```

---

## 🎯 API Overview

**Platform:** ZeroDB Unified Intelligent Database
**Base URL:** `https://api.ainative.studio`
**API Version:** v1
**Status:** ✅ Production Ready
**Last Updated:** 2025-01-14

### 🚨 Critical Requirements

Before using the API, note these **important** details:

| Requirement | Details | Why It Matters |
|-------------|---------|----------------|
| **Embeddings Model** | `BAAI/bge-small-en-v1.5` | Using `custom-1536` will cause 500 errors |
| **Vector Dimensions** | **384** (NOT 1536) | Dimension mismatches cause errors |
| **Vector Endpoint Prefix** | `/database/` required | Without it, you get 404 errors |
| **Table Row Parameter** | `row_data` (NOT `rows`) | Using `rows` causes 422 validation errors |
| **SQL Queries** | Requires PostgreSQL provisioning | Returns 404 if instance not provisioned |

---

## 📖 Complete API Reference

### Projects API

#### Create Project

**Endpoint:** `POST /v1/public/projects`

**Request:**
```bash
curl -X POST "https://api.ainative.studio/v1/public/projects" \
  -H "X-API-Key: your_api_key" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My AI Project",
    "description": "AI-powered application",
    "tier": "pro",
    "database_enabled": true
  }'
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | string | ✅ Yes | - | Project name (2-100 chars) |
| `description` | string | No | null | Project description |
| `tier` | string | No | `"free"` | `"free"`, `"pro"`, `"scale"`, `"enterprise"` |
| `database_enabled` | boolean | No | `true` | Enable database features |

**Success Response (201 Created):**
```json
{
  "id": "a9b717be-f449-43c6-abb4-18a1a6a0c70e",
  "name": "My AI Project",
  "description": "AI-powered application",
  "tier": "pro",
  "status": "ACTIVE",
  "database_enabled": true,
  "created_at": "2025-01-14T10:00:00Z",
  "updated_at": "2025-01-14T10:00:00Z"
}
```

**Error Responses:**

```json
// 400 Bad Request - Invalid tier
{
  "detail": "Invalid tier. Must be one of: free, pro, scale, enterprise",
  "error_code": "INVALID_TIER"
}

// 403 Forbidden - Project limit reached
{
  "detail": "Project limit reached for your tier. Upgrade to create more projects.",
  "error_code": "PROJECT_LIMIT_EXCEEDED"
}

// 401 Unauthorized - Invalid API key
{
  "detail": "Invalid API key",
  "error_code": "INVALID_API_KEY"
}
```

---

#### List Projects

**Endpoint:** `GET /v1/public/projects`

**Request:**
```bash
curl "https://api.ainative.studio/v1/public/projects?skip=0&limit=100" \
  -H "X-API-Key: your_api_key"
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `skip` | integer | No | `0` | Number to skip (pagination) |
| `limit` | integer | No | `100` | Max results (max: 1000) |

**Response (200 OK):**
```json
{
  "items": [
    {
      "id": "a9b717be-f449-43c6-abb4-18a1a6a0c70e",
      "name": "My AI Project",
      "tier": "pro",
      "status": "ACTIVE",
      "created_at": "2025-01-14T10:00:00Z"
    }
  ],
  "total": 1,
  "skip": 0,
  "limit": 100
}
```

---

### Embeddings API

Generate 384-dimension vector embeddings using BAAI/bge-small-en-v1.5 model.

**Model Details:**
- **Name:** BAAI/bge-small-en-v1.5
- **Dimensions:** 384 (NOT 1536)
- **Performance:** ~380ms per request
- **Cost:** FREE (self-hosted on Railway)
- **Max Batch Size:** 100 texts per request

> ⚠️ **CRITICAL**: Always use **384 dimensions**. Using 1536 will cause errors.

---

#### Generate Embeddings

**Endpoint:** `POST /v1/public/{project_id}/embeddings/generate`

**Request:**
```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/embeddings/generate" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "texts": [
      "How to deploy a web application?",
      "Best practices for API security"
    ],
    "model": "BAAI/bge-small-en-v1.5"
  }'
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `texts` | string[] | ✅ Yes | - | Array of texts (max 100) |
| `model` | string | No | `"BAAI/bge-small-en-v1.5"` | Embedding model |

**Response (200 OK):**
```json
{
  "embeddings": [
    [0.123, -0.456, 0.789, ...],
    [0.234, -0.567, 0.890, ...]
  ],
  "model": "BAAI/bge-small-en-v1.5",
  "dimensions": 384,
  "count": 2,
  "processing_time_ms": 42.5
}
```

**Error Response (500 Internal Server Error):**
```json
{
  "detail": "Embedding model 'custom-1536' not found. Use 'BAAI/bge-small-en-v1.5'",
  "error_code": "MODEL_NOT_FOUND"
}
```

---

#### Embed and Store

**Endpoint:** `POST /v1/public/{project_id}/embeddings/embed-and-store`

Generates embeddings AND stores them in vector database. **Recommended for RAG systems.**

**Request:**
```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/embeddings/embed-and-store" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "documents": [
      {
        "id": "doc_1",
        "text": "FastAPI is a modern web framework for Python.",
        "metadata": {
          "category": "documentation",
          "tags": ["python", "api"]
        }
      }
    ],
    "namespace": "knowledge_base",
    "upsert": true
  }'
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `documents` | object[] | ✅ Yes | - | Documents with id, text, metadata |
| `namespace` | string | No | `"default"` | Vector namespace |
| `upsert` | boolean | No | `true` | Update if exists |

**Document Object:**
```typescript
{
  id: string;           // Unique identifier
  text: string;         // Text to embed
  metadata?: object;    // Optional metadata
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "vectors_stored": 1,
  "embeddings_generated": 1,
  "model": "BAAI/bge-small-en-v1.5",
  "dimensions": 384,
  "namespace": "knowledge_base",
  "processing_time_ms": 156.7
}
```

---

#### Semantic Search

**Endpoint:** `POST /v1/public/{project_id}/embeddings/search`

Search your vector database using natural language.

**Request:**
```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/embeddings/search" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "How do I build REST APIs in Python?",
    "top_k": 5,
    "namespace": "knowledge_base",
    "filter": {
      "category": "documentation"
    },
    "similarity_threshold": 0.7
  }'
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `query` | string | ✅ Yes | - | Search query |
| `top_k` | integer | No | `10` | Max results (max: 100) |
| `namespace` | string | No | `null` | Filter by namespace |
| `filter` | object | No | `null` | Metadata filters |
| `similarity_threshold` | number | No | `0.0` | Min score (0-1) |
| `include_metadata` | boolean | No | `true` | Include metadata |
| `include_embeddings` | boolean | No | `false` | Include vectors |

**Response (200 OK):**
```json
{
  "results": [
    {
      "id": "doc_1",
      "score": 0.92,
      "text": "FastAPI is a modern web framework for Python.",
      "metadata": {
        "category": "documentation",
        "tags": ["python", "api"]
      }
    }
  ],
  "query": "How do I build REST APIs in Python?",
  "total_results": 1,
  "model": "BAAI/bge-small-en-v1.5",
  "processing_time_ms": 98.3
}
```

---

### Vector Operations API

> ⚠️ **CRITICAL**: All vector endpoints require `/database/` prefix:
> - ✅ Correct: `/v1/public/{project_id}/database/vectors/upsert`
> - ❌ Wrong: `/v1/public/{project_id}/vectors/upsert` (404 error)

---

#### Upsert Vector

**Endpoint:** `POST /v1/public/{project_id}/database/vectors/upsert`

**Request:**
```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/database/vectors/upsert" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "doc_123",
    "vector": [0.1, 0.2, 0.3, ... (384 total)],
    "metadata": {
      "title": "AI in Healthcare",
      "category": "article"
    },
    "namespace": "documents"
  }'
```

**⚠️ CRITICAL**: Vector must have **384 dimensions** for ZeroDB embeddings.

**Error Response (500 Internal Server Error):**
```json
{
  "detail": "Vector dimension mismatch. Expected 384, got 1536",
  "error_code": "DIMENSION_MISMATCH"
}
```

---

### Tables API

#### Create Table

**Endpoint:** `POST /v1/public/{project_id}/database/tables`

**Request:**
```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/database/tables" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "customers",
    "description": "Customer data",
    "schema": {
      "id": "UUID PRIMARY KEY",
      "name": "TEXT NOT NULL",
      "email": "TEXT UNIQUE"
    }
  }'
```

---

#### Insert Row

**Endpoint:** `POST /v1/public/{project_id}/database/tables/{table_name}/rows`

**Request:**
```bash
curl -X POST "https://api.ainative.studio/v1/public/YOUR_PROJECT_ID/database/tables/customers/rows" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "row_data": {
      "name": "John Doe",
      "email": "john@example.com"
    }
  }'
```

**⚠️ CRITICAL**: Use `row_data` parameter (NOT `data` or `rows`).

**Correct:**
```json
{
  "row_data": {
    "name": "John Doe"
  }
}
```

**Wrong (422 Validation Error):**
```json
{
  "data": {
    "name": "John Doe"
  }
}
```

**Error Response (422 Unprocessable Entity):**
```json
{
  "detail": [
    {
      "loc": ["body", "row_data"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

---

## 🔍 Troubleshooting

### Common Errors Reference

#### ❌ "Embedding model 'custom-1536' not found"

**HTTP Status:** 500 Internal Server Error

**Cause:** Using incorrect embedding model name.

**Solution:**
```json
{
  "texts": ["Your text here"],
  "model": "BAAI/bge-small-en-v1.5"
}
```

---

#### ❌ "Vector dimension mismatch. Expected 384, got 1536"

**HTTP Status:** 500 Internal Server Error

**Cause:** Using wrong vector dimensions.

**Solution:** Generate embeddings first, then use them:
```python
# Step 1: Generate embeddings (returns 384 dimensions)
response = requests.post(
    f"{BASE_URL}/{PROJECT_ID}/embeddings/generate",
    headers=headers,
    json={"texts": ["Your text"], "model": "BAAI/bge-small-en-v1.5"}
)
embedding = response.json()['embeddings'][0]  # 384 dimensions

# Step 2: Use in vector operations
requests.post(
    f"{BASE_URL}/{PROJECT_ID}/database/vectors/upsert",
    headers=headers,
    json={"id": "doc_1", "vector": embedding}
)
```

---

#### ❌ "404 Not Found" on `/v1/public/{project_id}/vectors/upsert`

**HTTP Status:** 404 Not Found

**Cause:** Missing `/database/` prefix.

**Wrong:**
```
POST /v1/public/{project_id}/vectors/upsert
```

**Correct:**
```
POST /v1/public/{project_id}/database/vectors/upsert
```

---

#### ❌ "Field 'row_data' required"

**HTTP Status:** 422 Unprocessable Entity

**Cause:** Using wrong parameter name.

**Wrong:**
```json
{
  "data": {"name": "John"}
}
```

**Correct:**
```json
{
  "row_data": {"name": "John"}
}
```

---

#### ❌ "No PostgreSQL instance found"

**HTTP Status:** 404 Not Found

**Cause:** SQL query endpoint requires PostgreSQL instance provisioning.

**Solution:**
```bash
# Provision PostgreSQL first
curl -X POST "https://api.ainative.studio/v1/public/${PROJECT_ID}/postgres/provision" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "instance_size": "micro-1",
    "database_name": "my_db"
  }'

# Wait 2-3 minutes for provisioning to complete

# Then execute SQL queries
curl -X POST "https://api.ainative.studio/v1/public/${PROJECT_ID}/database/query" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "sql": "SELECT * FROM users LIMIT 10"
  }'
```

---

#### ❌ "401 Unauthorized"

**HTTP Status:** 401 Unauthorized

**Cause:** Invalid or missing API key.

**Solution:**
```bash
# Verify API key
curl "https://api.ainative.studio/v1/public/projects" \
  -H "X-API-Key: YOUR_API_KEY_HERE"

# If still failing:
# 1. Go to Settings → API Keys
# 2. Generate new API key
# 3. Replace old key with new one
```

---

#### ❌ "403 Forbidden - Project limit reached"

**HTTP Status:** 403 Forbidden

**Cause:** Exceeded project limit for your tier.

**Free tier:** 3 projects max
**Pro tier:** 10 projects max
**Scale tier:** 50 projects max

**Solution:**
```bash
# Option 1: Delete unused projects
curl -X DELETE "https://api.ainative.studio/v1/public/${PROJECT_ID}" \
  -H "X-API-Key: ${API_KEY}"

# Option 2: Upgrade your tier
# Visit https://ainative.studio/settings/billing
```

---

## 🚀 Best Practices

### 1. Embeddings & Vectors

**✅ DO:**
- Use **384 dimensions** for ZeroDB embeddings (BAAI/bge-small-en-v1.5)
- Batch up to 100 texts per embedding request
- Use namespaces to organize different document types
- Set `similarity_threshold: 0.7` for high-quality matches

**❌ DON'T:**
- Don't use 1536 dimensions (that's for OpenAI embeddings)
- Don't send single texts in loops (batch them instead)
- Don't mix different embedding models in same namespace

---

### 2. Authentication & Security

**✅ DO:**
- Use API keys for production
- Store keys in environment variables
- Rotate keys every 90 days
- Use different keys for dev/staging/prod

**❌ DON'T:**
- Don't commit API keys to git
- Don't expose keys in client-side code
- Don't share keys between team members

---

### 3. Error Handling

**✅ DO:**
```python
import requests
from time import sleep

def api_call_with_retry(url, headers, json_data, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = requests.post(url, headers=headers, json=json_data, timeout=30)
            
            if response.status_code == 200:
                return response.json()
            elif response.status_code == 429:  # Rate limit
                sleep(2 ** attempt)  # Exponential backoff
                continue
            elif response.status_code == 500:
                print(f"Server error: {response.json()['detail']}")
                return None
            else:
                response.raise_for_status()
                
        except requests.exceptions.Timeout:
            print(f"Timeout on attempt {attempt + 1}")
            if attempt < max_retries - 1:
                sleep(2 ** attempt)
    
    return None
```

---

### 4. Performance Optimization

**✅ DO:**
- Implement pagination (max 1000 items per request)
- Use metadata filters to reduce result sets
- Cache frequently accessed embeddings
- Batch vector operations

**Example:**
```python
# ✅ Good: Batch insert
requests.post(
    f"{BASE_URL}/{PROJECT_ID}/database/vectors/upsert-batch",
    headers=headers,
    json={"vectors": [v1, v2, v3, ...]}  # Up to 1000
)

# ❌ Bad: Individual inserts in loop
for vector in vectors:
    requests.post(f"{BASE_URL}/{PROJECT_ID}/database/vectors/upsert", ...)
```

---

## 💡 Usage Limits

| Tier | Projects | Vectors | API Requests | Storage |
|------|----------|---------|--------------|---------|
| **Free** | 3 | 10,000 | 1,000/hour | 1 GB |
| **Pro** | 10 | 100,000 | 10,000/hour | 10 GB |
| **Scale** | 50 | 1,000,000 | 100,000/hour | 100 GB |
| **Enterprise** | Unlimited | Unlimited | Custom | Custom |

---

## 🔗 Additional Resources

- **Interactive API Docs:** https://api.ainative.studio/docs
- **Support:** support@ainative.studio
- **Status Page:** https://status.ainative.studio
- **Discord Community:** Join for real-time help

---

**Last Updated:** December 13, 2025
**Version:** 2.0.0
