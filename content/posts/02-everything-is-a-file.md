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


---
https://dev.to/eteimz/everything-is-a-file-explained-g2a

This article is interesting as it focus on the way we interact it files and how that can be applied to everything in Unix, and that is the reason for the saying 'everything is a file'

We can open, close, read and write to files, just like in real world

In Unix-like operating systems, everything is referred to as a file because various system resources can be treated as file-like entities. These file-like resources, such as standard input, standard output, and network connections, can be opened, read from, written to, and closed, with data being streamed from each resource. This design allows the same operations to be performed across different system resources, making it easier to work with them.

The creators of Unix designed the operating system to treat various system resources as files, allowing the same set of APIs to be used across different tasks. This is achieved through the use of file descriptors, which are unique integers that represent open files, such as standard input (0) and standard output (1). System calls, like the write system call, can then be used to interact with these file-like resources.
---

---
https://dev.to/chandelieraxel/what-is-a-file-in-unix-systems--m5g

In an operating system (OS), various features rely on files, including processes, devices, networks, and directories. There are 7 types of files, with regular files and directories being two of the main types. This summary will focus on regular files and directories for now.

From an operating system (OS) perspective, a file is represented as an inode, a data structure containing metadata about the file. This metadata includes information such as creation date, last update date, ownership, permissions, and file size. Note that the file name and actual file data are not part of the inode.

You can visualize an inode informations directly in your terminal, by typing the ls -l command.

In order :

File type and permissions. It's quite hard to read, let's break it down together.
    The first character specify the what kind of file this is (the 7 types we mentionned earlier).
        - Regular file.
        d Directory.
        l Symbolic link.
        b Block special file.
        c Character special file.
        s Socket link.
        p FIFO.
    The next three characters are related to the owner permissions for the file.
    The next three characters are related to the group permissions for the file.
    The last three characters are related to the others permissions for the file.

    All permissions fields can be read as follow :
        Is the permission allowed to read the file ? - for no, r for yes.
        Is the permission allowed to write the file ? - for no, w for yes.
        Is the permission allowed to execute the file ? - for no, x for yes.
Number of hard links. You may find more informations here.
Owner name.
Group name.
Number of bytes in your file.
Date of last modification.
File name. Not a part of the inode, but still in the output. More on it later.

If you're willing to get a bit more information about a specific file, you may want to use the stat command directly.

If you execute the ls -li command you will find an extra column at the beginning of the output.

An inode contains a unique integer, the inode number, which serves as a unique identifier for a specific file in the file system. Each file has a distinct inode number, except for hard links, and there is a limited maximum number of inode numbers that a file system can handle, after which file creation is no longer possible.

Since the file name is not stored in the inode, it must be stored elsewhere. The file name is actually stored in the parent directory. A directory is simply a container that holds a list of files and subdirectories, and can be viewed using a command like ls -l.

The directories files actually only contain a mapping table, between a file inode number, and his name.

The list goes on for all the file or other directories it may contain.

A directory is nothing but a specific file, it also have an inode number, and his name is saved within his parent directory inode.

So, where is the file data ?

What make the inode so special is that it kept references (pointers) toward the memory blocks that are actually containing the data in disk. By doing so, when we ask to open the file, it go through all of them and recover the information needed.
---

https://en.wikipedia.org/wiki/Unix_file_types

https://microsoft.github.io/WhatTheHack/020-LinuxFundamentals/Student/resources/concepts.html

https://dev.to/eteimz/everything-is-a-file-explained-g2a

https://www.tecmint.com/everything-is-file-and-types-of-files-linux/

Talk about how you can access information about running processes by reading the files in /proc

First find PID of running process using top / htop, and then look for the dir with that name and read the status file inside it for more information

Also, you should read the cgroup and environ files