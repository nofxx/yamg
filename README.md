# YAMG

      ┏                                                                               ┓

           _____      _____       _____        ______  _______         _____
          |\    \    /    /|  ___|\    \      |      \/       \    ___|\    \
          | \    \  /    / | /    /\    \    /          /\     \  /    /\    \
          |  \____\/    /  /|    |  |    |  /     /\   / /\     ||    |  |____|
           \ |    /    /  / |    |__|    | /     /\ \_/ / /    /||    |    ____
            \|___/    /  /  |    .--.    ||     |  \|_|/ /    / ||    |   |    |
                /    /  /   |    |  |    ||     |       |    |  ||    |   |_,  |
               /____/  /    |____|  |____||\____\       |____|  /|\ ___\___/  /|
               |    | /     |    |  |    || |    |      |    | / | |   /____ / |
               |____|/      |____|  |____| \|____|      |____|/   \|___|    | /
                                                                       |____|/

      ┗                                                                               ┛


[![Gem Version](https://badge.fury.io/rb/yamg.png)](http://badge.fury.io/rb/yamg)
[![Dependency Status](https://gemnasium.com/nofxx/yamg.svg)](https://gemnasium.com/nofxx/yamg)
[![Build Status](https://travis-ci.org/nofxx/yamg.png?branch=master)](https://travis-ci.org/nofxx/yamg)

YAMG - Yet Another Media Generator

http://github.com/nofxx/yamg


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

First time

    yamg init

A `.yamg.yml` will be created on the folder.
From now on to recompile everything when needed:

    yamg

An example folder `/art` of a project:


```
art
├── icons
│   ├── icon16.png
│   ├── icon32.png
│   └── icon512.svg
├── media
│   └── logo.svg
└─── splash
    ├── center.png
    ├── north.png
    └── southeast.png

```

From the `.yamg.yml` you may configure differents source paths.
Also configure every export location you need (check #Support)


## Icons

Your main icon(s) may be SVG or PNG. Or both:
SVG is always the best choice, it will be rasterized and not resized.
Except will be with really small (16x16, 32x32, 64x64@2x) icons:
A canvas for you to bring joy to the world with your pixel art skills.


### PNG

Multiple sizes:
Just save your files with the size in pixels first, example:
In the 'icons/' folder: '16-icon.png', '32-icon.png', '512-icon.png'.
YAMG will choose the best size for the case, and don't touch
the icon if sizes are a match.

It's ok to (or if you) have only one png icon, make it >512px.

### SVG

You may still use best size match: Just have you folder:
'16-icon.svg', '256-icon.svg', and problably not many other sizes:
The SVG will be rasterized in the correct size needed.


## Splash

Up to 9 images may be placed in a splash.
It's not patch 9, think gravity: images will be pulled towards.
Note: The center splash image must be named 'center'.

### Gravity

Just save you files with the names: 'north', 'northeast', 'south'...
Gravity will put em in the correct place, with a lil padding.


## Media

Addional media.
There's also media generator for app stores.


## Screenshots (phantomjs)

To generate default screenshots (stores and whatnot) provide the url:

```
screenshot:
  url: 'localhost:7000'
```


Custom screenshots (notice the plural):

```
screenshots:
  another-one:
    url: 'github.com'
    size: [1280, 720]  # W x H
    scroll: 100        # Optional
    dpi: 2             # Optional, 2 for HiDPI
```


Note: Waiting for a pull-request on screencap for hidpi.

## Config file

```yaml
icon:
  path: 'folder/'
  round: true # defaults to false

splash:
  path: 'folder/'
  background: #rgb

screenshot:
  path: 'url://'
```


Custom location:

    some-project:
      icon: [32, 64, 128]


Note: For Apple Store make sure to add round false if your default is true:

```
compile:
  apple:
    rounded: false
```

## Support

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
* Web (Any framework: rails, sinatra, js...)
* Write your own (really easy, fork and change yml)

## Notes

RSVG
https://github.com/svg/svgo


### Media

Media is a logo, icon + name.


### Phonegap or Cordova

You may generate assets for both, but the difference is:
Phonegap (`www/res`) assets are used only on Phonegap Build.
To build locally use Cordova assets (`platforms/<platform>/*`)

### Cordova Rake Tasks

If you're working with cordova, add some Ruby to it:

https://github.com/nofxx/cordova-rake

## Issues

http://github.com/nofxx/yamg/issues
