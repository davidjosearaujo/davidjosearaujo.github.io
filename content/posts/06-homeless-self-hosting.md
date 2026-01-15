+++ 
draft = false
date = 2026-01-15T22:07:56Z
title = "Homeless Self Hosting"
description = "Hosting your own script, automating your own flows, doesn't mean you need a server, just means you need an environment."
slug = ""
authors = ["David Araújo"]
tags = ["home server", "environment", "tools"]
categories = ["/home-server"]
externalLink = ""
series = []
+++

{{< notice info "Table of contents" >}}

1. [As specific as it is simple](#as-specific-as-it-is-simple)
2. [I needed a coach](#i-needed-a-coach)
3. [All hail Apps Script](#all-hail-app-script)
4. [The Architecture: No Server, No Problem](#the-architecture-no-server-no-problem)
5. [The 'Secret Sauce': Gemini 2.5 Pro](#the-secret-sauce-gemini-25-pro)
6. [Conclusion: The Environment is the Message](#conclusion-the-environment-is-the-message)

{{< /notice >}}

{{< notice tip "Project page" >}}
Like usual, you can find all documents and code here
{{< /notice >}}

{{< notice tip "Project page" >}}

Like usual, you can find all documents and code [here](https://github.com/davidjosearaujo/gemini-automated-running-coach)

{{< /notice >}}

# Has specific as it is simple

In this cookie-cutter world, we have managed to make ourselves fit in whatever shape fits the majority. One benefit of the constant growth of technology is that for a tool to stand out, it tries to solve a never-before-approached issue and appeal to a niche market. This constant reach for the edges presents us with an increasing chance of finding the cookie that perfectly fits us.

However, there will never be a perfect solution. No stakeholder requirement analysis will ever account for my every specific need or preference. Eventually, if I have a specific problem, I’ll have to come up with my own specific solution. But I also can't fool myself: this isn't a viable commercial product. It's just a tool for me. And that’s where the "homeless" part comes in.

# I needed a coach

I like to run—very, very much. I have a training plan, but I’ve never had a human coach. Lately, AI tools have become so good that I’ve started using Gemini as my running coach by asking it to generate my weekly plan.

This sounds easy, but for it to work, I had to:

1. Download metrics from my previous week's training (for context).
2. Upload them to the chat.
3. Explain my current fatigue and goals.
4. Refine the plan through conversation.

It was effective, but incredibly boring to do every Sunday night. This is the typical scenario where an automated system can come in handy: repetitive tasks with multiple steps. It’s also a perfect scenario for a home server... which I no longer have.

# All hail App Script

For those who do not know, Google Apps Script is a cloud-based JavaScript tool for running scripts that interact with the Google ecosystem. It’s how Add-ons for Docs and Sheets are built. The fascinating thing is that it’s a free platform where you can host scripts to perform almost anything.

Since I’m already in the Google ecosystem, this was the missing piece. I could create a script to fetch my training metrics from the Coros platform, pass them to Gemini with a pre-written prompt, and email the resulting training plan to myself.

# The Architecture: No Server, No Problem

The architecture of this "homeless" project is a pipeline of data transformation designed to run entirely in the cloud without a dedicated machine. Since I don't have a traditional database, I used the built-in storage services provided by the environment to handle my API keys and credentials, managed through a custom web interface.

The workflow is a three-stage rocket:

- **The Bridge:** The system logs into the Coros API and fetches raw activity data. Instead of just passing raw text to the AI, I programmatically build a temporary spreadsheet. This gives the data structure (Lactate Threshold zones, Heart Rate Reserve, and per-activity metrics) without needing a heavy SQL setup.
- **The Virtual Document:** Here is the trick: I export that temporary data as a PDF. Large Language Models have been trained extensively on document layouts; a PDF of a table is often interpreted more reliably than a massive, messy string of text. It mimics the "paper" a real coach would look at.
- **The Long-Term Memory:** I maintain a "Season Plan" document that lists my major races and target dates. This acts as the "Static Context" that informs the AI's long-term strategy, ensuring it doesn't suggest a massive mountain run the week before a goal race.

# The 'Secret Sauce': Gemini 2.5 Pro

The intelligence layer uses the Gemini 2.5 Pro model, taking advantage of its massive context window and ability to process multiple documents at once. The automation constructs a package containing the visual data of my recent performance and the roadmap of my season.

The System Instruction is the most critical part of the design. It doesn't just ask for a plan; it enforces a specific coaching philosophy:

> _"You are a performance running coach specializing in endurance trail racing. Rules: Base sessions on specific effort zones, ensure proper warm-ups and cooldowns, and pay strict attention to race tapering."_

To ensure reliability, I implemented a retry system. Cloud-based triggers can occasionally hit a snag or an API limit, so the system attempts to reach the AI several times with increasing delays. This ensures that when the Monday morning trigger fires, the plan actually reaches my inbox while I'm waking up.

# Conclusion: The Environment is the Message

We often think that "self-hosting" requires a physical box — a Raspberry Pi or a rack of servers with blinking lights in a closet. We equate ownership of hardware with ownership of the process. But this project proved to me that the environment is more important than the hardware. By using this serverless infrastructure, I am "homeless" in the sense that I have no fixed physical address for my code. Yet, I am more "at home" than ever because the automation is perfectly tailored to my life. I’ve built a system that costs nothing to run, requires zero maintenance, and leverages world-class AI to solve a niche problem.

Self-hosting isn't about the server; it's about the sovereignty of the logic. I don't own the data centers, but I own the logic that dictates how my data is handled and how my week is planned. In a world of cookie-cutter apps, building your own "homeless" environment is the ultimate way to get the perfect cookie.

Now, if you'll excuse me, my coach says I have an interval session today, and it doesn't like to be kept waiting.