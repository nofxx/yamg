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


[![Gem Version](https://badge.fury.io/rb/yamg.svg)](http://badge.fury.io/rb/yamg)
[![Dependency Status](https://gemnasium.com/nofxx/yamg.svg)](https://gemnasium.com/nofxx/yamg)
[![Build Status](https://travis-ci.org/nofxx/yamg.svg?branch=master)](https://travis-ci.org/nofxx/yamg)

YAMG - Yet Another Media Generator

http://github.com/nofxx/yamg


## Install

Linux

    nice-pkg-manager install imagemagick phantomjs librsvg ruby
    gem install yamg

OSX

    brew install imagemagick phantomjs librsvg ruby
    gem install yamg

Trouble with phantomjs gem? Use NPM to install PhantomJS:

    npm -g install phantomjs


## Features

* Find **best version** (size) to use from icons folder.
* Shrinks binaries from the *closest or greater size version*.
* Raster **SVG to PNG** with exact size and dpi.
* Splash screen/banner generation with gravity.
* Works with **iOS/Android/Other** mobile with *Phonegap* or *Cordova*.
* Exports icons and splashes for *stores and social networks*.
* Creates **multi-layered _.ico_** files.
* Screenshots for stores and advertising.


## Use

First time

    yamg init

The config file `yamg.yml` will be created on the folder.
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

From the `yamg.yml` file you may configure differents source paths.
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

### ICO

YAMG will automatically find the best version and combine:
16px, 32px and 48px into a .ico for the web.
Also check out #HTML to meta tags for all this.


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
* Cordova (res/*)
* Phonegap (www/res)
* App Store
* Play Store
* Facebook
* Twitter
* Web (Any framework: rails, sinatra, js...)
* Write your own (really easy, fork and change yml)


## HTML

Meta tags in HTML:

https://github.com/joshbuchea/HEAD


```html
<link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-57x57.png">
<link rel="apple-touch-icon" sizes="60x60" href="/apple-touch-icon-60x60.png">
<link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-72x72.png">
<link rel="apple-touch-icon" sizes="76x76" href="/apple-touch-icon-76x76.png">
<link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114x114.png">
<link rel="apple-touch-icon" sizes="120x120" href="/apple-touch-icon-120x120.png">
<link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144x144.png">
<link rel="apple-touch-icon" sizes="152x152" href="/apple-touch-icon-152x152.png">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon-180x180.png">
<link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
<link rel="icon" type="image/png" href="/android-chrome-192x192.png" sizes="192x192">
<link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96">
<link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
<link rel="manifest" href="/manifest.json">
<meta name="msapplication-TileColor" content="#da532c">
<meta name="msapplication-TileImage" content="/mstile-144x144.png">
<meta name="theme-color" content="#ffffff">
```

Meta tags in HAML:

```haml
%link{href: "/apple-touch-icon-57x57.png", rel: "apple-touch-icon", sizes: "57x57"}/
%link{href: "/apple-touch-icon-60x60.png", rel: "apple-touch-icon", sizes: "60x60"}/
%link{href: "/apple-touch-icon-72x72.png", rel: "apple-touch-icon", sizes: "72x72"}/
%link{href: "/apple-touch-icon-76x76.png", rel: "apple-touch-icon", sizes: "76x76"}/
%link{href: "/apple-touch-icon-114x114.png", rel: "apple-touch-icon", sizes: "114x114"}/
%link{href: "/apple-touch-icon-120x120.png", rel: "apple-touch-icon", sizes: "120x120"}/
%link{href: "/apple-touch-icon-144x144.png", rel: "apple-touch-icon", sizes: "144x144"}/
%link{href: "/apple-touch-icon-152x152.png", rel: "apple-touch-icon", sizes: "152x152"}/
%link{href: "/apple-touch-icon-180x180.png", rel: "apple-touch-icon", sizes: "180x180"}/
%link{href: "/favicon-32x32.png", rel: "icon", sizes: "32x32", type: "image/png"}/
%link{href: "/android-chrome-192x192.png", rel: "icon", sizes: "192x192", type: "image/png"}/
%link{href: "/favicon-96x96.png", rel: "icon", sizes: "96x96", type: "image/png"}/
%link{href: "/favicon-16x16.png", rel: "icon", sizes: "16x16", type: "image/png"}/
%link{href: "/manifest.json", rel: "manifest"}/
%meta{content: "#da532c", name: "msapplication-TileColor"}/
%meta{content: "/mstile-144x144.png", name: "msapplication-TileImage"}/
%meta{content: "#ffffff", name: "theme-color"}/
```

## Notes & Thanks

RSVG - Impossible without
https://github.com/svg/svgo

Real Favicon Generator - Perfect, but I wanted it automated (behold YAMG).
http://realfavicongenerator.net
https://github.com/audreyr/favicon-cheat-sheet
https://epicfavicongenerator.com/

http://wkhtmltopdf.org/

### Media

Media is a logo, icon + name.

## Cordova

Don't forget to add to your `config.xml`:

https://cordova.apache.org/docs/en/latest/config_ref/images.html


### Phonegap or Cordova

You may generate assets for both, but the difference is:
Phonegap (`www/res`) assets are used only on Phonegap Build.
To build locally use Cordova assets (`platforms/<platform>/*`)

### Cordova Rake Tasks

If you're working with cordova, add some Ruby to it:

https://github.com/nofxx/cordova-rake

## Issues

http://github.com/nofxx/yamg/issues
