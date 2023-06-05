[![Deploy nexus release](https://github.com/jeroenkolk/nexus3-docker-arm/actions/workflows/deploy_new_version.yml/badge.svg)](https://github.com/jeroenkolk/nexus3-docker-arm/actions/workflows/deploy_new_version.yml)

[Source code](https://github.com/jeroenkolk/nexus3-docker-arm)

# Sonatype Nexus 3 ARM image

Rebuild of the [sonatype/nexus3](https://hub.docker.com/r/sonatype/nexus3) since Sonatype does not publish a ARM based image.

# Automatic tag creation

In the `getNexusVersion.sh` script you will find the script that checks if Sonatype has published a new
version of Nexus. If this version does not exist in the [jeroenkolk/nexus3-docker-arm](https://hub.docker.com/r/jeroenkolk/nexus3-docker-arm)
registry it will create a new release.

A job is automatically scheduled at 12:00 each day.

## Dockerhub

- [jeroenkolk/nexus3-docker-arm](https://hub.docker.com/r/jeroenkolk/nexus3-docker-arm)

Pull using
```shell
docker pull jeroenkolk/nexus3-docker-arm:latest
docker pull jeroenkolk/nexus3-docker-arm:main
docker pull jeroenkolk/nexus3-docker-arm:${nexus3 version starting from 3.54.1-01}
```

## Credits

- [klo2k/nexus3-docker](https://github.com/klo2k/nexus3-docker) for inspiration of this Dockerfile
