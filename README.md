# Data pipeline base

This repository is a template for develop pipelines in python.

### Usage

### Run locally
- Create virtual environment
```
virtualenv --python=python3 project-name
source project-name/bin/activate
```
- Install python dependencies
```
make -C project-name install
```
- Run application
```
python project-name/app/main.py
```
### Run container
- Build docker image.
```
make -C project-name docker-build
```
- Run docker image.
```
docker run -v /local-path/secrets/pulse:/app/pulse-secret \
           -v /local-path/secrets/db-secret:/app/db-secret \
           -e APP_PULSE_SECRET=/app/pulse-secret \
           -e APP_DB_SECRET=/app/db-secret \
           containers.mpi-internal.com/yapo/data-base-pipeline:[TAG]
```

### Run test
```
make -C project-name check-style
```

### General changes

- Rename [project-name](https://github.mpi-internal.com/Yapo/data-pipeline-base/tree/master/project-name) folder for you develop name. For example **bounce-rate**.
- Rename [APPNAME](https://github.mpi-internal.com/Yapo/data-pipeline-base/blob/d330a8c59c6dff28339d44df57d575abfe145d2c/project-name/scripts/commands/vars.mk#L19) environment variable with new nombre of micro services. For each one the repositories from data, we can use the following prefixs.

| Repository    | Prefix docker image |
| ------------- |-------------|
| [data-content](https://github.mpi-internal.com/Yapo/data-content)      | data-content-**pipelineName** |
| [data-pulse](https://github.mpi-internal.com/Yapo/data-pulse)      | data-pulse-**pipelineName**      |
| [data-user-behavior](https://github.mpi-internal.com/Yapo/data-user-behavior) | data-user-behavior-**pipelineName**      |

