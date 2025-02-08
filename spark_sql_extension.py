from IPython.core.magic import register_line_magic, register_cell_magic
from IPython import get_ipython

ipython = get_ipython()
ipython.run_line_magic("load_ext", __name__)

def load_ipython_extension(ipython):
    global spark
    from pyspark.sql import SparkSession
    spark = SparkSession.builder.appName("Spark SQL").getOrCreate()

    @register_line_magic
    @register_cell_magic
    def sql(line, cell=None):
        if cell is None:
            query = line
        else:
            query = cell
        return spark.sql(query).show()