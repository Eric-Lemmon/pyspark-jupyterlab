FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade system packages, install Python 3
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    openjdk-11-jdk \
    python3 \
    python3-venv \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Create a virtual environment and install packages
WORKDIR /app
RUN python3 -m venv /app/venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Activate the virtual environment for installation
RUN . $VIRTUAL_ENV/bin/activate && \
    pip install --upgrade pip && \
    pip install pyspark jupyterlab findspark ipython-sql

# Set up PySpark for Jupyter
COPY spark_sql_extension.py /app
COPY demo.ipynb /app

# Verify installations by checking versions
RUN . $VIRTUAL_ENV/bin/activate && \
    pyspark --version && \
    jupyter lab --version

# Link app_host to app to ease mounting from host
RUN ln -s /app_host /app

# Make port 4040 available for Spark UI and 8888 for JupyterLab
EXPOSE 4040
EXPOSE 8888

# Run JupyterLab using Python from the virtual environment
CMD ["/bin/bash", "-c", "source /app/venv/bin/activate && exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=''"]
