# YAMG

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓

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

    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


[![Gem Version](https://badge.fury.io/rb/yamg.png)](http://badge.fury.io/rb/yamg)
[![Dependency Status](https://gemnasium.com/nofxx/yamg.svg)](https://gemnasium.com/nofxx/yamg)
[![Build Status](https://travis-ci.org/nofxx/yamg.png?branch=master)](https://travis-ci.org/nofxx/yamg)

YAMG - Yet Another Media Generator



## Install

Linux

    nice-pkg-manager install imagemagick phantomjs librsvg ruby
    gem install yamg

OSX

    brew install imagemagick phantomjs librsvg ruby
    gem install yamg


## Features

* Find best version (size) to use from icons folder.
* Shrinks binaries from the closest or greater size version.
* Raster SVG to PNG with exact size and dpi.
* Splash screen/banner generation with gravity.
* Works with iOS/Android/Other mobile with Phonegap or Cordova.
* Exports icons and splashes for stores and social networks.
* Screenshots for stores and advertising.


## Use

    yamg

A `.yamg.yml` will be created on the folder.


### Icons

Your main icon(s) may be SVG or PNG. Or both:
SVG is always the best choice except really small (16x16, 32x32)
icons: there you can show your pixel art skills to the world.

#### PNG

Multiple sizes:
Just save your files with the size in pixels first, example:
In the 'icons/' folder: '16-icon.png', '32-icon.png', '512-icon.png'.
YAMG will choose the best size for the case, and don't touch
the icon if sizes are a match.

It's ok to (or if you) have only one icon, make it >512px.

#### SVG

You may still use best size match: Just have you folder:
'16-icon.svg', '256-icon.svg', problably not much more:
The SVG will be rasterized in the correct size needed.


### Splash

Up to 9 images may be placed in a splash.
Note: The center splash image must be named 'center'.

#### Gravity

Just save you files with the names: 'north', 'northeast', 'south'...
Gravity will put em in the correct place, with a lil padding.


### Media

Addional media.
There's also media generator for app stores.


## Screenshots (phantomjs)

Custom screenshots:


    name:
      url: 'github.com'
      size: [1280, 720]  # W x H
      scroll: 100        # Optional



### Support

* iOS Project
* OSX Project
* Android Project
* Windows Project
* Cordova (platforms/*)
* Phonegap (www/res)
* App Store
* Play Store
* Facebook
* Twitter
* Rails
* Web
* Write your own (really easy, fork and change yml)

## Notes

#### Media

Media is a logo, icon + name.


#### Phonegap or Cordova

You may generate assets for both, but the difference is:
Phonegap (`www/res`) assets are used only on Phonegap Build.
To build locally use Cordova assets (`platforms/<platform>/*`)
