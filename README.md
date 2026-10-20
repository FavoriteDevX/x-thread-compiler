# X Thread Compiler 🐍

A high-performance, zero-dependency command-line utility built on native .NET/PowerShell architecture designed to capture, parse, and compile public X (formerly Twitter) conversational threads into beautiful, static Markdown (`.md`) files. 

No official developer API keys, Python runtimes, or Node.js/npm overhead required.

---

## ✨ Features

- **Syndication Bypassing:** Seamlessly avoids corporate login walls by routing metadata streams through syndication API micro-nodes.
- **Chronological Restructuring:** Extracts continuous thread segments written by the original author and compiles them sequentially.
- **Media Inlining:** Automatically parses image payload structures and embedded attachments, linking them natively into the markdown body.
- **Ready for Blogs:** The generated `.md` schema is natively structured for immediate deployment into static web setups (Notion, Obsidian, Medium, Dev.to).

---

## 🚀 Quick Start (Terminal Installation)

1. Open **Windows PowerShell** (or PowerShell Core).
2. Download or clone this execution script into your working environment directory.
3. Execute the compiler cmdlet by passing a valid public thread URL:

```powershell
.\Compiler.ps1 -ThreadUrl "https://x.com"
```

## 📂 Data Output Format

Compiled outputs are structured securely into the locally created `CompiledThreads/` subdirectory:
```text
CompiledThreads/
└── jack_20.md  <- Complete readable markdown asset file
```

## 🛑 Limitations & Terms
This tool relies strictly on public syndication feeds for semantic compiling. It respects standard privacy boundaries and cannot fetch threads from private, locked, or protected accounts.
