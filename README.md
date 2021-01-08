# integrationer-steps-ruby-runner
### Build and push to GitHub packages
A new release will publish a new image on GitHub packages.

Creating manual release:
```bash
docker build -t ghcr.io/standout/integrationer-steps-ruby-runner:latest -t ghcr.io/standout/integrationer-steps-ruby-runner:<version> .
docker push ghcr.io/standout/integrationer-steps-ruby-runner:latest
docker push ghcr.io/standout/integrationer-steps-ruby-runner:<version>
```
