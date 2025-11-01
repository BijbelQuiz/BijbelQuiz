# MCP Documentation
# What is the Model Context Protocol (MCP)?

MCP (Model Context Protocol) is an open-source standard for connecting AI applications to external systems.

Using MCP, AI applications like Claude or ChatGPT can connect to data sources (e.g. local files, databases), tools (e.g. search engines, calculators) and workflows (e.g. specialized prompts)—enabling them to access key information and perform tasks.

Think of MCP like a USB-C port for AI applications. Just as USB-C provides a standardized way to connect electronic devices, MCP provides a standardized way to connect AI applications to external systems.

<Frame>
  <img src="https://mintcdn.com/mcp/4ZXF1PrDkEaJvXpn/images/mcp-simple-diagram.png?fit=max&auto=format&n=4ZXF1PrDkEaJvXpn&q=85&s=9337f8096debc55621adcaf8ca563695" data-og-width="3840" width="3840" data-og-height="1500" height="1500" data-path="images/mcp-simple-diagram.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/mcp/4ZXF1PrDkEaJvXpn/images/mcp-simple-diagram.png?w=280&fit=max&auto=format&n=4ZXF1PrDkEaJvXpn&q=85&s=147db2e81f434cae3ba44da988154fe5 280w, https://mintcdn.com/mcp/4ZXF1PrDkEaJvXpn/images/mcp-simple-diagram.png?w=560&fit=max&auto=format&n=4ZXF1PrDkEaJvXpn&q=85&s=16251036cd56dc50e8ef32918b99d1da 560w, https://mintcdn.com/mcp/4ZXF1PrDkEaJvXpn/images/mcp-simple-diagram.png?w=840&fit=max&auto=format&n=4ZXF1PrDkEaJvXpn&q=85&s=8b44b031c68d1c10fb0c443f09d237f1 840w, https://mintcdn.com/mcp/4ZXF1PrDkEaJvXpn/images/mcp-simple-diagram.png?w=1100&fit=max&auto=format&n=4ZXF1PrDkEaJvXpn&q=85&s=0a319cb6a2504659377de862e889b8da 1100w, https://mintcdn.com/mcp/4ZXF1PrDkEaJvXpn/images/mcp-simple-diagram.png?w=1650&fit=max&auto=format&n=4ZXF1PrDkEaJvXpn&q=85&s=37d50a5429a8f662c1beb564b4df8e65 1650w, https://mintcdn.com/mcp/4ZXF1PrDkEaJvXpn/images/mcp-simple-diagram.png?w=2500&fit=max&auto=format&n=4ZXF1PrDkEaJvXpn&q=85&s=ce4f99af2930b3b992909963a284c874 2500w" />
</Frame>

## What can MCP enable?

* Agents can access your Google Calendar and Notion, acting as a more personalized AI assistant.
* Claude Code can generate an entire web app using a Figma design.
* Enterprise chatbots can connect to multiple databases across an organization, empowering users to analyze data using chat.
* AI models can create 3D designs on Blender and print them out using a 3D printer.

## Why does MCP matter?

Depending on where you sit in the ecosystem, MCP can have a range of benefits.

* **Developers**: MCP reduces development time and complexity when building, or integrating with, an AI application or agent.
* **AI applications or agents**: MCP provides access to an ecosystem of data sources, tools and apps which will enhance capabilities and improve the end-user experience.
* **End-users**: MCP results in more capable AI applications or agents which can access your data and take actions on your behalf when necessary.

## Start Building

<CardGroup cols={2}>
  <Card title="Build servers" icon="server" href="/docs/develop/build-server">
    Create MCP servers to expose your data and tools
  </Card>

  <Card title="Build clients" icon="computer" href="/docs/develop/build-client">
    Develop applications that connect to MCP servers
  </Card>
</CardGroup>

## Learn more

<CardGroup cols={2}>
  <Card title="Understand concepts" icon="book" href="/docs/learn/architecture">
    Learn the core concepts and architecture of MCP
  </Card>
</CardGroup>

# OpenAI App SDK


Set up your server

Create and configure an MCP server.
Overview

Your MCP server is the foundation of every Apps SDK integration. It exposes tools that the model can call, enforces authentication, and packages the structured data plus component HTML that the ChatGPT client renders inline. This guide walks through the core building blocks with examples in Python and TypeScript.
Choose an SDK

