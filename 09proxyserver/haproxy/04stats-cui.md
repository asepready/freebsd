HAProxy : Refer to the Statistics (CUI)2024/04/16
 	
Configure HAProxy to see HAProxy Statistics Reports with commands.

[1] Install required package.
```sh
root@belajarfreebsd:~# pkg install -y socat
```
[2] Configure HAProxy.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/haproxy.conf
# add setting in [global] section
global
.....
.....
        stats socket /usr/local/haproxy/stats

root@belajarfreebsd:~# mkdir /usr/local/haproxy
root@belajarfreebsd:~# chown haproxy:haproxy /usr/local/haproxy
root@belajarfreebsd:~# service haproxy reload
```
[3] Refer to the Statistics like follows.
```sh
# display current stats
root@belajarfreebsd:~# echo "show info" | socat /usr/local/haproxy/stats stdio
Name: HAProxy
Version: 2.9.6-9eafce5
Release_date: 2024/02/26
Nbthread: 2
Nbproc: 1
Process_num: 1
Pid: 1105
Uptime: 0d 0h00m55s
Uptime_sec: 55
Memmax_MB: 0
PoolAlloc_MB: 0
PoolUsed_MB: 0

.....
.....

Start_time_sec: 1713231660
Tainted: 0x40
TotalWarnings: 0
MaxconnReached: 0
BootTime_ms: 7
Niced_tasks: 0

