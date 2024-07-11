#!/bin/bash

echo "Manual Docker image building and publishing works is started!"
echo "Fetching first 30 latest FHIR Core Validator releases..."

releases=$(curl --silent "https://api.github.com/repos/hapifhir/org.hl7.fhir.core/tags?order=desc" | grep '"name": ' | awk '{print $2}' | sed -e 's/[",\,]//g')

if [[ ! -f password.txt ]]; then
    echo "password.txt file is not found."
    exit 1;
fi;

username=$(cat password.txt | head -n 1)
password=$(cat password.txt | tail -n 1)

docker login -u $username -p $password

for release in $(echo $releases)
do
    matched=$(echo $release | grep -c '^v')
    if [[ $matched > 0 ]]; then
        echo "The $release verison should be ignored..."
        continue
    fi;

    echo "Building $release for OpenJDK 11"

    cp Dockerfile_JDK_11_manual_example Dockerfile_JDK_11_manual
    sed -i "s/latest/$release/g" Dockerfile_JDK_11_manual
    docker build -f Dockerfile_JDK_11_manual -t docker_fhir_validator_11 .
    docker tag docker_fhir_validator_11 "$username/docker_fhir_validator_11:$release"
    docker push "$username/docker_fhir_validator_11:$release"

    echo "Publishing $release for OpenJDK 11 has been done!"

    echo "Building $release for OpenJDK 17"

    cp Dockerfile_JDK_17_manual_example Dockerfile_JDK_17_manual
    sed -i "s/latest/$release/g" Dockerfile_JDK_17_manual
    docker build -f Dockerfile_JDK_17_manual -t docker_fhir_validator_17 .
    docker tag docker_fhir_validator_17 "$username/docker_fhir_validator_17:$release"
    docker push "$username/docker_fhir_validator_17:$release"

    echo "Publishing $release for OpenJDK 17 has been done!"
done;
