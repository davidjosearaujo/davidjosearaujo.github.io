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

- Then we have the **number of hard link** to this file. Links are quite interesting, and something I think you'll enjoy [reading about](https://en.wikipedia.org/wiki/Hard_link), but just to be brief, did you notice I didn't mention the *name* of the file as being something the *inode* holds as metadata? Well that is because a file doesn't actually **have** one, it is **linked** to one rather, and the **hard link** is a file representation of this association between a file content and a name, so all files will have at least one hard link (this happens because things such as directories exist, we will touch on this subject later).
- Owner name.
- Group name.
- Number of bytes in your file (size).
- Date of the last modification.
- And the name of the file (which we already know it's not in the *inode*)

For more information that this regarding a file, you can also use the `stat` command, which will also give you things like: when the file was last access, modified and created, it's IO Block, among other things.

```bash
remnux@25bdfcf5df91:/var/log$ stat alternatives.log 
  File: alternatives.log
  Size: 63157     	Blocks: 128        IO Block: 4096   regular file
Device: 32h/50d	Inode: 37128551    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2023-03-10 04:07:39.000000000 +0000
Modify: 2023-03-10 04:07:39.000000000 +0000
Change: 2025-01-31 09:39:34.999892789 +0000
 Birth: -
```

# What types of files are there?

Now that we understand the concept of what a file is and how a file is treated by the system, we need to narrow down **types of files there are**, because although it is very cool to say *everything* is a file, we need to know how big this *everything* really is and what we can expect to encounter.

In reality, *everything* means **seven**, which maybe is not as big as you though, but it is still more then enough trust me. These standard Unix files types are defined by POSIX, although specific OSs can define their own beyond these, but leaving that aside, let's take a look at each one.

## Regular

These are the "common" files that you typically call quintessential file. These can be anything from scripts, images, videos, audios, compressed folder (zip, 7z, ...), documents, program-specific-format files like XML, DOCX, PDf, and many other.

Because files can be soo many things and hold so many types of different information depending on their use, Unix does not impose or provide any specific internal structure for this regular file type, this is entirely up to the program using them.

As we discussed before, regular files are identified by a **-**, as we can se in the example bellow as the first character.
```bash
remnux@25bdfcf5df91:/var/log$ ls -l
-rw-r--r-- 1 root       root              63157 Mar 10  2023 alternatives.log
```

But if you want to know what a file is? Well, although there is not an imposed structure, there are always conventions,standard and programs that are soo universally used that even if you don't recognize it (or it is **hidden from you**!!), the `file` command will usually be able to tell you what type of file it is.

```bash
remnux@25bdfcf5df91:/var/log$ file alternatives.log 
alternatives.log: ASCII text, with very long lines
```

This works because of something we call *"magic numbers"* or more appropriately, [file signature](https://en.wikipedia.org/wiki/File_format#Magic_number), which are unique sequences of bytes at the beginning of a file that indicate the file format. The `file` command reads these magic numbers and compares them against a database to determine the file type. This database is typically found in `/etc/magic` or `/usr/share/file/magic`.

> *Magic numbers* and file signature are an interesting and important subject, especially regarding forensics and malware analysis! Maybe will write a post about them someday, but you should definitely read about them.

## Directory

Yes, a directory is a file. In fact, it is the most common "special" file of all files. But since it is a file, and files store information, what does a directory hold?

Well, it can't hold other files as a hole, if that where the case then all files would in fact just be *a* single file! It would be like saying that, if we wrote an entire book in a single page, it would still be a book because it holds the same information as if it was written through out various pages, which wouldn't be true.

Well, remember before when I said a file doesn't actually have a name, its just linked to one? That link is what a directory hold.

A directory is file that actually only contains a mapping table, linking all it's children file (all kinds of files) names and their respective *inode* numbers. Returning to the book example, a directory is like the index, it doesn't tell you the information of each chapter, but it tell you the chapter's name and the page it begins at, and that chapter's name in unique in that book. It may exist other books with chapters with the same name, but they are not the same chapter since they do not exist on the same realm (the realm being the book they belong to). This means that file names are **directory specific**, and that is why they are not held at the inode! Because the inode points to a unique space in memory, and the memory that is common to every file in the system!

> Can you imagine if every file name had to be unique system wide? I'm not that imaginative!

## Symbolic link

We have hard link, but we also have ***symbolic link*** (sometimes also called *soft* links), and it is nothing by a reference to another file.

But what is the difference you ask? Well, flirts of all, a symbolic link is a file in itself and thus it holds information, unlike a hard link. This file hold a textual representation of the **file's path** it references.

Unlike hard links that ties a file's name to a it's *inode* number, the soft link is a link to the file name which is then linked to the *inode* via a hard link.

Yeah... confusing... just look at the image!

{{< figure 
    src="/posts/02-everything-is-a-file/hard-vs-soft.png"
    height=300vw
>}}

Turning back to the shell, symbolic links are denoted by a `l` character, and depending on the OS your running, some have an handy representation showing you which file the are referencing.

```bash
remnux@25bdfcf5df91:~$ touch file-with-a-name.txt
remnux@25bdfcf5df91:~$ ln -s ./file-with-a-name-txt my-file-via-another-file.txt
remnux@25bdfcf5df91:~$ ls -il
total 0
36178073 -rw-r--r-- 1 remnux remnux  0 Feb  6 15:38 file-with-a-name.txt
36178076 lrwxrwxrwx 1 remnux remnux 22 Feb  6 15:40 my-file-via-another-file.txt -> ./file-with-a-name-txt
36178073 -rw-r--r-- 2 remnux remnux  0 Feb  6 15:38 same-file-different-name.txt
remnux@25bdfcf5df91:~$
```

{{< notice tip "Look closely">}}

Notice a cool thing in the previous code snapshot. Did you notice that the `file-with-a-name.txt` has 0 bytes but the symbolic link file, `my-file-via-another-file.txt`, as 22?

Try counting the characters in the name of the original file ;)

{{< /notice >}}

## FIFO

FIFO are quite interesting and fun files. One of the strengths of Unix is the capability of processes to communicate between each other, and one of the ways they do it is by using *pipes*, which direct the output of one process to the input of another process. But for file to be able to use them, they must exist in the same parent process space, started by the same user. But if you want processes from different users and different permissions to communicate? Well, were comes FIFO for the rescue!

FIFO files, or named pipes can be created anywhere in the system and function like a "dropbox for data streams". One process writes a value inside, and another can go in there and read it.

FIFO files can be created using the `mkfifo` command, and look like regular file system nodes but are distinguished by a `p` character when you use the `ls -l` command.

When a FIFO is opened for reading, the process will block until another process opens the FIFO for writing, and vice versa, this means they are uniderectional! Data written to a FIFO is passed internally by the kernel without being stored on the filesystem.

You can do some interesting things if named pipes, lets see it.

1. First we create the file

```bash
root@1f587f78be08:/var/log# mkfifo pipe
root@1f587f78be08:/var/log# ls -il
total 1824
...
36452964 prw-r--r-- 1 root       root                  0 Feb  6 22:28 pipe
...
```

2. Then we need to execute something that outputs a stream of data, like the `ls`command. But remember, named pipes are blocking, so you need to push it to the background otherwise you will be stuck until another process (like a `cat pipe` on another terminal) reads the pipe.

```bash
root@1f587f78be08:/var/log# ls > pipe &
[1] 37
```

3. Now that we have the pipe as been "filled" with data on the "writing side", we need to read it. But once again, remember once we opened it to for reading, it will blocked until something is written on the other side! You may not notice this is problem if what is being written is from an "endless" source, like a ping or `/dev/urandom` but if it's not and you happen to try to read it when theres is nothing more to be written on the other side, you be stuck in a blocked process. One way to avoid this is to direct the pipe read to a file descriptor which we can then read.

```bash
root@1f587f78be08:/var/log# exec 3< pipe
```

4. Now, you can just read the file descriptor!

```bash
root@1f587f78be08:/var/log# read -ru 3 abc
[1]+  Done                    ls --color=auto > pipe
root@1f587f78be08:/var/log# echo $abc
alternatives.log
root@1f587f78be08:/var/log# read -ru 3 abc && echo $abc
apt
root@1f587f78be08:/var/log# read -ru 3 abc && echo $abc
bootstrap.log
...
```

> Notice how the first read operation unblocked the writing process, allowing it terminate, and also, that in this specific case, it is reading the output of `ls` line by line.

Soo yeah, named pipes are a bit weird when it comes to files, and you'll probably very rarely find one in the wild, but nevertheless, now you know!

## Socket

A socket is a special file used for inter-process communication, which enables communication between two processes in duplex. In addition to sending data, processes can send file descriptors across a Unix domain socket connection using the `sendmsg()` and `recvmsg()` system calls.

A socket is marked with an `s` as the first character of the mode string

TODO: How creating a socket file is not possible and must be done with something like netcat

## Device file

