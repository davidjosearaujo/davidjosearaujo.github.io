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
3. [Limiting](#limiting)
4. [On the shoulders of giants](#on-the-shoulders-of-giants)
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

This is where our lovely simple tools come in handy, especially `strings`, which I came to love even more in the past months. There is an **uncontrollable truth about code**: unless you are willing to write your malware in assembly, you'll need to place strings in it somewhere at some time, and those will never be compiled. And as such, `strings` will find and uncover them.

A string, how simple, how straight forward, they can tell you soo much and it takes soo little effort to find them. That is a key concept in malware analysis and reverse engineering: **don't underestimate you'r opponent but also, don't skip the basic**. Yes some malware developers are VERY sophisticated, but most times, the best way is the easy way.

This being said, `cat` is as valid as `hashcat`, `ZAP` or `Metasploit`. **A simple tool is not a basic tool.** Simple does not mean it does almost nothing, or that it does it in a rudimentary way. Simplicity is efficiency, and efficiency is beautiful.

In that sense, there are few things as beautiful as `strings`. It just looks for sequences of bytes and sees if they fall between the limits for encoded characters. If they do, it prints them to the console. That is it!

The fact is that you can obfuscate your code all you want: **bytes are bytes**. You can cipher them, you can encode them, but when you write them as a string in the code, they are there, and they can't hide from the **almighty power of `strings`**.

# Limiting

It can be limiting however, and **the old saying tells us that "when you'r an hammer, everything is nail", but that isn't exactly correct.** Why? It assumes that the only thing you can do to a nail is punch it, and thus that is the only thing an hammer can do. Well, that is like saying that a since a road it to be driven on, and a car can drive on the road, then the only use for a car is to be driven on the road. **This is a fallacy, as we are limiting the uses of tool based on the idea of what we except an object it interacts with to be or do.**

**A hammer should do more than just punch, because something a nail need to be pulled instead of punched.** And as such, `string` should do more than just read, because sometimes, **strings need to be filtered, decoded, deciphered and interpreted, and not just read**. They key is **finding a balance**. Don't try to do everything, but also do be too limited.

`strings` has proven to be limiting sometimes. I don't mind having to pipe output to `grep` in order to find a specific value, and I also don't mind piping that through `awk` when I need to change the printing format of that value. **But once my 'pipes' begins to look like an interminable chain of commands, that is where it begins to cumbersome, confusing and down right tedious and prone to errors.** And having to try the same commands time and time again until I find the combination is just plain time wasteful, and that I don't have the patience for.

I know what you're going to say: "*That sound like a skill issue*". And it might very well be. I won't deny it. But whatever the reason, I do find this to be limiting problem for my overall work flow, and soo I needed a solution.

# On the shoulders of giants

I need to come up with my own version of the tool.

I don't know who wrote the the original tool, but like most thing in the Unix universe, I assume it was someone with a much better grasp on what they are doing that I probably ever will, and thus, if my tools is and improvement of it, I can only claim that as a personal preference and admire the ingenious idea of the original developers how came up with the original in the first place. I bow down to you!

But enough ass kissing. What do I need to improve upon really? I tried to remember what was the flow and what other tools I usually used in combination with `strings` and that gave me a good idea of what I could add to expand and ease the functionality of the tool.

This is my list:

* If the strings is there, tell me **where** it is.
* 