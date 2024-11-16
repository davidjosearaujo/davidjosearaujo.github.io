+++ 
draft = false
date = 2024-11-08T11:51:38Z
title = "Safety Glasses First"
description = "How to setup for safe malware analysis"
slug = ""
authors = ["David Araújo"]
tags = ["tools", "environment", "safety", "isolation", "malware analysis", "hacking"]
categories = ["/malware-analysis"]
externalLink = ""
series = []
+++

{{< notice info "Table of contents" >}}
1. [Strong roots](#strong-roots)
2. [Vitualization is the name of the game](#vitualization-is-the-name-of-the-game)
3. [Touch it with a stick](#touch-it-with-a-stick)
4. [Clean up and bleach](#clean-up-and-bleach)
5. [Have Fun!](#have-fun)
{{< /notice >}}

I'm paranoid about safety.

As much as I love getting my hands on that new, shiny, (un)known malicious application or scratching that itch of clicking on those sketchy phishing emails I tell myself only idiots click on, the one thing I love more is knowing that after I get bored doing it, my machine will not be infected and that little voice in my head won't be telling me that I need to, again, nuke my disk and re-install my OS.

**Your safety and that of your system are paramount for what we'll be exploring**. So, in this post I'll be sharing with you the **tools and procedures I use/adopt** so I can have fun exploring, but keep peace of mind about the safety of my machine.

# Strong roots

**The OS is the root of everything**. It's what connects simple _syscalls_ with your awesome applications, but it also opens the door for you to completely brick your machine.

Knowing this, at least for me, I think there are two ways of going about choosing your OS:

1. Getting the most user-friendly, out-of-the-box-running, noob-fest, grandma-adoring, stupid-proof OS you can find, or
2. The most raw, no-nonsense, simplest, barebone, can't-break-if-there's-nothing-to-break, the "_I have too much free time_" OS.

Regardless of the route you choose, the two major _distros_ that you'll most probably come up with will be **[Ubuntu](https://ubuntu.com/)** and **[Debian](https://www.debian.org/)**. I won't even lose my time talking about Windows, it's just a joke by now, and if you use Mac for development/research, I would advise you to see a therapist.

## Ubuntu

I'm not going to bash Ubuntu. My take is that, while there are things that don’t make sense and can be straight-up annoying (looking at you, Snap), at the end of the day, when you're developing or researching, you're installing and using tons of different tools and packages, often in early development phases. **Having a system that’s solid and widely compatible with minimal hassle is a huge plus.**

So, Ubuntu fits right into that first option when picking an OS. It’s stupidly simple, pretty permissive out of the box, and while you might run into some dependency issues, it’s an awesome place to start if all you want is an OS you can set up and just start working on.

## Debian

Debian fits into the second option when choosing an OS. It’s an OS you’ll need to configure before you can start working, but there’s a good reason for that -**you’re in control**! Out of the box, Debian comes with almost no pre-installed tools, which is great from a configurability standpoint because it means there’s almost no risk of dependency collisions when adding new ones. The downside of having this much control is that if you’re not careful, **you can easily mess up your system dependencies. So, proceed with caution** and don’t go installing everything willy-nilly.

{{< figure 
    src="/posts/01-safety-glasses-first/with-great-power.jpg"
    height=300vw
>}}

I personally daily drive Debian 12, and it’s been great for me. It gives me the confidence that no matter what I need to work on tomorrow, I’ll be able to run it on my machine and install whatever tools I need without much hassle.

Regardless of the _distro_ you choose, for what I anticipate we’ll cover in the blog, I don’t see the OS being a limiting factor. All you need is **something stable with good compatibility**.

## "_What about Kali?_"

Well, let me tell you something, son: you don’t just install Kali or Parrot OS on your main machine! That’s not only **unsafe** but also **annoying for day-to-day operations**.

[Kali](https://www.kali.org/), [Parrot](https://parrotsec.org/), [Black Arch](https://www.blackarch.org/), [REMnux](https://remnux.org/), and similar _distros_ are meant to be used **live or as temporary sandboxes**, with minimal impact on your core system or its packages. You wouldn't use a scalpel to eat your dinner or butter your toast - it would be annoying and dangerous, right? You use it for a **specific purpose at a specific time**, and when you’re done, **you set it aside to avoid injury or contamination**.

Unlike mainstream _distros_ designed with the user in mind, these specialized _distros_ are **built to package tools** and create an **environment for using them**. They are not made with user or system security as a priority, so installing them on **bare metal and using them as a daily driver only increases your exposure**.

# Vitualization is the name of the game

If you're planning on working with potentially malicious applications, conducting forensic research and recovery, or even bug hunting, **being comfortable with virtualization is essential**. But that's not all, you'll also find the need to make virtualization **programmable and reproducible**, especially when dealing with _POCs_ and forensic work.

## Virtual Machines + Vagrant

{{< figure 
    src="/posts/01-safety-glasses-first/vagrant-virtualbox.png"
    height=200vw
>}}

Vagrant's objective is to make _VM_ creation as streamlined as possible. It was developed with the intent of making provisioning virtual machines as easy as possible for large-scale applications, but we can **use it to spin up _VMs_ pre-configured** with specific contents, network settings, file system status, and more. Basically, you can think of it as a kind of _Docker for VMs_.

I use it all the time, as it is useful not only for development and sharing between team members but also for **replicating environment status** when analyzing malware, for example.

When it comes to _VM_ isolation configuration, it doesn’t get much better than REMnux, in my opinion. If you’re wondering how to set up a _VM_ for maximum isolation,**I suggest downloading the OVA file from the [REMnux documentation page](https://docs.remnux.org/install-_distro_/get-virtual-appliance) and examining how it’s configured, particularly in terms of filesystem sharing and network interfaces**. Consider reading the REMnux documentation thoroughly; it's an excellent resource that **explains the purpose and use of various tools for malware analysis**. It also provides guidance on key steps to follow when researching new applications.

## Containers

Besides _VMs_, nowadays the **easiest way of achieving isolation is containerization**. Although it is relatively secure if used correctly, **it is not 100% isolated from the host**, as it needs to use the system's kernel, network stack, _cgroups_, and namespaces. If we are not careful, **this can allow a malicious application to escape the container**. This can happen due to simple mistakes like poor configurations (e.g., mounting the host filesystem where you shouldn't or using privileged containers) or, in more extreme cases, through process injections.

I'm not saying you shouldn't use containers; there are instances where they are very useful, and I do use them, such as [Parrot OS Docker Images](https://parrotsec.org/docs/cloud/parrot-on-docker/) or [REMnux](https://docs.remnux.org/install-_distro_/remnux-as-a-container). However, you need to be cautious when using them.

# Touch it with a stick

{{< figure 
    src="/posts/01-safety-glasses-first/plague-doctor.avif"
    height=300vw
>}}

## Isolation always

This should be obvious by now, but **it’s the obvious thing we often get wrong**. Isolation isn’t difficult in theory, but it can be tedious. You might ask yourself why you should analyze an application in a _VM_ if you know it won’t affect your system, either because you've set it up to be safe or you already understand the malware's behavior and have prepared for it. But **overconfidence is a dangerous thing**, and **sophisticated malware is often tailored to evade analysis**. It might behave in unexpected ways.

Furthermore, when doing forensics, **you not only need to contain the information you're working on but also protect it from contamination**. Automated services you've set up might interfere without you realizing it, potentially ruining your evidence. **Your _VM_ is your cleanroom!**

## Anchor points

**Snapshots, well and often!** Whether in malware analysis or forensic work, I take snapshots of everything I do. Before decompressing files, before reading, writing, or executing them. Before clicking on links, downloading files, or sending requests. This is not only a **safe practice in case you tamper with or break something**, but also a practical approach **if you need to go back and re-check which steps you’ve taken** during your analysis or exploration.

## Static first

There’s a reason why static analysis comes first, **it’s safer for both you and the file**. Before executing any file, take the time to gather as much information as possible without interacting with it. Static analysis allows you to **examine the file’s metadata, check cryptographic signatures, check for _strings_, and verify the file size and type, all of which can provide crucial insights into its behavior**. Even the file name might give you a clue about its intent or source. By performing these checks, you minimize the risk of accidentally triggering harmful behavior and gain a deeper understanding of the file’s characteristics before it runs.

## Keep your eyes open

Keep `htop` in your back pocket. **Application behavior is often not obvious.** Even a **failed execution might still start a process or inject configurations you didn’t expect** (remember the snapshots I mentioned?). Constant monitoring can be as simple as having `htop` open in a different tab or using `strace`. You’ll need to keep your eyes peeled and pay attention to everything that’s happening. This is another reason why isolation helps: _VMs_ and OSes like REMnux often have very few processes running in the background, which makes it **easier to detect any new processes that pop up**.

## Stay anonymous

Don’t expose personal information during analysis. **When creativity runs dry, it’s tempting to use your own name, contacts, or even passwords while testing malware.** Even with isolation in place, many types of malware, especially phishing schemes or trojans, can communicate with remote services without your knowledge. **Always assume that while you may have isolated your system from the malware, the malware itself may not be isolated from the outside world!**

# Clean up and bleach

{{< figure 
    src="/posts/01-safety-glasses-first/consuela-family-guy.gif"
    height=300vw
>}}

When you’ve finally finished your analysis, it’s time to clean up after yourself! This step is as important as any other, because leaving behind "trash" can pose a real danger when you least expect it. **Forgotten remnants can come back to "cut" you when overlooked.**

## Don't get attached

We use _VMs_ and containers for a reason: they're easy to spin up and take down. **Resist the temptation to reuse the same environment repeatedly.** The _VM_ you used two months ago to test ransomware and then forgot about is not safe for analyzing a new binary. Trust me, when you enable that shared directory to copy the new file, it will come back to bite you.

## Delete or secure every trace

Often, legitimate sources are used to download malware for testing, typically packaged in password-protected zip or tarball files on your host before being transferred to the _VM_ via `scp` or _drag & drop_. You might even develop scripts on the host to aid in testing. While there’s nothing inherently wrong with this, I still don’t like leaving TNT lying around on my carpet. So, please, delete any binaries you’re not actively analyzing. If it’s rare malware or a tool you’ve developed, at the very least, secure it in a password-protected compressed file, encrypted directories, or even better, cold storage.

# Have Fun!

At the end of the day, this is what we’re here for, right? It’s exhilarating to play with fire and not get burned. While I can’t promise that you’ll never get burned, that would be unrealistic, there are measures you can take to minimize the chances and mitigate the consequences when it does happen. These safeguards provide the peace of mind needed to focus on your research and make great discoveries.

So go ahead, and have fun **bricking the heck out of your _VMs_**!