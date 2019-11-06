# solr-md-newspapers

This is version **2.0.0** of the md-newspapers core configuration repository.


Check out this repository to the `cores` directory of the solr installation.

```
git clone git@bitbucket.org:umd-lib/md-newspapers-core.git md-newspapers
```

This is a 6.x core.

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations.

## Building the Docker Image

When building the Docker image, the "data.csv" file will be used to populate
the Solr database.

To build the Docker image named "md-newspapers": 

```
> docker build -t md-newspapers .
```

To run the freshly built Docker container on port 8983:

```
> docker run -it --rm -p 8983:8983 md-newspapers
```

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations.