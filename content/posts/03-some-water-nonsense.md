---
title: "03 Some Water Nonsense"
date: 2025-05-04T18:21:20+01:00
draft: true
---

{{< notice info "Table of contents" >}}

1. [Poor man's indoor pool](#poor-mans-indoor-pool)
2. [Of course its an Arduino project](#of-course-its-an-arduino-project)
3. [What types of files are there?](#what-types-of-files-are-there)
4. [Why should I care?](#why-should-i-care)
5. [Keep exploring](#keep-exploring)
{{< /notice >}}

# Poor man's indoor pool

So, my house has a basement. And where I live? It rains. Actually, when it rains, it **pours**, and when that happens, well, my basement apparently moonlights as an indoor swimming pool.

Now, my basement does have a sort of rain collection system – you know, like many houses, it has a pit (sump pit, for the fancy folks) with a submersible pump. This pump is *supposed* to trigger automatically with a little floaty thing (a buoy!) when the water in said pit gets high enough. I definitely didn't install it, which is probably obvious because whoever did clearly didn't think the pit should be, oh, I don't know, **deep enough** to actually let the water rise and trigger the pump before it starts auditioning for "Waterworld" all over my floor. But no, this pit is so shallow that by the time the buoy would even think about triggering, I'd already be wading in knee-deep water.

This is one of those problems that, when it arises, feels like the absolute worst thing that could possibly happen (an impromptu Olympic-sized pool in your basement is rarely ideal, folks). But, it's such a sneaky seasonal issue that you totally forget about its treachery... until the next torrential downpour. Then, it's a mad dash to the basement to manually switch on the pump, all while cursing the many, many dry days you could have fixed it but, alas, did not.

But no more, I say! Today, we banish the basement bog! Today, we fix this soggy saga... with tech!

# Of course its an Arduino project

{{< figure
    src="/posts/03-some-water-nonsense/setup.jpg"
    height=300vw
>}}

What did you expect? Sure, this is a problem that could be solved with a shovel and some good old-fashioned *manual labor* (i.e., digging a deeper hole). But where's the fun in that? Nope, we're bringing in the microcontrollers – the go-to tech for both certified geniuses and, let's be honest, anyone who thinks a '*smart q-tip*' (the *iOtitis*) is a groundbreaking idea!

So, first question: What should my glorious new solution actually do? I'm a big fan of simplicity, and the pump's existing design is beautifully basic: a buoy rises and falls with the water level, acting like a simple on/off switch. Perfect! That means I can replicate that core logic with something equally straightforward: a relay.

Crucially, I don't want to mess with or damage the pump itself. So, the original buoy will stay. I'll just fix it in its 'always on' position (or effectively bypass it) and then control the pump's power using my new relay, spliced into the power cable that plugs into the wall socket.

Second challenge: How do I actually detect the water level? My first thought went to those little Arduino water level sensors – you know the ones with the exposed traces? But they're pretty tiny, and I need to measure a range of about 5 to 30 cm. What about a pressure sensor? Nah, those are usually designed for much greater depths, making them too bulky and expensive for this humble project.

Enter the hero: the distance sensor! More specifically, an ultrasonic distance sensor. These bad boys are dirt cheap, super common, and incredibly well-documented. Winner!

## Connections overview

```mermaid
graph TD

subgraph Power
    USB_Power([USB 5V Input])
end

subgraph NodeMCU
    VIN([VIN 5V])
    V33([3.3V])
    D1([D1 - Trigger])
    D2([D2 - Echo])
    D5([D5 - Relay Signal])
    GND([GND])
end

subgraph Ultrasonic Sensor
    USGND([GND])
    USVCC([VCC])
    TRIG([TRIG])
    ECHO([ECHO])
end

subgraph Relay Module
    RVCC([VCC])
    RIN([IN])
    NO([NO Contact])
    COM([COM Contact])
    NC([NC Contact])
    RGND([GND])
end

%% Connections

USB_Power --> VIN
USB_Power --> V33
GND --> USGND
GND --> RGND

V33 --> USVCC
VIN --> RVCC

D1 <--> TRIG
D2 <--> ECHO
D5 <--> RIN
```
