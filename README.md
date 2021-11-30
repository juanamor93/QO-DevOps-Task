# QO-DevOps-Task

## 1. Set up a 3 node Elasticsearch cluster on Linux. You will need to create 3 Linux nodes on the same network to talk to each other in a virtual environment (VMware/VirtualBox/Cloud Provider) and configure the cluster.
![Elasticsearch cluster](Images/elasticsearchcluster.png)

## 2. Test the redundancy of the cluster. 
### 1. Shut down a node and confirm that the cluster is still operational
![2 nodes](Images/2node.png)
### 2. Use various commands to confirm that processes and/or services are running
```
curl localhost:9200/_cat/health
sudo systemctl status elasticsearch.service
```
![commands](Images/commands.png)
## 3. Create a simple Kibana dashboard.
![dashboard](Images/dashboard.png)

