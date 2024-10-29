FROM mkenjis/ubjava_img

#ARG DEBIAN_FRONTEND=noninteractive
#ENV TZ=US/Central

RUN apt-get update && apt-get install -y python3-pip git

RUN pip3 install numpy pyspark mlflow

#WORKDIR /usr/local

# wget https://archive.apache.org/dist/spark/spark-3.0.3/spark-3.0.3-bin-hadoop2.7.tgz
#ADD spark-3.0.3-bin-hadoop2.7.tgz .

WORKDIR /root
RUN echo "" >>.bashrc \
# && echo 'export SPARK_HOME=/usr/local/spark-3.0.3-bin-hadoop2.7' >>.bashrc \
# && echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native' >>.bashrc \
# && echo 'export HADOOP_CONF_DIR=$SPARK_HOME/conf' >>.bashrc \
# && echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >>.bashrc \
# && echo 'export PYSPARK_PYTHON=/usr/bin/python3.8' >>.bashrc \
# && echo 'export PYSPARK_DRIVER_PYTHON=/usr/bin/jupyter' >>.bashrc
&& echo 'export MLFLOW_TRACKING_URI=http://0.0.0.0:5000' >>.bashrc

# authorized_keys already create in ubjava_img to enable containers connect to each other via passwordless ssh

COPY create_conf_files.sh .
RUN chmod +x create_conf_files.sh

COPY run_spark.sh .
RUN chmod +x run_spark.sh

COPY stop_spark.sh .
RUN chmod +x stop_spark.sh

EXPOSE 10000 7077 4040 8080 8081 8082 8888 5000

CMD /bin/bash -c "/root/run_spark.sh"; sleep infinity
