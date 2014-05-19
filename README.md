# Scrutinize

Ruby method call searcher.

## Usage

```
Usage: scrutinize [options] [method_name ...]
    -t, --targets=MANDATORY          A comma separated list of targets to search for the next set of methods on
    -m, --methods=MANDATORY          A comma separated list of methods to search for on the last listed set of targets
    -d, --directory=MANDATORY        The directory to search
    -c, --config=MANDATORY           A YAML config file to load
    -r, --ruby-version=MANDATORY     The Ruby version of the files we're searching through
    -h, --help                       Show this message
```

### Examples

**Search for calls to `puts` on any target:**

```
mastahyeti% scrutinize puts
./lib/sinatra/base.rb:1136 @env['rack.errors'].puts
./lib/sinatra/base.rb:1416 $stderr.puts
./test/integration/app.rb:58 puts
...
```

**Search for calls to `puts` with *no* target:**

```
mastahyeti% scrutinize -t SCRUTINIZE_NONE puts
./test/integration/app.rb:58 puts
```

**Search for calls to `read` or `write` on the `IO` or `File` modules:**

```bash
mastahyeti% scrutinize -t IO,File -m read,binread
./lib/sinatra/base.rb:1275 IO.binread
./lib/sinatra/base.rb:1275 IO.read
./test/encoding_test.rb:13 File.read
...
```

**Search for calls to any method on the `IO` or `File` modules:**

```bash
mastahyeti% scrutinize -t IO,File
./lib/sinatra/base.rb:44 File.fnmatch
./lib/sinatra/base.rb:1275 IO.read
./test/integration_helper.rb:26 File.expand_path
./test/integration_helper.rb:42 IO.popen
./test/yajl_test.rb:9 File.dirname
...
```

## Installation

```
bundle install
rake install
```
