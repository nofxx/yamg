# Yamg
[![Gem Version](https://badge.fury.io/rb/yamg.png)](http://badge.fury.io/rb/yamg)
[![Coverage Status](https://coveralls.io/repos/nofxx/yamg/badge.png?branch=master)](https://coveralls.io/r/nofxx/yamg?branch=master)
[![Dependency Status](https://gemnasium.com/nofxx/yamg.svg)](https://gemnasium.com/nofxx/yamg)
[![Code Climate](https://codeclimate.com/github/nofxx/yamg.png)](https://codeclimate.com/github/nofxx/yamg)
[![Build Status](https://travis-ci.org/nofxx/yamg.png?branch=master)](https://travis-ci.org/nofxx/yamg)


                       .-.
                         ;  :                              .-.
                       .;:  :     .-.      . ,';.,';.      `-'    .-.
                      .;' \ :    ;   :     ;;  ;;  ;;     ;'    .;.-'
                  .:'.;    \:    `:::'-'  ';  ;;  ';   _.;:._.   `:::'
                 (__.'      `.           _;        `-'



Names as first class citizens


## Install

    gem 'yamg'


## Use


```
name = Name.new('Jules Verne')
name.first  # 'Jules'
name.last   # 'Verne'
name.to_s   # 'Jules Verne'
```


Accepts prefix, suffix and middlenames:

```
name = Name.new('Sir Arthur C. Clark')
name.title  # 'Sir'
name.first  # 'Arthur'
name.last   # 'Clark'
name.to_s("%l %m, %f")  # Clark C., Arthur
```

Accepts and detects company names and suffixes:

```
name = Name.new('ACME Corp LLC')
name.first  # 'ACME'
name.last   # 'Corp'
name.suffix # 'LLC'
```


## ActiveModel

Working on it:

* to params hash
* cached/customizable string
* sanitized string
