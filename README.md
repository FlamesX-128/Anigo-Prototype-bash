# Anigo - Prototype bash

<div align="center">
    <h1>Anigo</h1>
    <p>
        A tool to search and watch anime with the ability to increase its functionality.
    </p>
</div>

---

<div align="center">
    <img src="https://github.com/FlamesX-128/Anigo-Prototype-bash/blob/main/assets/image.png" height="200" />
</div>

---

<div align="center">
    <p>
        <a href="https://github.com/FlamesX-128/Anigo-Prototype-bash/graphs/contributors">
            <img src="https://img.shields.io/github/contributors/FlamesX-128/Anigo-Prototype-bash" alt="contributors" />
        </a>
        <a href="">
            <img src="https://img.shields.io/github/last-commit/FlamesX-128/Anigo-Prototype-bash" alt="last update" />
        </a>
        <a href="https://github.com/FlamesX-128/Anigo-Prototype-bash/network/members">
            <img src="https://img.shields.io/github/forks/FlamesX-128/Anigo-Prototype-bash" alt="forks" />
        </a>
        <a href="https://github.com/FlamesX-128/Anigo-Prototype-bash/stargazers">
            <img src="https://img.shields.io/github/stars/FlamesX-128/Anigo-Prototype-bash" alt="stars" />
        </a>
        <a href="https://github.com/FlamesX-128/Anigo-Prototype-bash/issues/">
            <img src="https://img.shields.io/github/issues/FlamesX-128/Anigo-Prototype-bash" alt="open issues" />
        </a>
        <a href="https://github.com/FlamesX-128/Anigo-Prototype-bash/blob/main/LICENSE">
            <img src="https://img.shields.io/github/license/FlamesX-128/Anigo-Prototype-bash.svg" alt="license" />
        </a>
    </p>
</div>

<br />

## Installation

### Using curl

```bash
curl https://raw.githubusercontent.com/FlamesX-128/Anigo-Prototype-bash/main/anigo.bash -o anigo.bash
```

## Plugin directory

You can add the url of the script in the "anigo/config.json" file in the plugins property, the script will download it from the given url.

## Create plugin

### Write plugin

```bash
#! /usr/bin/env bash

# The function name is in the format of <plugin_name>_c-<component_name>
# "c" is the component type, abbreviated from "controller"
# "loading" is the component name

# You can use any name you want, but it is recommended to use the format above.
# The function name is used to identify the component, so it is recommended to use the format above.
my_plugin_c-loading() {
    # The function body is the code that will be executed when the component is called.
    gum spin -s minidot --title 'Loading my_plugin' -- sleep 10
}

__INIT__() {
    # Register the controller
    # The key is in the format of <plugin_name>:<component_type>:<component_name>
    # The value is the function name

    # The controller is a type of component provided by the core, you can create your own component type.
    # The controller is used to control the flow of the program.

    components["my_plugin:controller:loading"]=my_plugin_c-loading
}
```

### Use plugin

You can just add it to "anigo/plugins"

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0)
