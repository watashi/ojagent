# OJAgent

OJAgent is a client to submit solutions and query status at different online
judges. It provides a uniformed interface to a lot of famous online judges.

## Installation

Add this line to your application's Gemfile:

    gem 'ojagent'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ojagent

## Usage

OJ Agent:

    require 'ojagent'

    oj = OJAgent::AnyAnget.new
    oj.login($user, $pass)
    oj.submit!($pid, $code, $lang)
    p oj.status!

Quick Submit:

    $ quicksubmit -j pat -u admin -i 1001 -s pat/1001/ -t pat/1001/test/
    $ export OJ_JUDGE=zoj
    $ export OJ_USERNAME=watashi
    $ export OJ_PASSWORD=*******
    $ quicksubmit 1001.c

For more information:

    $ quicksubmit -h
    $ quicksubmit -l
    $ ri OJAgent

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
