+++ 
draft = true
date = 2024-11-08T11:51:38Z
title = "Safety Glasses First"
description = "How to setup for safe malware analysis"
slug = ""
authors = ["David Araújo"]
tags = ["cybersecurity", "tools", "malware-analysis", "hacking"]
categories = ["/malware-analysis"]
externalLink = ""
series = []
+++

{{< notice info "Table of contents" >}}
1. [Operating System](#operating-system)
2. [Vitualization is the name of the game](#vitualization-is-the-name-of-the-game)
{{< /notice >}}


I'm paranoid about safety.

As much as I love getting my hands on that new, shiny, (un)known malicious application or scratching that itch of clicking on those sketchy phishing emails I tell myself only idiots click on, the one thing I love more is knowing that after I get bored doing it, my machine will not be infected and that little voice in my head won't be telling me that I need to, again, nuke my disk and re-install my OS.

**Your safety and that of your system are paramount for what we'll be exploring**. So, in this post I'll be sharing with you the **tools and procedures I use/adopt** so I can have fun exploring, but keep peace of mind about the safety of my machine.

# Operating System

<!-- TODO: add link to these distros-->

**The OS is the root of everything**. It's what connects simple _syscalls_ with your awesome applications, but it also opens the door for you to completely brick your machine.

Knowing this, at least for me, I think there are two ways of going about choosing your OS:

1. Getting the most user-friendly, out-of-the-box-running, noob-fest, grandma-adoring, stupid-proof OS you can find, or
2. The most raw, no-nonsense, simplest, barebone, can't-break-if-there's-nothing-to-break, the "_I have too much free time_" OS.

Regardless of the route you choose, the two major distros that you'll most probably come up with will be **[Ubuntu](https://ubuntu.com/)** and **[Debian](https://www.debian.org/)**. I won't even lose my time talking about Windows, it's just a joke by now, and if you use Mac for development/research, I would advise you to see a therapist.

## Ubuntu

I'm not going to bash Ubuntu. My take is that, while there are things that don’t make sense and can be straight-up annoying (looking at you, Snap), at the end of the day, when you're developing or researching, you're installing and using tons of different tools and packages - often in early development phases. Having a system that’s solid and widely compatible with minimal hassle is a huge plus.

So, Ubuntu fits right into that first option when picking an OS. It’s stupidly simple, pretty permissive out of the box, and while you might run into some dependency issues, it’s an awesome place to start if all you want is an OS you can set up and just start working on.

## Debian

Debian fits into the second option when choosing an OS. It’s an OS you’ll need to configure before you can start working, but there’s a good reason for that -**you’re in control**! Out of the box, Debian comes with almost no pre-installed tools, which is great from a configurability standpoint because it means there’s almost no risk of dependency collisions when adding new ones. The downside of having this much control is that if you’re not careful, **you can easily mess up your system dependencies. So, proceed with caution** and don’t go installing everything willy-nilly.

{{< figure 
    src="/posts/01-safety-glasses-first/with-great-power.jpg"
    height=300vw
>}}

I personally daily drive Debian 12, and it’s been great for me. It gives me the confidence that no matter what I need to work on tomorrow, I’ll be able to run it on my machine and install whatever tools I need without much hassle.

Regardless of the distro you choose, for what I anticipate we’ll cover in the blog, I don’t see the OS being a limiting factor. All you need is **something stable with good compatibility**.

## "_What about Kali?_"

Well, let me tell you something, son: you don’t just install Kali or Parrot OS on your main machine! That’s not only **unsafe** but also **annoying for day-to-day operations**.

[Kali](https://www.kali.org/), [Parrot](https://parrotsec.org/), [Black Arch](https://www.blackarch.org/), [REMnux](https://remnux.org/), and similar distros are meant to be used **live or as temporary sandboxes**, with minimal impact on your core system or its packages. You wouldn't use a scalpel to eat your dinner or butter your toast - it would be annoying and dangerous, right? You use it for a **specific purpose at a specific time**, and when you’re done, **you set it aside to avoid injury or contamination**.

Unlike mainstream distros designed with the user in mind, these specialized distros are **built to package tools** and create an **environment for using them**. They are not made with user or system security as a priority, so installing them on **bare metal and using them as a daily driver only increases your exposure**.

# Vitualization is the name of the game

And that is were virtualization comes in, when the goal minimizing exposure, there aren't much better options than it.

If your planning on working with potentially malicious applications, doing forensic research and recovery or even bug hunting, being comfortable with virtualization is a must have. But not only that, you'll find the need to make virtualization programmable and reproducible (especially when dealing with _POCs_ and forensics).

## Virtual Machines + Vagrant

{{< figure 
    src="/posts/01-safety-glasses-first/vagrant-virtualbox.png"
    height=200vw
>}}

<!-- TODO -->

## Containers

Beside VMs, nowadays the easiest way of achieving is containerization, and although it is pretty secure if used correctly, it is not 100% isolated from the host as it need to use the systems kernel, network stack, _cgroups_ and namespaces, and if we are not careful this can allow an malicious application to escape the container. This can happen with easy mistakes like poor configurations, like mounting the host filesystem were you shouldn't, using privileged containers, or in some more extreme cases with process injections.

I'm not saying you shouldn't use containers, as there are instances where they are really useful and I do use them, like the [Parrot OS Docker Images](https://parrotsec.org/docs/cloud/parrot-on-docker/), or [REMnux](https://docs.remnux.org/install-distro/remnux-as-a-container), but you do need to be careful when doing so.
