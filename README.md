# YAMG


           _____      _____       _____        ______  _______         _____
           |\    \    /    /|  ___|\    \      |      \/       \    ___|\    \
           | \    \  /    / | /    /\    \    /          /\     \  /    /\    \
           |  \____\/    /  /|    |  |    |  /     /\   / /\     ||    |  |____|
            \ |    /    /  / |    |__|    | /     /\ \_/ / /    /||    |    ____
             \|___/    /  /  |    .--.    ||     |  \|_|/ /    / ||    |   |    |
                 /    /  /   |    |  |    ||     |       |    |  ||    |   |_,  |
                /____/  /    |____|  |____||\____\       |____|  /|\ ___\___/  /|
               |`    | /     |    |  |    || |    |      |    | / | |   /____ / |
               |_____|/      |____|  |____| \|____|      |____|/   \|___|    | /
                                                                       \|____|/


[![Gem Version](https://badge.fury.io/rb/yamg.png)](http://badge.fury.io/rb/yamg)
[![Dependency Status](https://gemnasium.com/nofxx/yamg.svg)](https://gemnasium.com/nofxx/yamg)
[![Build Status](https://travis-ci.org/nofxx/yamg.png?branch=master)](https://travis-ci.org/nofxx/yamg)

YAMG - Yet Another Media Generator


## Install

    gem install yamg


## Features

* Find best version (size) to use from icons folder.
* Splash screen/banner generation with gravity.
* Works with iOS/Android/Other mobile with Phonegap or Cordova.


## Use

Just run: `yamg`


### Icons

Multiple sizes:
Just save your files with the size in pixels first, example:
In the 'icons/' folder: '16-icon.png', '32-icon.png', '512-icon.png'.
YAMG will choose the best size for the case, and don't touch
the icon if sizes are a match.

It's ok to (or if you) have only one icon, make it >512px.


### Splash

The main splash image must be named 'center'.
Gravity!
Just save you files with the names: 'north', 'northeast', 'south'...
Gravity will put em in the correct place, with a lil padding.


### Media

Addional media.
There's also media generator for app stores.


## Screenshots (phantomjs)

Soon.

### Support

* Web
* Rails
* iOS Project
* Android Project
* Cordova (platforms/*)
* Phonegap (www/res)
* App Store
* Play Store
* Facebook
* Twitter
* Write your own (really easy, fork and change yml)
