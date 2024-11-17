Prometheus : Visualize on Grafana

Web UI is included in Prometheus but it's also possible to visualize time series data on Grafana.

[1]	Install Grafana, refer to here.
It's OK to install it on any Node. (install it on Prometheus server Node on this example)

[2]	Access to Grafana Dashboard and Open [Connections] - [Data Sources] on the left menu.
<img src="./imgs/d/2.png">
[3]	Click [Add data source].
<img src="./imgs/d/3.png">
[4]	Click [Prometheus].
<img src="./imgs/d/4.png">
[5]	Enter the endpoint URL of your Prometheus server in the URL field and click the Save & Test button at the bottom of the screen.
If you have enabled authentication or HTTPS, configure the necessary settings accordingly.
If there are no problems, you will see the message [Successfully queried the prometheus API].
<img src="./imgs/d/5.png">
<img src="./imgs/d/5b.png">
[6]	Next, Click [Dashboard] on the left menu.
<img src="./imgs/d/6.png">
[7]	Click [Create Dashboard].
<img src="./imgs/d/7.png">
[8]	Click [Add visualization].
<img src="./imgs/d/8.png">
[9]	Click [Prometheus].
<img src="./imgs/d/9.png">
[10] From the Metrics field, select the query for the data you want to graph.
Once you select a query, it will be graphed. To save the Dashboard, click the Save button at the top.
<img src="./imgs/d/10.png">
[11] By adding queries, it is also possible to display multiple graphs on one screen.
<img src="./imgs/d/11.png">