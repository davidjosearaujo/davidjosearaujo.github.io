+++ 
draft = true
date = 2025-11-02T12:03:09Z
title = "Old But Gold"
description = "More than words"
slug = ""
authors = ["David Araújo"]
tags = ["forensics", "malware analysis", "reverse engineering", "tools"]
categories = ["/tools"]
externalLink = ""
series = []
+++

{{< notice info "Table of contents" >}}
1. [Amazing is simple](#amazing-is-simple)
2. [Simple isn't basic](#simple-isn't-basic)
3. [Quick and easy](#quick-and-easy)
{{< /notice >}}

{{< notice tip "Project page" >}}

Like usual, you can find all documents and code [here](https://github.com/davidjosearaujo/stringx)

{{< /notice >}}

So, before continuing, I must tell you the context of this post. I recently finished college (hurray for me!) and I started working for Cognizant doing Android Reverse Engineering for Google. Due to that, I got a whole new appreciation for these tools.

# Amazing is simple

The most practical tools are not complex; they are practical precisely because they are easy to use. They are there when you need them and don't make you question yourself about if you have the skills to use them or you're just a dumbass.

Linux throughout its history has collected a huge amount of these amazing tools, such as `file`, `diff`, `grep`, `cat`, `strings`, and so many others. I could spend the day going through their `man` pages. Each of these is cleverly simple and limited to a specific use and purpose. Like a chef's knife is awesome at cutting food but terrible at, say, unscrewing a bolt, these tools don't do much, but what they do, they do it perfectly!

And that is why they are amazing.

When you want to read the content of the file, you just "*cat it*." You don't care about the format of the encoding or indentation, you just look inside, and you don't need a space suit for the first floor!

# Simple isn't basic

When you're reversing malware, you expect that most tools won't do you much good, as the developers have gone to great lengths to obfuscate whatever it is they are trying to accomplish. Consequently, you can quickly become frustrated if you just go from tool to tool trying to magically figure it out.

You can also go the opposite route and look in places like [REMnux Docs](https://docs.remnux.org/) for the precise tool for the occasion, which is something I definitely do sometimes.

This is where our lovely simple tools come in handy, especially `strings`, which I came to love even more in the past months. There is an **uncontrollable** truth about code: unless you are willing to write your malware in assembly, you'll need to place strings in it somewhere at some time, and those will never be compiled. And as such, `strings` will find and uncover them.

A simple tool is not a basic tool. Simple does not mean it does almost nothing, or that it does it in an "ugly" way. Simplicity is efficiency, and efficiency is beautiful.

In that sense, there are few things as beautiful as `strings`. It just looks for sequences of bytes and sees if they fall between the limits for encoded characters. If they do, it prints them to the console. That is it!

The fact is that you can obfuscate your code all you want: **bytes are bytes**. You can cipher them, you can encode them, but when you write them as a string in the code, they are there, and they can't hide from the **almighty power of `strings`**.