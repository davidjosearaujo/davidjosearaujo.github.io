---
title: "Skills & Projects"
date: 2023-05-11T21:20:59+01:00
draft: false
---

# Skills

{{< tabgroup >}}

{{< tab name="Programming languages" >}}
- Go
- Rust
- Python
- Java
- Zig
- Bash
- C
- Javascript
- Dart
<!--
- Perl
- Haskell
- Elixir
-->
{{< /tab >}}

{{< tab name="Databases" >}}
- MSSQL
- MySQL
- SQLite
- Cloud Firestore
- MongoDB
- Redis
{{< /tab >}}

{{< tab name="Cloud platforms" >}}
- AWS
- Firebase
<!--
- Google Cloud
-->
{{< /tab >}}

{{< tab name="Frameworks" >}}
- Vue.js
- Express.js
- Flask
- FastAPI
- Flutter
- Pandas
{{< /tab >}}

{{< tab name="Tools" >}}
- RabbitMQ
- Docker
- Kubernetes
- Ansible
<!--
- Terraform
-->
{{< /tab >}}

{{< /tabgroup >}}

# Projects

## Personal

These are some of the projects I’ve worked on my spare time, they are also the ones I had the most fun developing.

{{< tabgroup >}}

{{< tab name="EPHScore" >}}
An application for medical emergency first responders in Portugal. It provides an easy way to calculate various scores and evaluations of the patient, soo to ease and accelerate the help and care.

- [Play Store](https://play.google.com/store/apps/details?id=com.davidaraujo.ephscores)
{{< /tab >}}

{{< tab name="SensorMesh" >}}
SensorMesh allows you to direct output from serial devices and internal services into a distributed peer-to-peer database on IPFS. SensorMesh is built as a layer of abstraction and service compatibility for OrbitDB. It is built in Go and uses the go-orbit-db module developed by the folks at Berty.

- [GitHub](https://github.com/davidjosearaujo/sensor-mesh)
{{< /tab >}}

{{< tab name="CAP Parser library" >}}
CAP is a XML message-formatted based communication focussed one structuring the main aspects of any given emergency in a easy to read/easy to exchange message. This messages can then be used for communication between devices and for long-term storage in XML files. These libraries allow for easy creation and manipulation of CAP messages.

- [Go](https://pkg.go.dev/github.com/DavidAraujo98/CAP-parser) 
- [Python](https://test.pypi.org/project/capparser/)
{{< /tab >}}

{{< /tabgroup >}}


## University

During my college experience, I also developed some interesting systems, some of my favorite are listed bellow.

{{< tabgroup >}}

{{< tab name="P4Sentry" >}}
A network monitoring system that is capable of consulting network devices themselves and retrieving metrics specified by the user. This system needed to possess a dashboard for ease of configuration and metric visualization.

- [GitHub](https://github.com/P4Sentry/original-project)
- [GitHub Organization](https://github.com/P4Sentry)
{{< /tab >}}

{{< tab name="E-CHAP" >}}
In this project, we were asked to deliver an application that combines the advantageous characteristics of both a password manager as well as providing an E-CHAP authentication protocol that is able to communicate with any service that allows it.

- [GitHub](https://github.com/davidjosearaujo/echap-password-manager)
{{< /tab >}}

{{< tab name="Deterministic RSA" >}}
College project for the subject of Applied Cryptography, in this project required the student to develop a **pseudo-random number generator**, provided a set of parameters. This can then be used to provide pseudo-random value to an RSA key generator, also created by the user.

- [GitHub](https://github.com/davidjosearaujo/d-rsa)
{{< /tab >}}

{{< tab name="Enhanced DES" >}}
College project for the subject of Applied Cryptography, in this project intends to take the **underlying technologies of DES**, like **S-Boxes**, where a complex, but **deterministic method of shuffling them** and encrypting data with these is possible by simply providing a password.

- [GitHub](https://github.com/davidjosearaujo/e-des)
{{< /tab >}}

{{< tab name="MusicTrackSlicer" >}}
College project for the subject of Distributed Systems. A central server exposes a client GUI where a user can upload a music file, the server then splits the audio into segments of smaller size and publishes them to the MQTT channel. The workers subscribed to the channel, picked up the tracks, sliced them into the different instrument tracks and returned them to the server. The server then re-assembles the multiple slices and thus returns to the user the same music, but each instrument is now in an individual file.

- [GitHub](https://github.com/davidjosearaujo/distributed-music-processor)
{{< /tab >}}

{{< /tabgroup >}}