# Tilt Avatars - Getting Started Sample Project

[![Build Status](https://circleci.com/gh/tilt-dev/tilt-avatars/tree/main.svg?style=shield)](https://circleci.com/gh/tilt-dev/tilt-avatars)

Tilt Avatars is a small sample project used by the Tilt Getting Started guide.

It consists of a Python web API backend to generate avatars and a Javascript SPA (single page app) frontend.
If you are not a Python or Javascript guru, don't panic!
The focus of this project is on introducing the `Tiltfile` and other Tilt concepts: the services are demonstrative to support the guide, but you do not need to understand the code within them to be successful.

We also know that no two projects are alike!
This project uses `Dockerfile`s with Docker as the build engine and `kubectl` friendly YAML files.
These only cover a small subset of Tilt functionality but have been chosen to minimize dependencies.

Even if you're using other technologies (e.g. `podman` or `helm`), we recommend starting here to learn the Tilt fundamentals.
After you're comfortable with how Tilt works, we've got a more comprehensive guide on authoring your first `Tiltfile` from scratch that covers much more.

## Running
You'll need to first install Tilt and prerequisites (Docker + local Kubernetes cluster).

Once you've installed Tilt, clone this repo and launch Tilt:
```sh
git clone https://github.com/tilt-dev/tilt-avatars.git
cd tilt-avatars
tilt up
```

## Need Help?
Join us on the Kubernetes Slack in `#tilt`!
