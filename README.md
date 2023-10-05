# integrationer-steps-ruby-runner

### Running the image
The container image must be able to run on a read-only file system.

Running shell locally:
```bash
docker run -it --platform linux/amd64 --tmpfs "/tmp" --read-only --rm ghcr.io/standout/integrationer-steps-ruby-runner:<version> sh
```

When mounted in the Kubernetes cluster the folder `/tmp` is mounted as a `emptyDir`.
Kubernetes does not set the correct permissions for `/tmp`.
This will affect for example the Ruby Temp-folder lookup.

To correct this we use a initContainer to set the correct permission.
`sticky-bit` is set on the `/tmp/app-tmp` folder. And this folder is set as out temp-folder using environment variable `TMPDIR` in this container.

### Build and push to GitHub packages
A new release will publish a new image on GitHub packages.

Creating manual release:
```bash
docker build -t ghcr.io/standout/integrationer-steps-ruby-runner:latest -t ghcr.io/standout/integrationer-steps-ruby-runner:<version> .
```

Using Mac M1:
```bash
docker buildx build --platform linux/amd64 -t ghcr.io/standout/integrationer-steps-ruby-runner:latest -t ghcr.io/standout/integrationer-steps-ruby-runner:<version> .
```

Pushing:
```bash
docker push ghcr.io/standout/integrationer-steps-ruby-runner:latest
docker push ghcr.io/standout/integrationer-steps-ruby-runner:<version>
```
