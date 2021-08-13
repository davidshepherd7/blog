---
layout: post
title:  "Writing about my job: Software Engineer at Wave"
date:   2021-08-13
categories: wave ea jobs
---

In response to [Aaron Gertler's prompt on the EA
forum](https://forum.effectivealtruism.org/posts/nf72oiJddwDhoJ4QH/you-should-write-about-your-job)
I'm writing a bit about my job. I hope this will be useful to people who are
considering software engineering as a career path and EA software engineers who
are in positions where their work is not EA relevant.

This post is cross posted from the [EA forum](https://forum.effectivealtruism.org/posts/pyvybGkGYaFAeNtGi/writing-about-my-job-software-engineer-at-wave).


# The basics

I work as a lead software engineer for [Wave mobile
money](https://www.wave.com/en/). We're working to build radically inclusive and
affordable financial infrastructure in sub-Saharan Africa. My job is a mixture
of programming, mentoring/leading other engineers on my team, and a bit of
product design work. I work full remotely from Manchester, UK.

The job is EA-relevant in two ways:

1. Directly - Wave is dramatically cheaper than competitors, so we save people a
   lot of money for people who often don't have much money in the first place.
   My rough estimate for the reduction in fees vs competitors is 20 million USD
   per month, and we're growing so this is constantly increasing!
   
   Less concretely there are also benefits from having a reliable, fast, and
   widely used mobile-money network available, see e.g.
   [link](https://www.wave.com/en/blog/world/) or
   [link](https://www.jefftk.com/p/estimating-the-value-of-mobile-money).
   
2. Donations - with most jobs pay is heavily location dependent, but I'm not
   willing to make the sacrifice of living somewhere that will leave me isolated
   from my friends and family in order to earn more money. Wave's pay is
   (almost) location-independent so as a European software engineer working for
   Wave allows me to donate substantially more than I would otherwise. It's
   roughly 3x-10x+ depending on how much the equity ends up being worth. Wave
   also matches donations up to $10,000 per year which adds another ~1x.

Of these two I think the direct work is probably the more valuable part: even
taking the fee savings alone and dividing evenly over all Wave employees would
be around 500K USD per Wave employee per year. But a software engineering role
probably contributes more than say a callcenter role so my contribution is
probably more than that. Then there's the potential for massive continued growth
of Wave which could amplify the impact of work done now by 10-100x.

It's not completely clear-cut though since 1. the largest fee savings/mobile
money network benefits will probably go to richer people and 2. GiveWell
estimates AMF donations to be around [10x more
valuable](https://docs.google.com/spreadsheets/d/11HsJLpq0Suf3SK_PmzzWpK1tr_BTd364j0l3xVvSCQw/edit#gid=1364064522&range=B215)
than cash transfers.



# Background

I think there's a pretty standard route to getting a software job (i.e. STEM or
CS degree then junior eng role, maybe with some self-driven learning or a
bootcamp first), but I'll describe my path anyway because it was slightly
non-standard:

* Maths and Physics undergraduate - I think this was very helpful in getting the
  right mindset for software engineering and learning hard things in general,
  but only a tiny fraction of what I learned during my undergraduate is actually
  relevant to my job.
  
* PhD in computational physics - this is when I really learned to program well.
  I was working on large complex software so I was forced to use proper software
  engineering best practices to be able to deal with it. I think this was a big
  help in getting to where I am now. Still not sure if I would recommend doing a
  PhD though: it was definitely bad for my mental health.
  
* 4 years as a software engineer at Biosite - more technical skills, and general
  software work experience. Also my introduction to the idea of prioritising
  work based on impact rather than just trying to do everything at once. (Really
  wish I'd been pushed to think about this more during my PhD!)
  
As well as the above I've spent a lot of time (a few hours a week for ~6 years)
writing open source software for fun in my spare time and reading books on the
subject. I think this probably helped to prepare me for the job as much or more
than my undergraduate degree. Possibly even more than a CS undergraduate would
have done.

 

# Application process

Disclaimer: this is written from memory from 2 years ago, I might not have got
everything right.

The application process took a fairly typical amount of work for a software job
in my experience. It took around 10-12 hours total (including prep) over 4
parts: 2 coding exercises and 2 chats. Everyone I interacted with was friendly
and pleasant throughout, I think it would have been a positive experience even
if I didn't get the job.

The first chat was just a general intro to Wave and opportunity to ask
questions. I didn't explicitly prep for this but I had a few questions anyway. In
retrospect I probably should have spent some time thinking of more questions.

Then there were the programming exercises. These were both intense but fun, I
think it was around 6 hours total + a couple of hours prep. At the time the
recommended prep was something fairly wishy-washy like "think about how to solve
the problem but don't write any code" (I think this has changed since). So I did
this recommended prep and I also made sure I was familiar with all the
technologies that I would be using by writing a quick implementation of some
trivial application with same language and framework. I think I'm happy with the
amount of prep that I did. I found out afterwards that I did fine on both of the
exercises, but while I was doing them I felt like there wasn't enough time to
fully solve the exercise (this was probably intentional). That was what made it
feel intense.

Finally there was the last interview with one of the founders. I think this was
a final check for culture fit, we talked about things along the lines of why I
wanted to work for Wave, what motivates me in general, etc. As with the other
chat I didn't really spend any time prepping for this and maybe I should have
done something more.

Pretty quickly after the last interview (I think it was same or next day) I got
a job offer. I took a day or so to think it through to be completely sure that
it was what I wanted, but really there was no way I was going to say no!


I applied for another job at the same time as I applied for Wave. The other job
was some boring corporate transportation arranging startup who rejected me (one
of the reasons was because I didn't seem excited enough about their product, so
I guess they got that right!). Their application process was fairly similar to
the Wave one. Doing two applications at once was manageable but I don't think I
could have handled more than 3 applications while also working full time.


# What the job is like


## What I spend my time on

This varies a lot from week-to-week, but as a rough estimate:

* ~40% of my time writing code
* ~25% of my time on supporting/mentoring the other software engineers on my
  team - helping them with any tricky problems, giving guidance on technical
  designs, etc.
* ~25% of my time working on product design problems - digging into data to
  answer questions or look for issues; working out how to make new features easy
  to use, secure, and reliable.
* ~10% of my time arranging other things - trying to make sure all of the pieces
  are in place for projects to go smoothly, ensuring that the right people are
  talking to each other, etc.
  
I'm the tech lead for my team, so most software engineers spend less time on
mentoring/product/arranging things and more on writing code than I do. But Wave
generally encourages all engineers to get involved in product decisions and take
full ownership over the problems they are solving, so there might still be more
non-programming work than at other companies.


More specifically: I work on the integrations team, where we build features that
interact with systems run by other companies. The most common example of this
kind of feature is enabling users to pay their bills in the Wave app. This might
sound simple and boring but (for better or worse) many of our partners have very
idiosyncratic APIs. So every new integration is an interesting challenge in
figuring how we can adapt to the specific functionality and requirements of that
particular API.



## Pros

For Wave in particular:

* I get to directly work on solving really important problems for people (e.g.
  allowing people to cheaply pay their bills from their phone instead of walking
  miles to an agency or paying large fees). This kind of work doesn't seem to be
  possible in developed world software because all of the low-hanging fruit has
  already been picked so you just work on making cat pictures load faster or
  making someone else's job slightly more efficient, etc.
  
* We're growing absurdly quickly, during my time at Wave we've gone from being a
  tiny company that no-one had heard of to the majority of adults in Senegal
  being Wave users (and we've since launched in other countries too). This is
  incredibly exciting to watch unfold.
  
* The work environment is great - my colleagues are some of the most friendly
  and supportive people I've met, looking after yourself is widely encouraged.
  They're also some of the smartest people I've ever met.
  
For software engineering in general:

* It's an interesting and intellectually challenging role. There are more
  challenging roles, but I find that software engineering has a nice balance
  between "hard enough to be interesting" and "so hard you fail all the time".
  
* The compensation is good, although it's usually only really really good in
  particular cities.
  
  
## Cons

For Wave in particular:

* Fully remote work can be isolating, this is usually counteracted by regular
  company trips to the countries where we operate but covid has obviously
  suspended that.
  
* Working on technology in Africa can be... challenging, e.g. there are few/no
  datacenters - you either run your own machines or use hardware on another
  continent; the reliability of everything is relatively low - power and
  internet outages happen semi-regularly both for us and for our partner
  companies; the regulatory environment can be confusing, bureaucratic, and/or
  ineffective.

For software engineering in general: it definitely requires a love of and
aptitude for learning about technical subjects.


# Contact me/hiring

If you have any follow up questions feel free to post them on the EA forum or
email me about them.

We're currently hiring software engineers, product managers, and a bunch of
other remote positions. So if any of what I've described sounds like something
you would be interested in doing then please reach out and/or check out [our
jobs page](https://www.wave.com/en/careers/#roles).

<!--  LocalWords:  Gertler's
 -->
