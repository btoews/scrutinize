### Scrutinize

Ruby method call searcher.

#### Usage

```
Usage: scrutinize [options] [method_name ...]
    -t, --targets=MANDATORY          A comma separated list of targets to search for the next set of methods on
    -m, --methods=MANDATORY          A comma separated list of methods to search for on the last listed set of targets
    -d, --directory=MANDATORY        The directory to search
    -c, --config=MANDATORY           A YAML config file to load
    -r, --ruby-version=MANDATORY     The Ruby version of the files we're searching through
    -h, --help                       Show this message
```


#### Installation

```
bundle install
rake install
```

#### ToDo

* [ ] Cache parsed method calls.
