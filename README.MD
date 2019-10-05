# Build

```
docker build -f docker/Dockerfile docker -t imposition:latest
```

# Run

```
docker run --rm -ti -v ${PWD}:/mount imposition:latest
```

(cd docker && docker build . -t imposition:latest) && docker run --rm -ti -v ${PWD}:/mount imposition:latest