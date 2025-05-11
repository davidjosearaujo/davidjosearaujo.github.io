---
title: "03 Some Water Nonsense"
date: 2025-05-04T18:21:20+01:00
draft: true
---

{{< notice info "Table of contents" >}}

1. [Poor man's indoor pool](#poor-mans-indoor-pool)
2. [Of course its an Arduino project](#of-course-its-an-arduino-project)
3. [List of parts](#list-of-parts)
4. [Circuit schematics](#circuit-schematics)
5. [I suck at soldering](#i-suck-at-soldering)
{{< /notice >}}

# Poor man's indoor pool

So, my house has a basement. And where I live? It rains. Actually, when it rains, it **pours**, and when that happens, well, my basement apparently moonlights as an indoor swimming pool.

Now, my basement does have a sort of rain collection system – you know, like many houses, it has a pit (sump pit, for the fancy folks) with a submersible pump. This pump is *supposed* to trigger automatically with a little floaty thing (a buoy!) when the water in said pit gets high enough. I definitely didn't install it, which is probably obvious because whoever did clearly didn't think the pit should be, oh, I don't know, **deep enough** to actually let the water rise and trigger the pump before it starts auditioning for "Waterworld" all over my floor. But no, this pit is so shallow that by the time the buoy would even think about triggering, I'd already be wading in knee-deep water.

This is one of those problems that, when it arises, feels like the absolute worst thing that could possibly happen (an impromptu Olympic-sized pool in your basement is rarely ideal). But, it's such a sneaky seasonal issue that you totally forget about its treachery... until the next torrential downpour. Then, it's a mad dash to the basement to manually switch on the pump, all while cursing the many, many dry days you could have fixed it but, alas, did not.

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

## Selecting the board

Ah, the brains of the operation! The central nervous system, poised for such raw data-crushing and powerful computing tasks as... repeatedly requesting a value from the sensor, determining if it falls within the 5 to 30 cm danger zone, and if so, flicking the pump on. If not, well, it does nothing. Dramatic, I know.

Yeah, it doesn't exactly require a supercomputer, I'll admit. For someone so obsessed with efficiency and squeezing every last drop of performance out of components, it almost pains me to use a microcontroller for such a trivial task. Almost. Because, you see, it's cheap and easy – and those are two things I might love even more than hyper-efficiency.

My criteria were simple: small, cheap, and "good enough." I didn't need Wi-Fi or BLE (though, a tiny part of me now regrets not being able to get a notification when the pump kicks in – future upgrade, perhaps?). Initially, I considered an ESP32-C3. I spotted some on AliExpress that weren't outrageously priced, but the delivery dates were so far out in the stratosphere, I was genuinely worried my old pal Procrastination would have declared victory and the board would just gather dust upon arrival.

Then, salvation! I found a fantastic local supplier – massive shout-out to [Mauser](mauser.pt) for their awesome selection and great prices! They had the [Seeed Studio XIAO RP2040](https://wiki.seeedstudio.com/XIAO-RP2040/).

Beyond its ridiculously small size which is perfect for tucking away, the RP2040 chip itself is powerful enough for this and much more, it has just enough GPIOs for my sensor and relay.

# List of parts

Like I said before, [Mauser](mauser.pt) has super cool stuff, specially target at tinkerers, and soo I ended up just placing the order for everything there, and I also had some stuff lying around. You can see everything in the table bellow.

# Circuit schematics

<!-- Show circuit schematics, give link to downlaod PDF file. Show initial POC in bread board, and also talk about planing the board and how I'm crap at that -->

# I suck at soldering

<!-- Talk about soldering, getting the component to lay of the board, how the board I choose sucks ass. How initially usb was (and still is a great idea) but in my case failed. how it will all fit together, how i was quite crafty to make a holder for the sensor, show final configuration with cable terminated in EU standard for sockets -->

# Hope you don't need it, but in any case

<!-- Mention project in Gitlab and give links -->
