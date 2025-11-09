+++ 
draft = false
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
2. [Simple isn't basic](#simple-isnt-basic)
3. [Limitations](#limitations)
4. [On the shoulders of giants](#on-the-shoulders-of-giants)
5. [Quick and easy](#quick-and-easy)
{{< /notice >}}

{{< notice tip "Project page" >}}

Like usual, you can find all documents and code [here](https://github.com/davidjosearaujo/stringx)

{{< /notice >}}

So, before continuing, I must tell you the context of this post. I recently finished college (hurray for me!) and I started working for Cognizant doing Android Reverse Engineering for Google. Due to that, I got a whole new appreciation for what we'll be discussing today.

# Amazing is simple

The most practical tools are not complex; they are practical precisely because they are easy to use. They are there when you need them and don't make you question yourself about if you have the skills to use them or you're just a dumbass.

Linux throughout its history has collected a huge amount of these amazing tools, such as `file`, `diff`, `grep`, `cat`, `strings`, and so many others. I could spend the day going through their `man` pages. Each of these is cleverly simple and limited to a specific use and purpose. Like a chef's knife is awesome at cutting food but terrible at, say, unscrewing a bolt, these tools don't do much, but what they do, they do it perfectly!

And that is why they are amazing.

When you want to read the content of the file, you just "*cat it*." You don't care about the format of the encoding or indentation, you just look inside, and you don't need a space suit for the first floor!

# Simple isn't basic

When you're reversing malware, you expect that most tools won't do you much good, as the developers have gone to great lengths to obfuscate whatever it is they are trying to accomplish. Consequently, you can quickly become frustrated if you just go from tool to tool trying to magically figure it out.

You can also go the opposite route and look in places like [REMnux Docs](https://docs.remnux.org/) for the precise tool for the occasion, which is something I definitely do sometimes.

This is where our lovely simple tools come in handy, especially `strings`, which I came to love even more in the past months. There is an **uncontrollable truth about code**: unless you are willing to write your malware in assembly, you'll need to place strings in it somewhere at some time, and those will never be compiled. And as such, `strings` will find and uncover them.

A string, how simple, how straight forward, they can tell you soo much and it takes soo little effort to find them. That is a key concept in malware analysis and reverse engineering: **don't underestimate your opponent but also, don't skip the basics**. Yes some malware developers are VERY sophisticated, but most times, the best way is the easy way.

This being said, `cat` is as valid as `hashcat`, `ZAP` or `Metasploit`. **A simple tool is not a basic tool.** Simple does not mean it does almost nothing, or that it does it in a rudimentary way. Simplicity is efficiency, and efficiency is beautiful.

In that sense, there are few things as beautiful as `strings`. It just looks for sequences of bytes and sees if they fall between the limits for encoded characters. If they do, it prints them to the console. That is it!

The fact is that you can obfuscate your code all you want: bytes are bytes. You can cipher them, you can encode them, but when you write them as a string in the code, they are there, and they can't hide from the almighty power of `strings`.

# Limitations

It can be limiting, however, and **the old saying tells us that "when you're a hammer, everything is a nail," but that isn't exactly correct.** Why? It assumes that the only thing you can do to a nail is punch it, and thus that is the only thing a hammer can do. Well, that is like saying that since a road is to be driven on, and a car can drive on the road, then the only use for a car is to be driven on the road. **This is a fallacy, as we are limiting the uses of a tool based on the idea of what we expect an object it interacts with to be or do.**

**A hammer should do more than just punch, because sometimes a nail needs to be pulled instead of punched.** And as such, `strings` should do more than just read, because sometimes, **strings need to be filtered, decoded, deciphered, and interpreted, not just read**. The key is finding a balance. Don't try to do everything, but also don't be too limited.

`strings` has proven to be limiting sometimes. I don't mind having to pipe output to `grep` in order to find a specific value, and I also don't mind piping that through `awk` when I need to change the printing format of that value. **But once my 'pipes' begin to look like an interminable chain of commands, that is where it becomes cumbersome, confusing, and downright tedious and prone to errors.** Having to try the same commands time and time again until I find the combination is just plain time wasteful, and that I don't have the patience for.

I know what you're going to say: "*That sounds like a skill issue*". And it might very well be. I won't deny it. But whatever the reason, I do find this to be a limiting problem for my overall workflow, and so I needed a solution.

# On the shoulders of giants

I need to come up with my own version of the tool.

I don't know who wrote the original tool, but like most things in the Unix universe, I assume it was someone with a much better grasp on what they are doing than I probably ever will, and thus, if my tool is an improvement of it, I can only claim that as a personal preference and admire the ingenious idea of the original developers who came up with the original in the first place. I bow down to you!

But enough ass kissing. What do I need to improve upon really? I tried to remember what was the flow and what other tools I usually used in combination with `strings`, and that gave me a good idea of what I could add to expand and ease up the functionality of the tool.

This is my list.

1. If the string is there, tell me **where** it is. If I run the tool in a directory, I want to know to which file each string belongs, and in which file, in which line and column.

```shell
$ stringx /bin/bash
/bin/bash:7:90:C<!A&Y
/bin/bash:7:99:/lib64/ld-linux-x86-64.so.2
/bin/bash:9:58: $DJ
/bin/bash:10:40:CDDB
...
```

2. Size matters. I don't care what you think, big strings are usually more interesting, so I want to be able to **filter the results by length**. I should be able to specify a minimum (`MIN:`), a maximum (`:MAX`), and something in between (`MIN:MAX`).

```shell
$ stringx /bin/bash -l 10:50
/bin/bash:7:99:/lib64/ld-linux-x86-64.so.2
/bin/bash:264:49:_ITM_deregisterTMCloneTable
/bin/bash:264:77:__gmon_start__
/bin/bash:264:92:_ITM_registerTMCloneTable
...
```

3. If you ***ascii*** me, UTF-8 is king, but different files use different encodings, so I want to be able to **choose which encoding to use** when reading.

```shell
$ stringx /bin/bash -e ascii
/bin/bash:7:90:C<!A&Y
/bin/bash:7:99:/lib64/ld-linux-x86-64.so.2
/bin/bash:9:58: $DJ
/bin/bash:10:40:CDDB
...
```

4. Obfuscation is a real thing, as Base-64 or Hex are very common, so why not recursively **auto-decode strings** that may appear in those formats?

```shell
$ echo "Don't look! I'm a secret!" | base64 | base64 > /tmp/file.txt
$ stringx -d base64 /tmp/file.txt 
/tmp/file.txt:1:1:Ukc5dUozUWdiRzl2YXlFZ1NTZHRJR0VnYzJWamNtVjBJUW89Cg==
  /tmp/file.txt->base64@0:1:1:RG9uJ3QgbG9vayEgSSdtIGEgc2VjcmV0IQo=
    /tmp/file.txt->base64@0->base64@0:1:1:Don't look! I'm a secret!
```

5. Perhaps the biggest issue with `strings` is that it is a "dumb" tool, it just tries to print everything and you end up with a lot of noise. Usually, **natural languages happen to have a higher entropy**, so an entropy filter could provide some noise reduction on the output.

```shell
$ stringx /bin/bash --entropy 1
/bin/bash:7:90:C<!A&Y
/bin/bash:7:99:/lib64/ld-linux-x86-64.so.2
/bin/bash:9:58: $DJ
/bin/bash:10:40:CDDB
...
```

```shell
$ stringx /bin/bash --entropy 4
/bin/bash:264:19375:_rl_completion_prefix_display_length
/bin/bash:264:38370:stop_making_children
/bin/bash:264:39761:bash_groupname_completion_function
/bin/bash:264:40748:bash_default_completion
...
```

6. Why do use `strings`? **To find stuff!** And I would bet that 99.9% of the times, you combine it with `grep`, right? Of course you do! So why not just have a **built-in regex filter** to find what you need?

```shell
$ stringx /bin/bash -r "GNU"
/bin/bash:2562:13:'\''GNU bash, version %s-(%s)
/bin/bash:2563:22:GNU long options:
/bin/bash:2589:980:GNU bash, version %s (%s)
/bin/bash:2650:168:Usage:       %s [GNU long option] [option] ...
...
```

7. What if you don't know what you're searching for? Well, **you may know what you are NOT searching for**, so an **excluding regex filter** may help you clear out the irrelevant results.

```shell
$ stringx /bin/bash --entropy 4.1
/bin/bash:2650:168:Usage:       %s [GNU long option] [option] ...
/bin/bash:2651:1:       %s [GNU long option] [option] script-file ...
/bin/bash:2652:9:       -ilrsD or -c command or -O shopt_option         (invocation only)
/bin/bash:2653:5:Type `%s -c "help set"' for more information about shell options.
...
```

```shell
$ stringx /bin/bash --entropy 4.1 -x "GNU"
/bin/bash:2652:9:       -ilrsD or -c command or -O shopt_option         (invocation only)
/bin/bash:2653:5:Type `%s -c "help set"' for more information about shell options.
/bin/bash:2654:7:Type `%s -c help' for more information about shell builtin commands.
/bin/bash:2655:4:Use the `bashbug' command to report bugs.
/bin/bash:2656:7:bash home page: <http://www.gnu.org/software/bash>
...
```

8. Especially in reverse engineering, you like to search for **key information** that has a very **specific format, like IPs, URLs, emails, and hashes**, so a pre-defined list of format filters should be included.

```shell
$ stringx /bin/bash -f url
/bin/bash:2656:7:bash home page: <http://www.gnu.org/software/bash>
/bin/bash:2657:6:General help using GNU software: <http://www.gnu.org/gethelp/>
/bin/bash:2659:5375:License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
```

```shell
$ stringx /bin/bash -f email
/bin/bash:2586:163:bash-maintainers@gnu.org
```

9. I don't need to scroll through the results just to see the same word printed one hundred times; I just want to know if it is there! A ***unique* filter can show me every different word occurrence that exists**. If I want to know how many times it occurs, I'm not going to count them; I'll just use the ***count* filter, which will also show a unique word list but with the amount of occurrences of each word**.

```shell
$ stringx /bin/bash | wc -l
12138
```

```shell
$ stringx /bin/bash --unique | wc -l
7213
```

```shell
$ stringx /bin/bash --count | wc -l
7213
```

```shell
$ stringx /bin/bash --count
    351 []A\A]A^A_
    266     
    227 []A\
    207 []A\A]
    157 \$HL
    126 AWAVAUATUSH
...
```

10. Nowadays, data ingestion for automation is crucial, so an option to **output the results in JSON format** can be very useful when using this tool to feed data into others.

```shell
$ stringx /bin/bash --json
{"column":90,"entropy":2.585,"file":"/bin/bash","length":6,"line":7,"offset":907,"string":"C\u003c!A\u0026Y"}
{"column":99,"entropy":3.8562,"file":"/bin/bash","length":27,"line":7,"offset":916,"string":"/lib64/ld-linux-x86-64.so.2"}
{"column":58,"entropy":2,"file":"/bin/bash","length":4,"line":9,"offset":1117,"string":" $DJ"}
...
```

11. Finally, like in the use case for using the exclude option, I may not know what I'm looking for, but I may know that it fits in a certain category or format. I may want to know if there are emails with certain domains, or URLs with certain subdomains, or mentions or usernames, among others. This is a common approach we see in active discovery techniques like ***fuzzing*** URLs, so why not apply it here? We should be able to **specify a wordlist file, and get only the results that match within the target file I'm searching**.

```shell
$ stringx /bin/bash -w /usr/share/seclists/Fuzzing/os-names.txt
/bin/bash:2562:13:'\''GNU bash, version %s-(%s)
/bin/bash:2563:22:GNU long options:
/bin/bash:2589:980:GNU bash, version %s (%s)
/bin/bash:2650:168:Usage:       %s [GNU long option] [option] ...
...
```

# Quick and easy

This is it. The goals are clear, concise, and do not **overcomplicate** the tool in such a way that it becomes impractical or cumbersome to use.

To accomplish this, I opted to use Go, because I love pretty much everything about it—its simplicity to code, its explicitness, its structure, and its build and runtime efficiency are also great.

I decided to also try to "collaborate" with Gemini and see how far AI tools have progressed in writing code, and I must say I was pleasantly surprised, although still have to tweak some aspects myself. But overall, a very good experience and a good way to iterate quickly and ease up the development cycle.

Ultimately, `strings` remains a classic for a reason: simplicity breeds utility. But as our tasks in reverse engineering and forensics evolve, our tools must, too. Creating `stringx` wasn't about replacing a giant; it was about building on its foundation to ease my own workflow, adding those necessary features like decoding and filtering right where I needed them. I hope this journey, built with the power of Go and a little help from AI, inspires you to look closer at the "old gold" in your toolkit and consider how you might shape it for tomorrow's challenges. You can check out the full source code and give `stringx` a try yourself at the link above. Happy reversing!