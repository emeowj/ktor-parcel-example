# Template application using ktor + parcel

## Development mode

To run the server with hot reload in both frontend ui and backend server:

1. In a terminal tab: `cd src/ui; yarn dev`
1. Open a new terminal tab: `./gradlew build -t` (or `./gradlew classes -t`)
1. Open another terminal tab: `./gradlew run`

Edit frontend source and/or backend server code, refresh the browser to see the changes.

## Build for production

**Requires**: `docker`

```bash
$ docker build -t ktor-example .
$ docker run -it -p 8080:8080 ktor-example
```

Visit http://localhost:8080
