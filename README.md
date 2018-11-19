Display a [Le Wagon](http://www.lewagon.org) tickets status with a [Lifx](https://www.lifx.com) device.

## Config

Connect your Lifx device to the internet.
Open `config.yml` and edit the `batch_slug` and the `brightness`.
Create a `secret.yml` file. Add the API token under `api_token` and your light bulb's ID under `light_id`.

## Launch

Start the daemon

```bash
# Clone the project and cd to it
$ ./daemon.rb start
```

Stop the daemon

```bash
$ ./daemon.rb stop
```
