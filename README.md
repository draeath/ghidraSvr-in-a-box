# ghidraSrv-in-a-box

## ... a containerized [ghidra](https://ghidra-sre.org) server!

This container should work with both Docker and Podman. Other engines, proceed at your own risk.

### Building
Building is pretty simple. Just build with a tag! If you want to elect a different ghidra version, the following `--build-arg` parameters are available (with defaults listed so you can see the formatting):

- ghidra (URL to releases changes with every release, visit the website and find the 'releases' link)
  - `GHIDRASRV_IN_A_BOX_VERSION`
    - `10.0.3_PUBLIC_20210908`
  - `GHIDRASRV_IN_A_BOX_SHA256`
    - `1e1d363c18622b9477bddf0cc172ec55e56cac1416b332a5c53906a78eb87989`

Note if the NSA changes their naming conventions this will break in all sorts of fun ways and need some changes to the Dockerfile. In fact, the release process changed between 9.x and 10.x and we now use github release downloads. If you want a version earlier than 10.0.0, you do so at your own risk. Well, everything you do with this is at your own risk!

### Running
Running is where it gets a bit more complicated.

1. You need to create a directory to house the `server.conf` and `repositories` subdirectory. You do not need to create the `repositories` subdirectory itself. You will need to mount this `rw` to `/mnt/ghidra` inside the container. Assuming `/opt/ghidra` on the host, the following argument is a good suggestion:
  - `-v "/opt/ghidra:/mnt/ghidra:rw"`
2. You need to populate `server.conf` in this directory. You may use [this](server.conf) to get you started (valid for ghidra 9.2.2, but seems fine for subsequent versions up to and including 10.0.1).
  - You MUST edit `wrapper.app.parameter.3=-ip SET_ME_TO_YOUR_FQDN` with your FQDN. You should also take care your PTR matches your forward record as ghidra will insist on using this in client project configurations. It doesn't have to *match* but it must point to a record that in turn points back to this same server.
3. You need to expose TCP ports `13100`, `13101,` and `13102` - if these can be changed, I am not aware of it. Here's a set of arguments:
  - `-p 0.0.0.0:13100:13100 -p 0.0.0.0:13101:13101 -p 0.0.0.0:13102:13102`
4. Example full command to launch the container, assuming image `localhost/ghidra:latest` and data in `/opt/ghidra`:
  - `podman container run -p 0.0.0.0:13100:13100/tcp -p 0.0.0.0:13101:13101/tcp -p 0.0.0.0:13102:13102/tcp -v "/opt/ghidra:/mnt/ghidra:rw" --rm --detach localhost/ghidra:latest`
5. You do not need to take special care to save the STDOUT/STDERR, as logging is written into the `repositories` subdirectory of the mount.
6. You do not need to keep the container around after stopping (hence `--rm` in the example) - all persistent state is in the mount.
7. If this is a first-run, you must add at least one user. This must be done with the container up and running, using the `svrAdmin` tool. The start of the container STDOUT should contain a link to a versions-specific document, but as a quickstart the following will do. It will interactively prompt for a password. You should log in via ghidra within 24 hours to change the password or the user will be purged. Currently, ghidra allows you to specify the same password as set here.
  - `podman container exec -i -t <container-name> svrAdmin -add <username> --p` 

