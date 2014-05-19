### Scrutinize

Ruby method call searcher.

#### Usage

```
Usage: scrutinize [options] [method_name ...]
    -r, --ruby-version=MANDATORY     The Ruby version of the files we're searching through
    -d, --directory=MANDATORY        The directory to search
    -c, --config=MANDATORY           A YAML config file to load
    -t, --targets=MANDATORY          A comma separated list of targets to search for the next set of methods on
    -m, --methods=MANDATORY          A comma separated list of methods to search for on the last listed set of targets
    -h, --help                       Show this message
```


#### Installation

```
bundle install
rake install
```

#### ToDo

* [ ] Load config from file (saved searches).
* [ ] Cache parsed method calls.
