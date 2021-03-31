# ghidraSrv-in-a-box

## ... a containerized [ghidra](https://ghidra-sre.org) server!

This container should work with both Docker and Podman. Other engines, proceed at you're own risk.

### Building
Building is pretty simple. Just build with a tag! If you want to elect a different ghidra or [corretto](https://aws.amazon.com/corretto/), the following `--build-arg` parameters are available (with defaults listed so you can see the formatting):

- Corretto (releases for Java 11 are found [here](https://github.com/corretto/corretto-11/releases) - note that ghidra requires Java 11 at this time)
  - `CORRETTO_URL`
    - `https://corretto.aws/downloads/resources/11.0.10.9.1/java-11-amazon-corretto-jdk_11.0.10.9-1_amd64.deb`
  - `CORRETTO_FILE`
    - `java-11-amazon-corretto-jdk_11.0.10.9-1_amd64.deb`
  - `CORRETTO_MD5`
    - `6e5a33117ef8cb771a7ef48b6fe97fc2`
- ghidra (URL to releases changes with every release, visit the website and find the 'releases' link)
  - `GHIDRASRV_IN_A_BOX_VERSION`
    - `9.2.2_PUBLIC_20201229`
  - `GHIDRASRV_IN_A_BOX_SHA256`
    - `8cf8806dd5b8b7c7826f04fad8b86fc7e07ea380eae497f3035f8c974de72cf8`

Note if the NSA changes their naming conventions this will break in all sorts of fun ways and need some changes to the Dockerfile.

### Running
Running is where it gets a bit more complicated.

1. You need to create a directory to house the `server.conf` and `repositories` subdirectory. You do not need to create the `repositories` subdirectory itself. You will need to mount this `rw` to `/mnt/ghidra` inside the container. Assuming `/opt/ghidra` on the host, the following argument is a good suggestion:
  - `-v "/opt/ghidra:/mnt/ghidra:rw"`
2. You need to populate `server.conf` in this directory. You may use [this](server.conf) to get you started (valid for ghidra 9.2.2). 
  - You MUST edit `wrapper.app.parameter.3=-ip SET_ME_TO_YOUR_FQDN` with your FQDN. You should also take care your PTR matches your forward record as ghidra will insist on using this in client project configurations. It doesn't have to *match* but it must point to a record that in turn points back to this same server.
3. You need to expose TCP ports `13100`, `13101,` and `13102` - if these can be changed, I am not aware of it. Here's a set of arguments:
  - `-p 0.0.0.0:13100:13100 -p 0.0.0.0:13101:13101 -p 0.0.0.0:13102:13102`
4. Example full command to launch the container, assuming image `localhost/ghidra:latest` and data in `/opt/ghidra`:
  - `podman container run -p 0.0.0.0:13100:13100 -p 0.0.0.0:13101:13101 -p 0.0.0.0:13102:13102 -v "/opt/ghidra:/mnt/ghidra:rw" --rm --detach localhost/ghidra:latest`
5. You do not need to take special care to save the STDOUT/STDERR, as logging is written into the `repositories` subdirectory of the mount.
6. You do not need to keep the container around after stopping (hence `--rm` in the example) - all persistent state is in the mount.
7. If this is a first-run, you must add at least one user. This must be done with the container up and running, using the `svrAdmin` tool. The start of the container STDOUT should contain a link to a versions-specific document, but as a quickstart the following will do. It will interactively prompt for a password. You should log in via ghidra within 24 hours to change the password or the user will be purged. Currently, ghidra allows you to specify the same password as set here.
  - `podman container exec -i -t <container-name> svrAdmin -add <username> --p` 


