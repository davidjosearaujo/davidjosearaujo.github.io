+++ 
draft = true
date = 2024-11-21T15:51:16Z
title = "Everything Is A File"
description = "When you don't know what to do, just remember: _everything is a file_"
slug = ""
authors = ["David Araújo"]
tags = ["research", "forensics", "exploitation", "malware analysis", "hacking", "reverse engineering"]
categories = ["/file-system"]
externalLink = ""
series = []
+++

{{< notice info "Table of contents" >}}
1. [What is a file?](#what-is-a-file)
2. [What can we learn about a file?](#what-can-we-learn-about-a-file)
3. [What types of files are there?](#what-types-of-files-are-there?)
4. [What file is this?](#what-file-is-this?)
5. [Don't know it? Read it!](#don't-know-it?-read-it)
{{< /notice >}}

# What is a file?

Files, everything is a file! You may or may not have ever heard this regarding Linux. It is quite a popular saying amongst Linux enthusiasts, but besides being a catchy sentence, what does this actually mean?

Well, first we need to discuss **what is a file** in its essence. Not  even a digital file necessarily, but a file as a concept really.

A files is a *thing* that hold information in a structured way, and with which you can interact with to access with that information. And how do you interact with it? Think of a notebook, you can pick it up and open it, you can read it, you can write on it, you can erase something that was previously written and at the end you can close it! With a combination you this simple interaction you can perform others too, you can create copies of you notebooks, you can create new notebooks, you can give someone your notes and they can give you theirs. You can do a LOT with this *thing* that hold information.

Taking this basic interaction into account: open, read, write and close, and how universal they are, the creators of Unix came up with the brilliant, and simplistic (wonderful how much these two go hand in hand by the way), idea of: why not treating everything like if it was a file, and then we can use the same set of API for all these tasks? And that is exactly what they did!

## File Descriptors

This universality regarding the API could only be achieved by implementing something called **file descriptors**. These are process-unique integers used to represent files or I/O resources that can be used by system calls to interact with resources by telling the kernel how the process wishes to access the file.

There are 3 file descriptors in the POSIX API:

| Integer | Name | Description |
| :-: | :-: | - |
| 0 | Standard Input (`stdin`) | This is a stream from which a program can read input data by using the *read* operation. Like when a program read the input from the keyboard. |
| 1 | Standard Output (`stdout`) | This is a stream to which a program writes its output data by using the *write* operation. Not all programs generate output, but when they do the most common use it to directed to some specific location like a file of simply to the text terminal in the case of an interactive shell. |
| 2 | Standard Error (`stderr`)| Like `stdout`, it is also an output but specifically for displaying error or diagnostic messages. Being independent of the `stdout` gives us the opportunity to handle its stream separately. |

# *Is my red blue for you, or my green your green, too?*

> "How do I know that you and me\
> See the same colors the same way when you and me see?\
> Is my red blue for you, or my green your green, too?\
> Could it be true we see differing hues?"\
> \- in *[Thoughtful Guy](https://www.youtube.com/watch?v=U6y7YOlldek)*, by Rhett and Link

Besides being a cool verse and a deep philosophical question, it is also a question we have to ask regarding files. Does the OS see files the same way I do?

Regarding the colors, I have absolutely no idea, but regarding files the answer is no. For the OS, a file is represented as an *inode*, a structure that contains metadata about the file, these include creation date, last update date, ownership, permissions, size and most importantly, it keeps a pointer towards the memory block in the memory where the files data is actually stored.

Too see all the information that is stored in an *inode* (and more), you can simply use de command `ls -il`, let's try it!

```bash
remnux@00cd6cd99d6f:/var/log$ ls -il
total 1824
37128568 drwxr-xr-x 4 remnux     remnux             4096 Mar 10  2023 networkminer
```

Lets go through what e see here from left to right:
- First we have the ***inode* number**. This number is indexed in the file systems **inode table** and with this index the kernel is capable of accessing the inode's content and the file's location, allowing the kernel to retrive said file.
- Then we have a list of characters and dashes, these and the file's **type an permissions**. If your reading this, you'll probably already know wha they mean, but lets go over it just in case.
    - The first character tells you the **type** of the file. There are **7 types** (we'll go over this in more detail later but the options are):
        - **\-** Regular
        - **d** Directory
        - **l** Symbolic link
        - **b** Block
        - **c** Character
        - **s** Socket link
        - **p** FIFO
    - The next three characters (in our case `rwx`) are the **files owner** permissions.
    - The next three (`r-x`) are the **group** permissions.
    - And the next three (`r-x`) are the **others** permissions.

{{< notice tip "Representing permissions" >}}
Permissions follow a simple representation standard where `r` is for **read**, `w` is for **write**, `x` is for **execute** and `-` for **no permission**.

They are always in the same order, `r` then `w` then `x`, as this is tight to a binary representation of three bits, where each character can be represented by a `1` or a `0` if it were a `-`. What does this mean? Means that `rwx` is the same as `111` (or 6 in decimal), and `r-x` is `101` (or 5 in decimal), and if we put all of the three sets of three characters together, our files permission of `rwxr-xr-x` could also be represented as `655`.
{{< /notice >}}

- Then we have the **number of hard link** to this file. Links are quite interesting, and something I think you'll enjoy [reading about](https://en.wikipedia.org/wiki/Hard_link), but just to be brief, did you notice I didn't mention the *name* of the file as being something the *inode* holds as metadata? Well that is because a file doesn't actually **have** one, it is **linked** to one rather, and the **hard link** is what represents this association between a file and a name (this happens because things such as directories exist, we will touch on this subject later).
- Owner name.
- Group name.
- Number of bytes in your file (size).
- Date of the last modification.
- And the name of the file (which we already know it's not in the *inode*)

For more information that this regarding a file, you can also use the `stat` command, which will also give you things like: when the file was last access, modified and created, it's IO Block, among other things.

# What types of files are there?

Now that we understand the concept of what a file is and how a file is treated by the system, we need to narrow down **types of files there are**, because although it is very cool to say *everything* is a file, we need to know how big this *everything* really is and what we can expect to encounter.

In reality, *everything* means **seven**, which maybe is not as big as you though, but it is still more then enough trust me. These standard Unix files types are defined by POSIX, although specific OSs can define their own beyond these, but leaving that aside, let's take a look at each one.

## Regular

These are the "common" files that you typically call quintessential file. These can be anything from scripts, images, videos, audios, compressed folder (zip, 7z, ...), documents, program-specific-format files like XML, DOCX, PDf, and many other.

Because files can be soo many things and hold so many types of different information depending on their use, Unix does not impose or provide any specific internal structure for this regular file type, this is entirely up to the program using them.

But if you want to know what a file is? Well, although there is not an imposed structure, there are always conventions,standard and programs that are soo universally used that even if you don't recognize it (or it is **hidden from you**!!), the `file` command will usually be able to tell you what type of file it is.

TODO: 2º Continue

# What file is this?