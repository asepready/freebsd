Redis 7 : Use Redis Benchmark
 	
It's possible to run a benchmark test with a tool included in Redis package.

[1]	Use redis-benchmark tool like follows. For others, there are some options to specify number of requests and so on, see [redis-benchmark --help].
```sh
root@belajarfreebsd:~# redis-benchmark -h 10.0.0.30 -p 6379 -a password
====== PING_INLINE ======
  100000 requests completed in 0.58 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
  host configuration "save": 3600 1 300 100 60 10000
  host configuration "appendonly": no
  multi-thread: no

Latency by percentile distribution:
0.000% <= 0.047 milliseconds (cumulative count 1)
50.000% <= 0.151 milliseconds (cumulative count 64993)
75.000% <= 0.159 milliseconds (cumulative count 85497)
87.500% <= 0.167 milliseconds (cumulative count 95003)
96.875% <= 0.175 milliseconds (cumulative count 98371)
98.438% <= 0.183 milliseconds (cumulative count 99234)
99.609% <= 0.255 milliseconds (cumulative count 99618)
99.805% <= 0.399 milliseconds (cumulative count 99807)
99.902% <= 0.495 milliseconds (cumulative count 99908)
99.951% <= 0.631 milliseconds (cumulative count 99953)
99.976% <= 0.719 milliseconds (cumulative count 99977)
99.988% <= 0.751 milliseconds (cumulative count 99988)
99.994% <= 0.775 milliseconds (cumulative count 99994)
99.997% <= 0.783 milliseconds (cumulative count 99997)
99.998% <= 0.799 milliseconds (cumulative count 99999)
99.999% <= 0.807 milliseconds (cumulative count 100000)
100.000% <= 0.807 milliseconds (cumulative count 100000)

Cumulative distribution of latencies:
0.160% <= 0.103 milliseconds (cumulative count 160)
99.517% <= 0.207 milliseconds (cumulative count 99517)
99.672% <= 0.303 milliseconds (cumulative count 99672)
99.817% <= 0.407 milliseconds (cumulative count 99817)
99.915% <= 0.503 milliseconds (cumulative count 99915)
99.946% <= 0.607 milliseconds (cumulative count 99946)
99.969% <= 0.703 milliseconds (cumulative count 99969)
100.000% <= 0.807 milliseconds (cumulative count 100000)

Summary:
  throughput summary: 173611.12 requests per second
  latency summary (msec):
          avg       min       p50       p95       p99       max
        0.150     0.040     0.151     0.167     0.183     0.807
====== PING_MBULK ======
  100000 requests completed in 0.62 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
  host configuration "save": 3600 1 300 100 60 10000
  host configuration "appendonly": no
  multi-thread: no

.....
.....

Latency by percentile distribution:
0.000% <= 0.095 milliseconds (cumulative count 1)
50.000% <= 0.279 milliseconds (cumulative count 52922)
75.000% <= 0.335 milliseconds (cumulative count 75093)
87.500% <= 0.383 milliseconds (cumulative count 89224)
93.750% <= 0.407 milliseconds (cumulative count 94202)
96.875% <= 0.439 milliseconds (cumulative count 97251)
98.438% <= 0.471 milliseconds (cumulative count 98608)
99.219% <= 0.495 milliseconds (cumulative count 99263)
99.609% <= 0.519 milliseconds (cumulative count 99618)
99.805% <= 0.559 milliseconds (cumulative count 99815)
99.902% <= 0.631 milliseconds (cumulative count 99907)
99.951% <= 0.831 milliseconds (cumulative count 99952)
99.976% <= 1.279 milliseconds (cumulative count 99977)
99.988% <= 1.351 milliseconds (cumulative count 99988)
99.994% <= 1.375 milliseconds (cumulative count 99995)
99.997% <= 1.391 milliseconds (cumulative count 99998)
99.998% <= 1.399 milliseconds (cumulative count 99999)
99.999% <= 1.407 milliseconds (cumulative count 100000)
100.000% <= 1.407 milliseconds (cumulative count 100000)

Cumulative distribution of latencies:
0.011% <= 0.103 milliseconds (cumulative count 11)
14.254% <= 0.207 milliseconds (cumulative count 14254)
63.995% <= 0.303 milliseconds (cumulative count 63995)
94.202% <= 0.407 milliseconds (cumulative count 94202)
99.412% <= 0.503 milliseconds (cumulative count 99412)
99.892% <= 0.607 milliseconds (cumulative count 99892)
99.934% <= 0.703 milliseconds (cumulative count 99934)
99.946% <= 0.807 milliseconds (cumulative count 99946)
99.962% <= 0.903 milliseconds (cumulative count 99962)
99.969% <= 1.007 milliseconds (cumulative count 99969)
99.973% <= 1.103 milliseconds (cumulative count 99973)
99.981% <= 1.303 milliseconds (cumulative count 99981)
100.000% <= 1.407 milliseconds (cumulative count 100000)

Summary:
  throughput summary: 145560.41 requests per second
  latency summary (msec):
          avg       min       p50       p95       p99       max
        0.285     0.088     0.279     0.415     0.487     1.407