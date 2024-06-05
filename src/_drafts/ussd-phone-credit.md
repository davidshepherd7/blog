
(TODO: important strategy/metrics reveal? Probably not telcos knew it was important, but probably overestimated it this will only make them overestimate it more)
An important use-case for Wave customers is purchasing pre-paid phone credit, at
one point nearly 20% of all transactions through Wave were phone credit
purchases!

(TODO: put in footnote? check for accuracy w/ some Senegalese people I think I read this in "Poor economics" but can't find the citation)

If you're from a Western country you might be surprised that people buy phone
credit so often. One explanation that I've heard for this is that people who
don't have much money tend to prefer to buy things "just in time" as they are
needed. This allows them to maintain more liquid cash for other needs. So for
example they tend to prefer making small phone credit purchases daily rather than
making larger weekly or monthly purchases.

But, the path to enabling this was not smooth. Typically if you want to
interoperate with another company's systems to sell their product you go through
a specially designed API, but at the time not all telcos had a API! In many
cases this is where you would stop - no API, no integration. But we weren't
satsified with leaving out some of our customers' key use-cases, and luckily most
telcos do have another way to purchase phone credit!

------------------------------------------------------------

[USSD](https://en.wikipedia.org/wiki/Unstructured_Supplementary_Service_Data) is
a protocol that any phone can use to interact with the telco's systems. It's
typically used to send commands like "tell me my balance" or, importantly for
us, "transfer some of my phone credit to this number". It's fallen out of use in
many countries but is still going strong in Senegal. Here's an example of using
USSD to TODO:

TODO: get screenshots of an example USSD UI flow


Normally this method is used by people who want to sell phone credit on to other
users (this a common way for phone credit to be distributed in Senegal - people
will buy phone credit from a wholesaler and sell it on at a markup to end
users). So it's designed for manual usage from a phone with a human typing the
numbers, how do we interact with this from software? Well, with USB dongle
modems that are normally used for mobile internet access, like [this
one](https://consumer.huawei.com/en/routers/e3372/)! Put a SIM card in one of
these and send the right commands over a serial port and it works just like a
mobile phone. The "right commands" are another obscure protocol which was used
to control modems at the dawn of the internet: [AT
commands](https://en.wikipedia.org/wiki/Hayes_command_set). 

Companies exist that will sell you API access to a setup like this for the major
telcos in various countries, but unfortunately none of the ones we tried were
reliable enough for us (~75% success rate on a good day). Buying things that
work is [hard](https://danluu.com/nothing-works/).

There's one other thing to know about USSD: in normal interactive use you
typically enter some base code like "*123#" which returns an explanation of the
next expected input. Then you enter that and repeat until you've supplied all of
the inputs. This can be used to build arbitrary menu trees or forms server side,
so it's very handy for USSD developers, but it's a pain for machine
interactions. Luckily for us most USSD services support a feature intended for
power-users called "USSD concatenation" which allows you to submit input for
multiple steps at once by sending a whole list of choices separated by `*`.

So, putting everything together here's an example of using AT commands to drive
an imaginary (but representative) USSD "API" to buy some phone credit. First we
send the USSD command to buy the airtime:

```
AT+CUSD=1,"*123*7738347295*1000*1234*1*1#",15
OK
+CUSD: 0,"Your request has been received",15
```

The first line here is our command, the other two lines are the responses.
There's a lot going on in that first line so let's break it down:

* `AT+CUSD=1,"foo",15` sends the USSD command "foo" to the telco. The `1`
  indicates that we want to see error messages and `15` is the character
  encoding (GSM-7 in this case).
* `123` is the command code (e.g. "buy airtime")
* `7338347295` is the phone number to buy credit for
* `1000` is the amount to buy
* `1234` is our PIN code for this SIM
* `1` and `1` navigate us through some confirmation screens menus that would otherwise appear

Note that we don't need to specify which SIM is buying the airtime because we
are sending the command from our SIM. We also don't need to provide any
equivalent of a domain name or URL for the telco's server because our modem is
only ever connected to one telco network at a time.

Next the response: the line `OK` tells us that the AT command succeeded, the
line `+CUSD: 0,"Your request has been received",15` is the response from the
USSD command (which might take a second or two to arrive). `0` here means that
the telco considers this USSD session to be completed successfully (as we said
USSD is a stateful protocol, so the server keeps a session alive while the user
is interacting with it). The string itself is the message sent by the telco in
response to our USSD command. This tells us that the telco has received the
request and there haven't been any errors so far, but it doesn't mean that we've
suceeeded in purchasing credit yet.

The final confirmation comes as an SMS message that we receive asynchronously,
this typically takes a few seconds, but sometimes takes minutes or even hours.
Reading SMS with AT commands looks something like this:

```
AT+CMGL
+CMGL: 0,"REC UNREAD","713274343",,"22/01/28,10:39:12+00"
You have successfully purchased 1000 CFA of credit for 7738347295.
```

Again the first line is our command, this particular AT command asks for all
unread SMSes. The second line is metadata about the first (and only) unread SMS
in memory and the third line is the body of the same SMS. If there were more
unread SMSes they would appear in the same way on following lines.


------------------------------------------------------------


Above I implied that you "just" plug in a USB modem and you can send commands to
it, unfortunately that's... not quite true. We ran into a number of issues while
sourcing and setting up modems.

The first was around something called [USB mode
switching](https://www.draisberghof.de/usb_modeswitch/#intro) - to help with
their normal use-case USB modems are often both a modem and a USB stick in one.
They pretend to be a USB stick first, then Windows reads the device driver off
the USB stick. Then the driver sends some proprietry binary command to the modem
and it turns into an actual modem. Luckily Linux comes with the necessary
drivers and most of these codes have been figured out by enterprising Linux
users so you "just" need to configure usb-modeswitch to send the right thing.
Unfortunately the right thing to use it as a modem is different to the right
thing to use it for internet (where it pretends to be an ethernet port), so
these aren't well documented and the defaults configured in Linux distributions
don't do what we need.

Once we were past this step our devices would typically present themselves to
Linux as three different serial ports. We never figured out what the other two
were for, but sending commands to them tended to either do nothing or crash the
device. Luckily the id numbers on the ports were consistent so we were able to
configure udev to create symlinks to the correct ports in another directory and
our programs could just use the (safe) symlinks.

The next problem that we encountered was when our initial system was a success
and we tried to order more modems to scale up. We bought a batch of modems that
seemed to be identical to the first batch (literally the exact same web page)
but mysteriously they didn't work. After much investigation it turned out that
the manufacturer had upgraded something within the hardware which meant that
they had completely dropped support for our use-case! To indicate this they had
changed a part of the model number that was not visible anywhere on the box (to
see it you had to pop open the modem itself). So we gave up on that modem and
started buying up all that we could find of a slightly different modem which
still worked.

Our final issue was even harder to debug: once we did manage to find a model of
USB modem that still supported AT commands over a serial port we found that
everything seemed to work except that it seemed never to receive any SMS. After
many hours of pouring over the AT command specification we discovered a
configuration flag that can be set to tell the modem not to store incoming SMS
into the memory (instead it was supposed to immediately write them to some
output stream, but we never found where that stream was). This new kind of modem
had this flag enabled by default, and the others had it disabled!

The overarching issue here is probably that our use-case is so niche that the
manufacturers of modems targeted at consumers (mostly Huawei) don't really care
about it. We experimented with buying hardware which was specifically made for
this purpose but found that it was dramatically less reliable (as well as being
more expensive) and still hard to get working so we didn't really pursue this.
It's possible that someone somewhere is producing high quality
machine-controllable modems but if so we didn't find them.
