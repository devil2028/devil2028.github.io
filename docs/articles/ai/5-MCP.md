
# MCP是什么？

Model Context Protocol (MCP) 是一个开放协议，它使 LLM 应用与外部数据源和工具之间的无缝集成成为可能。无论你是构建 AI 驱动的 IDE、改善 chat 交互，还是构建自定义的 AI 工作流，MCP 提供了一种标准化的方式，将 LLM 与它们所需的上下文连接起来。

最初推出时，仅有 Claude 的桌面应用支持，市场反响平平，且不乏质疑之声。但近期，随着诸多 AI 编辑器 (如 Cursor、Windsurf，甚至 Cline 等插件) 纷纷加入对 MCP 的支持，其热度逐渐攀升，已然展现出成为事实标准的潜力。

# MCP官方架构图
![MCP官方架构图](https://storage.guangzhengli.com/images/MCP.png)

总共分为了下面五个部分：

- MCP Hosts: Hosts 是指 LLM 启动连接的应用程序，像 Cursor, Claude Desktop、Cline 这样的应用程序。
- MCP Clients: 客户端是用来在 Hosts 应用程序内维护与 Server 之间 1:1 连接。
- MCP Servers: 通过标准化的协议，为 Client 端提供上下文、工具和提示。
- Local Data Sources: 本地的文件、数据库和 API。
- Remote Services: 外部的文件、数据库和 API。

整个 MCP 协议核心的在于 Server，因为 Host 和 Client 相信熟悉计算机网络的都不会陌生，非常好理解，但是 Server 如何理解呢？

看看 Cursor 的 AI Agent 发展过程，我们会发现整个 AI 自动化的过程发展会是从 Chat 到 Composer 再进化到完整的 AI Agent。

AI Chat 只是提供建议，如何将 AI 的 response 转化为行为和最终的结果，全部依靠人类，例如手动复制粘贴，或者进行某些修改。

AI Composer 是可以自动修改代码，但是需要人类参与和确认，并且无法做到除了修改代码之外的其它操作。

AI Agent 是一个完全的自动化程序，未来完全可以做到自动读取 Figma 的图片，自动生产代码，自动读取日志，自动调试代码，自动 push 代码到 GitHub。

而 MCP Server 就是为了实现 AI Agent 的自动化而存在的，它是一个中间层，告诉 AI Agent 目前存在哪些服务，哪些 API，哪些数据源，AI Agent 可以根据 Server 提供的信息来决定是否调用某个服务，然后通过 Function Calling 来执行函数。