+++ 
draft = true
date = 2025-07-18T16:42:53+01:00
title = "Router Annoyances"
description = "My home router annoying amnesia"
slug = ""
authors = ["David Araújo"]
tags = ["networking", "reverse engineering", "home", "server"]
categories = ["/home-server"]
externalLink = ""
series = []
+++

{{< notice info "Table of contents" >}}
1. [My router suffers from amnesia](#my-router-suffers-from-amnesia)
2. [Exploring my options](#exploring-my-options)
3. [More interesting than I imagined](#more-interesting-than-i-imagined)
4. [Developing a solution](#developing-a-solution)
5. [Setting and forgetting](#setting-and-forgetting)
{{< /notice >}}

# My router suffers from amnesia

Of course I have a home server.

Like probably most people who read this blog (if there are any of you out there!), I like to self-host some services. Think my own git repositories for projects, plus movies, ebooks, and even personal budget tools. Well, that list isn't really the important part. What I'm getting at is that everyone who also has a home server knows what a sweet setup it can be!

Having all of this accessible within your LAN is awesome, but the really cool part? That's when you set it up to be accessible from anywhere. And that's the big advantage and the whole point of self-hosting: using your own services from anywhere, anytime.

This obviously poses the question: how do I access my home services from afar? Now, this isn't a post on how to create your home server, but one crucial step will always be enabling port-forwarding in your home router.

Some folks choose to set up multiple port-forwarding rules, basically making various services directly accessible. I, however, opted against that – it just cranks up my server's surface exposure to attacks, and frankly, who needs that stress? The most secure solution I found? Just forwarding one port and using it to establish a connection with a VPN server in your home network (or a VPN peer, if you're using Wireguard, which is totally what I do!). This trick not only ensures I've got just one tiny port open to the outside world, but also that only encrypted traffic gets to boogie on through.

But that is where my problem starts. My setup is perfect, but my router is from my ISP, and for some annoying reason, from time to time, it just resets automatically. And when it does, it erases all of my port-forwarding rules. So you can imagine how annoying it is when I'm trying to access my home server while I'm at work or school, and my VPN just won't connect. It's been going on for some time now, and it's one of the reasons I'm not able to take advantage of even more services, like hosting my own password manager. Why? Because I don't want to take the chance of not being home, needing to log in somewhere, and just not being able to retrieve my credentials. Like I said, such a trivial issue with such critical consequences... annoying consequences.

# Exploring my options (and my sanity)

You can probably figure out by now that this little annoyance was the problem I set out to resolve in this post. How could I make this system more resilient, without, you know, throwing my router out the window?

The first question I had was the obvious one: **why does the router do this?**

{{< figure 
    src="/posts/04-router-annoyances/router-system-settings.png"
    height=400vw
>}}

The first question I had was the obvious one, shouted directly at my router: "Why do you do this?!"

From the admin panel of my router, I found this delightful set of options. It's pretty obvious that the problematic one is the "scheduled restart," but what I still don't get is why it erases some configurations but not others. For that, I'm afraid, I still don't have an answer. The mystery continues!

Naturally, I turned it off, fully expecting it to just solve the issue. But for some reason, after a few days, I went back to check, and guess what? The configurations were gone again. My blood is boiling by now because I only ever find out the configurations are gone when I'm miles away from home and I REALLY need to connect and I just can't.

But I insisted, and I can't tell you how many variations of these options I've tried – enabling/disabling some or all, tweaking every setting – but the problem just stubbornly continued! Seriously, why is my router erasing my configurations?! It's like it has a personal vendetta against my self-hosting dreams.

That was it. I had enough. It was clear I would have to come up with my own solution, because clearly, my router was not on my side.

# More interesting than I imagined

So, I didn't really know how to do it, I just knew that I had to find a way of interacting with the router programmatically. In these cases, I tend to just go for the worst-case scenario, thinking I'll have to scrape the admin page, figure out how to interact with it, and really over-engineer the crap out of it!

Luckily, this time I was smarter than usual. The first thing I did, like any good reconnaissance operative, I opened OWASP ZAP for proxying and then opened up the page on my browser, just so I could see what would happen when I logged into the admin panel.

And then, the most wonderful thing happened. To my surprise, without interacting with the page at all, a few api/ endpoints started showing up...

{{< figure 
    src="/posts/04-router-annoyances/owasp-zap-captures-api-endpoints.png"
    height=400vw
>}}

Could it be? Could it be that this unassuming, crappy-looking piece of ISP junk has a few tricks up its sleeve in the form of a REST API I didn't know about? Would this turn out to be easier and even more awesome than I anticipated?

{{< figure 
    src="/posts/04-router-annoyances/interesting.gif"
    height=300vw
>}}

Well then, if this is to be true, the first step was to figure out what requests were involved for authentication. For this, I just authenticated manually and captured the following POST requests.

{{< figure 
    src="/posts/04-router-annoyances/authentication-post-requests.png"
    height=150vw
>}}

This is quite interesting, we get two requests:

- `/api/user/challenge_login`
- `/api/user/authentication_login`

Just from the names, we can deduce it's some sort of CHAP authentication procedure. Let's examine the requests more carefully.

```
POST http://192.168.1.1/api/user/challenge_login HTTP/1.1
host: 192.168.1.1
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Content-Type: application/x-www-form-urlencoded; charset=UTF-8
_ResponseSource: Broswer
__RequestVerificationToken: ZL1Yz7kWugYZJfopEQvXINI2DRayNWXm
X-Requested-With: XMLHttpRequest
Content-Length: 186
Origin: http://192.168.1.1
Connection: keep-alive
Referer: http://192.168.1.1/html/home.html
Cookie: SessionID=q6jtjN8RYr6w3vLeFVWjxru0KTMbLH90T0wXoAgmtzphl45NYbIm8MsU9flb518ycQrs9xy08Jn7LUmHVeoLPMHofjoawFldnNLVeje80fjXVB2qKnh38QOdBwDQ80lZ
Priority: u=0

<?xml version="1.0" encoding="UTF-8"?><request><username>admin</username><firstnonce>45adf3a2cce832f3486a908c35490b90be709348a9d775214d7bdfc04d971d53</firstnonce><mode>1</mode></request> 
```

```
HTTP/1.1 200 OK
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Content-Type: text/html
X-Download-Options: noopen
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
Content-Security-Policy: default-src 'self' 'unsafe-inline' 'unsafe-eval'
X-Content-Type-Options: nosniff
__RequestVerificationToken: Uu5ugOXiug2Jkz9FSV7l82lIPbiUuMwU
Content-Length: 337

<?xml version="1.0" encoding="UTF-8"?><response><iterations>100</iterations><servernonce>45adf3a2cce832f3486a908c35490b90be709348a9d775214d7bdfc04d971d5326Q5vDwFdWk2arNgZxLlwSpPce06Kgmu</servernonce><modeselected>1</modeselected><salt>f76f8f886c80b03f1f7aef5e466b55cfd1894501283683178ea94f09548c8439</salt><newType>0</newType></response>
```

Yeah, it really is CHAP! I see nonces, iterations, I see salt... I don't see pepper, but this is hot!

What I also see are non-standard header fields: `_ResponseSource` set as `Broswer` (I guess English wasn't the strong suit of the developer, bless their heart) and `__RequestVerificationToken` with some weird value I have no idea where it came from. Finally, the `Cookie` is also populated with some value.

Okay, this is really cool (except for the fact that it uses XML, which is the bane of my existence) and before exploring the next request, I think I'll need to see where in the client-side code this request is formed, because I need to understand how all of these values originate.

# Developing a solution

# Setting and forgetting