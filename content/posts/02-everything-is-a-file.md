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

Talk about how you can access information about running processes by reading the files in /proc

First find PID of running process using top / htop, and then look for the dir with that name and read the status file inside it for more information

Also, you should read the cgroup and environ files


---
https://dev.to/eteimz/everything-is-a-file-explained-g2a

This article is interesting as it focus on the way we interact it files and how that can be applied to everything in Unix, and that is the reason for the saying 'everything is a file'
---