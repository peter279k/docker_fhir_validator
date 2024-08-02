# docker_fhir_validator

# Introduction

It's the source of Docker image for [FHIR Core Validator](https://github.com/hapifhir/org.hl7.fhir.core/releases/).

And their released versions are compatible with above FHIR Core Validator since `6.2.10` version.

- The Docker image with OpenJDK 11 is available on the [Docker hub](https://hub.docker.com/repository/docker/peter279k/docker_fhir_validator_11).
- The Docker image with OpenJDK 17 is available on the [Docker hub](https://hub.docker.com/repository/docker/peter279k/docker_fhir_validator_17).

# Usage

- Firstly, we've the `docker` command and it is available.
- If you prefer OpenJDK 11, run the `docker pull peter279k/docker_fhir_validator_11:latest` command to pull the Docker image. It includes OpenJDK 11 and latest FHIR Core Validator version.
- If you prefer OpenJDK 17, run the `docker pull peter279k/docker_fhir_validator_17:latest` command to pull the Docker image. It included OpenJDK 17 and latest FHIR Core Validator version.
- If you prefer OpenJDK 11 and FHIR Core Validator 6.3.13 version, run the `docker pull peter279k/docker_fhir_validator_11:6.3.13` command to pull the specific Docker image.
- After pulling the Docker image successfully, run the following command to verfiy it:

```sh
docker run peter279k/docker_fhir_validator_11:latest java -jar validate_cli.jar -help
```

- If you want to load package cache with offline validation, run the following commands:

```sh
# Download IG package cache folder on the FHIR CI Build
$ wget -O package.tgz https://build.fhir.org/ig/cctwFHIRterm/MOHW_TWCoreIG_Build/package.tgz

# Or Download IG package cache folder on the Taiwan MOHW
$ wget -O package.tgz https://twcore.mohw.gov.tw/ig/twcore/package.tgz

# Create directory named IG name and version
$ mkdir tw.gov.mohw.twcore

# Extract the archived file to specific directory
$ tar -xvzf package.tgz -C tw.gov.mohw.twcore

# Download example JSON file
$ wget -O examples.json.zip https://build.fhir.org/ig/cctwFHIRterm/MOHW_TWCoreIG_Build/examples.json.zip
$ rm -rf examples.json && mkdir examples.json && unzip examples.json.zip -d examples.json

# Validate it!
docker run \
    -v $PWD/tw.gov.mohw.twcore:/root/.fhir/packages/tw.gov.mohw.twcore \
    -v $PWD/examples.json:/root/examples.json \
    peter279k/docker_fhir_validator_11:latest -c "cd /root/ && java -Dfile.encoding=UTF-8 -jar validator_cli.jar ./examples.json/Patient-pat-example.json -version 4.0 -ig tw.gov.mohw.twcore"
```
