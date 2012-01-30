KeyTaps
=======

It started as a thought. How many keys to you type in a given day as a developer? How long would it take you to reach 1M keystrokes? 
I figured it couldn't be hard to make a very basic key logger that just keeps track of how many keys you type in a given "session." Turns out
it wasn't too bad... it is, however, mostly useless :)

I'm still reading this
----------------------

Well, its about this easy I found out:

    unsigned long taps;
    monitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event)
    {
      taps++;
    }];

The app kind of spiraled down some weird paths from there... Heres what it currently looks like:

Screens!@@#!1
-------------

Heres how it sits in your menu: 

![in menu](https://raw.github.com/robhurring/KeyTaps/master/.images/in-menu.png)

And if you want to run a focused session as you code (to watch the numbers fly on by!)
It currently tracks your last 5 sessions. The each time you reset the session your total goes into your daily aggregate bucket. (Not very accurate across multiple days).

![session](https://raw.github.com/robhurring/KeyTaps/master/.images/current-session.png)

Nothing too brutal, but still interesting to see what you can type in a given day. (The numbers in these screens are actually pretty low.)