# display current stats with CSV style
root@belajarfreebsd:~# echo "show stat" | socat /usr/local/haproxy/stats stdio
# pxname,svname,qcur,qmax,scur,smax,slim,stot,bin,bout,dreq,dresp,ereq,econ,eresp,wretr,wredis,status,weight,act,bck,chkfail,chkdown,lastchg,downtime,qlimit,pid,iid,sid,throttle,lbtot,tracked,type,rate,rate_lim,rate_max,check_status,check_code,check_duration,hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,hanafail,req_rate,req_rate_max,req_tot,cli_abrt,srv_abrt,comp_in,comp_out,comp_byp,comp_rsp,lastsess,last_chk,last_agt,qtime,ctime,rtime,ttime,agent_status,agent_code,agent_duration,check_desc,agent_desc,check_rise,check_fall,check_health,agent_rise,agent_fall,agent_health,addr,cookie,mode,algo,conn_rate,conn_rate_max,conn_tot,intercepted,dcon,dses,wrew,connect,reuse,cache_lookups,cache_hits,srv_icur,src_ilim,qtime_max,ctime_max,rtime_max,ttime_max,eint,idle_conn_cur,safe_conn_cur,used_conn_cur,need_conn_est,uweight,agg_server_status,agg_server_check_status,agg_check_status,srid,sess_other,h1sess,h2sess,h3sess,req_other,h1req,h2req,h3req,proto,-,ssl_sess,ssl_reused_sess,ssl_failed_handshake,quic_rxbuf_full,quic_dropped_pkt,quic_dropped_pkt_bufoverrun,quic_dropped_parsing_pkt,quic_socket_full,quic_sendto_err,quic_sendto_err_unknwn,quic_sent_pkt,quic_lost_pkt,quic_too_short_dgram,quic_retry_sent,quic_retry_validated,quic_retry_error,quic_half_open_conn,quic_hdshk_fail,quic_stless_rst_sent,quic_conn_migration_done,quic_transp_err_no_error,quic_transp_err_internal_error,quic_transp_err_connection_refused,quic_transp_err_flow_control_error,quic_transp_err_stream_limit_error,quic_transp_err_stream_state_error,quic_transp_err_final_size_error,quic_transp_err_frame_encoding_error,quic_transp_err_transport_parameter_error,quic_transp_err_connection_id_limit,quic_transp_err_protocol_violation_error,quic_transp_err_invalid_token,quic_transp_err_application_error,quic_transp_err_crypto_buffer_exceeded,quic_transp_err_key_update_error,quic_transp_err_aead_limit_reached,quic_transp_err_no_viable_path,quic_transp_err_crypto_error,quic_transp_err_unknown_error,quic_data_blocked,quic_stream_data_blocked,quic_streams_blocked_bidi,quic_streams_blocked_uni,h3_data,h3_headers,h3_cancel_push,h3_push_promise,h3_max_push_id,h3_goaway,h3_settings,h3_no_error,h3_general_protocol_error,h3_internal_error,h3_stream_creation_error,h3_closed_critical_stream,h3_frame_unexpected,h3_frame_error,h3_excessive_load,h3_id_error,h3_settings_error,h3_missing_settings,h3_request_rejected,h3_request_cancelled,h3_request_incomplete,h3_message_error,h3_connect_error,h3_version_fallback,pack_decompression_failed,qpack_encoder_stream_error,qpack_decoder_stream_error,h2_headers_rcvd,h2_data_rcvd,h2_settings_rcvd,h2_rst_stream_rcvd,h2_goaway_rcvd,h2_detected_conn_protocol_errors,h2_detected_strm_protocol_errors,h2_rst_stream_resp,h2_goaway_resp,h2_open_connections,h2_backend_open_streams,h2_total_connections,h2_backend_total_streams,h1_open_connections,h1_open_streams,h1_total_connections,h1_total_streams,h1_bytes_in,h1_bytes_out,
http-in,FRONTEND,,,0,0,3000,0,0,0,0,0,0,,,,,OPEN,,,,,,,,,1,2,0,,,,0,0,0,0,,,,0,0,0,0,0,0,,0,0,0,,,0,0,0,0,,,,,,,,,,,,,,,,,,,,,http,,0,0,0,0,0,0,0,,,0,0,,,,,,,0,,,,,,,,,,0,0,0,0,0,0,0,0,,-,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
backend_servers,node01,0,0,0,0,,0,0,0,,0,,0,0,0,0,UP,1,1,0,0,0,126,0,,1,3,1,,0,,2,0,,0,L4OK,,0,0,0,0,0,0,0,,,,0,0,0,,,,,-1,,,0,0,0,0,,,,Layer4 check passed,,2,3,4,,,,10.0.0.51:80,,http,,,,,,,,0,0,0,,,0,,0,0,0,0,0,0,0,0,1,1,,,,0,,,,,,,,,,-,0,0,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
backend_servers,node02,0,0,0,0,,0,0,0,,0,,0,0,0,0,UP,1,1,0,0,0,126,0,,1,3,2,,0,,2,0,,0,L4OK,,0,0,0,0,0,0,0,,,,0,0,0,,,,,-1,,,0,0,0,0,,,,Layer4 check passed,,2,3,4,,,,10.0.0.52:80,,http,,,,,,,,0,0,0,,,0,,0,0,0,0,0,0,0,0,1,1,,,,0,,,,,,,,,,-,0,0,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
backend_servers,BACKEND,0,0,0,0,300,0,0,0,0,0,,0,0,0,0,UP,2,2,0,,0,126,0,,1,3,0,,0,,1,0,,0,,,,0,0,0,0,0,0,,,,0,0,0,0,0,0,0,-1,,,0,0,0,0,,,,,,,,,,,,,,http,roundrobin,,,,,,,0,0,0,0,0,,,0,0,0,0,0,,,,,2,0,0,0,,,,,,,,,,,-,0,0,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

# display current session
root@belajarfreebsd:~# echo "show sess" | socat /usr/local/haproxy/stats stdio
0x7fc94b3f500: proto=unix_stream src=unix:1 fe=GLOBAL be=<NONE> srv=<none> ts=00 epoch=0 age=0s calls=1 rate=0 cpu=0 lat=0 rq[f=808000h,i=0,an=00h,ax=] rp[f=80008000h,i=0,an=00h,ax=] scf=[8,400h,fd=13,rex=10s,wex=] scb=[8,1h,fd=-1,rex=,wex=] exp=10s rc=0 c_exp=
```