# pyspark-jupyterlab

This Dockerfile contains the latest versions of PySpark and JupyterLab, along with a sql magic command extension.

To build the image and run the container on Windows:

```bash
docker build -t pyspark-jupyter .
docker run -p 8888:8888 -p 4040:4040 -v %cd%:/app_host pyspark-jupyter
```

After running the image, go to http://localhost:8888/ to load JupyterLab. See the demo notebook for an example of how to enable the `%%sql` magic command.