Apps SDK supports any server that implements the MCP specification, but the official SDKs are the fastest way to get started:

    Python SDK (official) – great for rapid prototyping, including the official FastMCP module. See the repo at modelcontextprotocol/python-sdk. This is distinct from community “FastMCP” projects.
    TypeScript SDK (official) – ideal if your stack is already Node/React. Use @modelcontextprotocol/sdk. Docs: modelcontextprotocol.io.

Install the SDK and any web framework you prefer (FastAPI or Express are common choices).
Describe your tools

Tools are the contract between ChatGPT and your backend. Define a clear machine name, human-friendly title, and JSON schema so the model knows when—and how—to call each tool. This is also where you wire up per-tool metadata, including auth hints, status strings, and component configuration.
Point to a component template

In addition to returning structured data, each tool on your MCP server should also reference an HTML UI template in its descriptor. This HTML template will be rendered in an iframe by ChatGPT.

    Register the template – expose a resource whose mimeType is text/html+skybridge and whose body loads your compiled JS/CSS bundle. The resource URI (for example ui://widget/kanban-board.html) becomes the canonical ID for your component.
    Link the tool to the template – inside the tool descriptor, set _meta["openai/outputTemplate"] to the same URI. Optional _meta fields let you declare whether the component can initiate tool calls or display custom status copy.
    Version carefully – when you ship breaking component changes, register a new resource URI and update the tool metadata in lockstep. ChatGPT caches templates aggressively, so unique URIs (or cache-busted filenames) prevent stale assets from loading.

With the template and metadata in place, ChatGPT hydrates the iframe using the structuredContent payload from each tool response.

Here is an example:

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { readFileSync } from "node:fs";

// Create an MCP server
const server = new McpServer({
  name: "kanban-server",
  version: "1.0.0"
});

// Load locally built assets (produced by your component build)
const KANBAN_JS = readFileSync("web/dist/kanban.js", "utf8");
const KANBAN_CSS = (() => {
  try {
    return readFileSync("web/dist/kanban.css", "utf8");
  } catch {
    return ""; // CSS optional
  }
})();

// UI resource (no inline data assignment; host will inject data)
server.registerResource(
  "kanban-widget",
  "ui://widget/kanban-board.html",
  {},
  async () => ({
    contents: [
      {
        uri: "ui://widget/kanban-board.html",
        mimeType: "text/html+skybridge",
        text: `
<div id="kanban-root"></div>
${KANBAN_CSS ? `<style>${KANBAN_CSS}</style>` : ""}
<script type="module">${KANBAN_JS}</script>
        `.trim(),
      },
    ],
  })
);

server.registerTool(
  "kanban-board",
  {
    title: "Show Kanban Board",
    _meta: {
      "openai/outputTemplate": "ui://widget/kanban-board.html",
      "openai/toolInvocation/invoking": "Displaying the board",
      "openai/toolInvocation/invoked": "Displayed the board"
    },
    inputSchema: { tasks: z.string() }
  },
  async () => {
    return {
      content: [{ type: "text", text: "Displayed the kanban board!" }],
      structuredContent: {}
    };
  }
);

Structure the data your tool returns

Each tool result in the tool response can include three sibling fields that shape how ChatGPT and your component consume the payload:

    structuredContent – structured data that is used to hydrate your component, e.g. the tracks for a playlist, the homes for a realtor app, the tasks for a kanban app. ChatGPT injects this object into your iframe as window.openai.toolOutput, so keep it scoped to the data your UI needs. The model reads these values and may narrate or summarize them.
    content – Optional free-form text (Markdown or plain strings) that the model receives verbatim.
    _meta – Arbitrary JSON passed only to the component. Use it for data that should not influence the model’s reasoning, like the full set of locations that backs a dropdown. _meta is never shown to the model.

Your component receives all three fields, but only structuredContent and content are visible to the model. If you are looking to control the text underneath the component, please use widgetDescription.

Continuing the Kanban example, fetch board data and return the trio of fields so the component hydrates without exposing extra context to the model:

async function loadKanbanBoard() {
  const tasks = [
    { id: "task-1", title: "Design empty states", assignee: "Ada", status: "todo" },
    { id: "task-2", title: "Wireframe admin panel", assignee: "Grace", status: "in-progress" },
    { id: "task-3", title: "QA onboarding flow", assignee: "Lin", status: "done" }
  ];

  return {
    columns: [
      { id: "todo", title: "To do", tasks: tasks.filter((task) => task.status === "todo") },
      { id: "in-progress", title: "In progress", tasks: tasks.filter((task) => task.status === "in-progress") },
      { id: "done", title: "Done", tasks: tasks.filter((task) => task.status === "done") }
    ],
    tasksById: Object.fromEntries(tasks.map((task) => [task.id, task])),
    lastSyncedAt: new Date().toISOString()
  };
}

server.registerTool(
  "kanban-board",
  {
    title: "Show Kanban Board",
    _meta: {
      "openai/outputTemplate": "ui://widget/kanban-board.html",
      "openai/toolInvocation/invoking": "Displaying the board",
      "openai/toolInvocation/invoked": "Displayed the board"
    },
    inputSchema: { tasks: z.string() }
  },
  async () => {
    const board = await loadKanbanBoard();

    return {
      structuredContent: {
        columns: board.columns.map((column) => ({
          id: column.id,
          title: column.title,
          tasks: column.tasks.slice(0, 5) // keep payload concise for the model
        }))
      },
      content: [{ type: "text", text: "Here's your latest board. Drag cards in the component to update status." }],
      _meta: {
        tasksById: board.tasksById, // full task map for the component only
        lastSyncedAt: board.lastSyncedAt
      }
    };
  }
);

Build your component

Now that you have the MCP server scaffold set up, follow the instructions on the Build a custom UX page to build your component experience.
Run locally

    Build your component bundle (See instructions on the Build a custom UX page page).
    Start the MCP server.
    Point MCP Inspector to http://localhost:<port>/mcp, list tools, and call them.

Inspector validates that your response includes both structured content and component metadata and renders the component inline.
Expose a public endpoint

ChatGPT requires HTTPS. During development, you can use a tunnelling service such as ngrok.

In a separate terminal window, run:

ngrok http <port>
# Forwarding: https://<subdomain>.ngrok.app -> http://127.0.0.1:<port>

Use the resulting URL when creating a connector in developer mode. For production, deploy to an HTTPS endpoint with low cold-start latency (see Deploy your app).
Layer in authentication and storage

Once the server handles anonymous traffic, decide whether you need user identity or persistence. The Authentication and Storage guides show how to add OAuth 2.1 flows, token verification, and user state management.

With these pieces in place you have a functioning MCP server ready to pair with a component bundle.
Advanced
Allow component-initiated tool access

To allow component‑initiated tool access, you should mark tools with _meta.openai/widgetAccessible: true:

"_meta": { 
  "openai/outputTemplate": "ui://widget/kanban-board.html",
  "openai/widgetAccessible": true 
}

Define component content security policies

Widgets are required to have a strict content security policy (CSP) prior to broad distribution within ChatGPT. As part of the MCP review process, a snapshotted CSP will be inspected.

To declare a CSP, your component resource should include the openai/widget meta property with a csp subproperty.

server.registerResource(
  "html",
  "ui://widget/widget.html",
  {},
  async (req) => ({
    contents: [
      {
        uri: "ui://widget/widget.html",
        mimeType: "text/html",
        text: `
<div id="kitchen-sink-root"></div>
<link rel="stylesheet" href="https://persistent.oaistatic.com/ecosystem-built-assets/kitchen-sink-2d2b.css">
<script type="module" src="https://persistent.oaistatic.com/ecosystem-built-assets/kitchen-sink-2d2b.js"></script>
        `.trim(),
        _meta: {
          "openai/widgetCSP": {
            connect_domains: [],
            resource_domains: ["https://persistent.oaistatic.com"],
          }
        },
      },
    ],
  })
);

The CSP should define two arrays of URLs: connect_domains and resource_domains. These URLs ultimately map to the following CSP definition:

`script-src 'self' ${resources}`,
`img-src 'self' data: ${resources}`,
`font-src 'self' ${resources}`,
`connect-src 'self' ${connects}`,

Configure component subdomains

Components also support a configurable subdomain. If you have public API keys (for example Google Maps) and need to restrict access to specific origins or referrers, you can set a subdomain to render the component under.

By default, all components are rendered on https://web-sandbox.oaiusercontent.com.

"openai/widgetDomain": "https://chatgpt.com"

Since we can’t support dynamic dual-level subdomains, we convert the origin chatgpt.com to chatgpt-com so the final component domain is https://chatgpt-com.web-sandbox.oaiusercontent.com.

We can promise that these domains will be unique to each partner.

Note that we still will not permit the storage or access to browser cookies, even with dedicated subdomains.

Configuring a component domain also enables the ChatGPT punchout button in the desktop fullscreen view.
Configure status strings on tool calls

You can also provide short, localized status strings during and after invocation for better UX:

"_meta": {
  "openai/outputTemplate": "ui://widget/kanban-board.html",
  "openai/toolInvocation/invoking": "Organizing tasks…",
  "openai/toolInvocation/invoked": "Board refreshed."
}

Serve localized content

ChatGPT surfaces your connector to a global audience, and the client will advertise the user’s preferred locale during the MCP initialize handshake. Locale tags follow IETF BCP 47 (for example en-US, fr-FR, es-419). When a server does not echo a supported locale, ChatGPT still renders the connector but informs the user that localization is unavailable. Newer clients set _meta["openai/locale"]; older builds may still send _meta["webplus/i18n"] for backward compatibility.

During initialize the client includes the requested locale in _meta["openai/locale"]:

{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "roots": { "listChanged": true },
      "sampling": {},
      "elicitation": {}
    },
    "_meta": {
      "openai/locale": "en-GB"
    },
    "clientInfo": {
      "name": "ChatGPT",
      "title": "ChatGPT",
      "version": "1.0.0"
    }
  }
}

Servers that support localization should negotiate the closest match using RFC 4647 lookup rules and respond with the locale they will serve. Echo _meta["openai/locale"] with the resolved tag so the client can display accurate UI messaging:

"_meta": {
  "openai/outputTemplate": "ui://widget/kanban-board.html",
  "openai/locale": "en"
}

Every subsequent MCP request from ChatGPT repeats the requested locale in _meta["openai/locale"] (or _meta["webplus/i18n"] on older builds). Include the same metadata key on your responses so the client knows which translation the user received. If a locale is unsupported, fall back to the nearest match (for example respond with es when the request is es-419) and translate only the strings you manage on the server side. Cached structured data, component props, and prompt templates should all respect the resolved locale.

Inside your handlers, persist the resolved locale along with the session or request context. Use it when formatting numbers, dates, currency, and any natural-language responses returned in structuredContent or component props. Testing with MCP Inspector plus varied _meta values helps verify that your locale-switching logic runs end to end.
Inspect client context hints

Operation-phase requests can include extra hints under _meta.openai/* so servers can fine-tune responses without new protocol fields. ChatGPT currently forwards:

    _meta["openai/userAgent"] – string identifying the client (for example ChatGPT/1.2025.012)
    _meta["openai/userLocation"] – coarse location object hinting at country, region, city, timezone, and approximate coordinates

Treat these values as advisory only; never rely on them for authorization. They are primarily useful for tailoring formatting, regional content, or analytics. When logged, store them alongside the resolved locale and sanitize before sharing outside the service perimeter. Clients may omit either field at any time.
Add component descriptions

Component descriptions will be displayed to the model when a client renders a tool’s component. It will help the model understand what is being displayed to help avoid the model from returning redundant content in its response. Developers should avoid trying to steer the model’s response in the tool payload directly because not all clients of an MCP render tool components. This metadata lets rich-UI clients steer just those experiences while remaining backward compatible elsewhere.

To use this field, set openai/widgetDescription on the resource template inside of your MCP server. Examples below:

Note: You must refresh actions on your MCP in dev mode for your description to take effect. It can only be reloaded this way.

server.registerResource("html", "ui://widget/widget.html", {}, async () => ({
  contents: [
    {
      uri: "ui://widget/widget.html",
      mimeType: "text/html",
      text: componentHtml,
      _meta: {
        "openai/widgetDescription": "Renders an interactive UI showcasing the zoo animals returned by get_zoo_animals.",
      },
    },
  ],
}));

server.registerTool(
  "get_zoo_animals",
  {
    title: "get_zoo_animals",
    description: "Lists zoo animals and facts about them",
    inputSchema: { count: z.number().int().min(1).max(20).optional() },
    annotations: {
      readOnlyHint: true,
    },
    _meta: {
      "openai/outputTemplate": "ui://widget/widget.html",
    },
  },
  async ({ count = 10 }, _extra) => {
    const animals = generateZooAnimals(count);
    return {
      content: [],
      structuredContent: { animals },
    };
  }
);

Opt into component borders

Widgets that are better suited for a “Card” layout can opt into having a border rendered by ChatGPT when appropriate.

To use this field, set "openai/widgetPrefersBorder": true on the resource template inside of your MCP server.