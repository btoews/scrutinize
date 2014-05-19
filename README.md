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
$ scrutinize puts
./foo.rb:6 f.puts
./foo.rb:7 puts
```

**Search for calls to `puts` with *no* target:**

```
$ scrutinize -t SCRUTINIZE_NONE puts
./foo.rb:7 puts
```

**Search for calls to `read` or `write` on the `IO` or `File` modules:**

```bash
$ scrutinize -t IO,File -m read,write
./foo.rb:1 File.read
./foo.rb:2 IO.read
./foo.rb:3 IO.write
```

**Search for calls to any method on the `IO` or `File` module:**

```bash
$ scrutinize -t IO,File
./foo.rb:1 File.read
./foo.rb:2 IO.read
./foo.rb:3 IO.write
./foo.rb:4 File.open
```

## Installation

```
bundle install
rake install
```
