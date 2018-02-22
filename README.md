# mypost-ui-vrt

A _Docker_ container for MyPost frontend to run visual regression tests.

Created for internal use; extends the `mypost-ui-base` container.

Includes:
```
java-8-openjdk-amd64
google-chrome
chromium-browser
```

To build a default container from the `Dockerfile` run:
```
docker build -t benboarder/mypost-ui-vrt:latest .
```

To use the latest version run:
```
docker pull benboarder:mypost-ui-vrt
```
