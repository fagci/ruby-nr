SERVICES = {
  tcpmux: 1, # TCP port service multiplexer
  echo: 7, 
  discard: 9, # sink null
  systat: 11, # users
  daytime: 13, 
  netstat: 15, 
  qotd: 17, # quote
  msp: 18, # message send protocol
  chargen: 19, # ttytst source
  ftp_data: 20, 
  ftp: 21, 
  ssh: 22, # SSH Remote Login Protocol
  telnet: 23, 
  smtp: 25, # mail
  time: 37, # timserver
  nameserver: 42, # name		# IEN 116
  whois: 43, # nicname
  tacacs: 49, # Login Host Protocol (TACACS)
  re_mail_ck: 50, # Remote Mail Checking Protocol
  domain: 53, # name_domain server
  mtp: 57, # deprecated
  tacacs_ds: 65, # TACACS_Database Service
  bootps: 67, # BOOTP server
  bootpc: 68, # BOOTP client
  gopher: 70, # Internet Gopher
  rje: 77, # netrjs
  finger: 79, 
  www: 80, # http		# WorldWideWeb HTTP
  http: 80, # http		# WorldWideWeb HTTP
  link: 87, # ttylink
  kerberos: 88, # kerberos5 krb5 kerberos_sec	# Kerberos v5
  supdup: 95, 
  linuxconf: 98, # LinuxConf
  hostnames: 101, # hostname	# usually from sri_nic
  iso_tsap: 102, # tsap		# part of ISODE
  acr_nema: 104, # dicom		# Digital Imag. & Comm. 300
  csnet_ns: 105, # cso_ns		# also used by CSO name server
  poppassd: 106, # Eudora
  rtelnet: 107, # Remote Telnet
  pop2: 109, # postoffice pop_2 # POP version 2
  pop3: 110, # pop_3		# POP version 3
  sunrpc: 111, # portmapper	# RPC 4.0 portmapper
  auth: 113, # authentication tap ident
  sftp: 115, 
  uucp_path: 117, 
  nntp: 119, # readnews untp	# USENET News Transfer Protocol
  ntp: 123, 
  pwdgen: 129, # PWDGEN service
  loc_srv: 135, # epmap		# Location Service
  netbios_ns: 137, # NETBIOS Name Service
  netbios_dgm: 138, # NETBIOS Datagram Service
  netbios_ssn: 139, # NETBIOS session service
  imap2: 143, # imap		# Interim Mail Access P 2 and 4
  snmp: 161, # Simple Net Mgmt Protocol
  snmp_trap: 162, # snmptrap	# Traps for SNMP
  cmip_man: 163, # ISO mgmt over IP (CMOT)
  cmip_agent: 164, 
  mailq: 174, # Mailer transport queue for Zmailer
  xdmcp: 177, # X Display Mgr. Control Proto
  nextstep: 178, # NeXTStep NextStep	# NeXTStep window
  bgp: 179, # Border Gateway Protocol
  prospero: 191, # Cliff Neuman's Prospero
  irc: 194, # Internet Relay Chat
  smux: 199, # SNMP Unix Multiplexer
  at_rtmp: 201, # AppleTalk routing
  at_nbp: 202, # AppleTalk name binding
  at_echo: 204, # AppleTalk echo
  at_zis: 206, # AppleTalk zone information
  qmtp: 209, # Quick Mail Transfer Protocol
  z3950: 210, # wais		# NISO Z39.50 database
  ipx: 213, # IPX
  imap3: 220, # Interactive Mail Access
  pawserv: 345, # Perf Analysis Workbench
  zserv: 346, # Zebra server
  fatserv: 347, # Fatmen Server
  rpc2portmap: 369, 
  codaauth2: 370, 
  clearcase: 371, # Clearcase
  ulistserv: 372, # UNIX Listserv
  ldap: 389, # Lightweight Directory Access Protocol
  imsp: 406, # Interactive Mail Support Protocol
  svrloc: 427, # Server Location
  https: 443, # http protocol over TLS/SSL
  snpp: 444, # Simple Network Paging Protocol
  microsoft_ds: 445, # Microsoft Naked CIFS
  kpasswd: 464, 
  ssmtp: 465, # smtps		# SMTP over SSL
  saft: 487, # Simple Asynchronous File Transfer
  isakmp: 500, # IPsec _ Internet Security Association
  exec: 512, 
  login: 513, 
  shell: 514, # cmd		# no passwords used
  printer: 515, # spooler		# line printer spooler
  tempo: 526, # newdate
  courier: 530, # rpc
  conference: 531, # chat
  netnews: 532, # readnews
  gdomap: 538, # GNUstep distributed objects
  uucp: 540, # uucpd		# uucp daemon
  klogin: 543, # Kerberized `rlogin' (v5)
  kshell: 544, # krcmd		# Kerberized `rsh' (v5)
  dhcpv6_client: 546, 
  dhcpv6_server: 547, 
  afpovertcp: 548, # AFP over TCP
  idfp: 549, 
  rtsp: 554, # Real Time Stream Control Protocol
  remotefs: 556, # rfs_server rfs	# Brunhoff remote filesystem
  nntps: 563, # snntp		# NNTP over SSL
  submission: 587, # Submission [RFC4409]
  nqs: 607, # Network Queuing system
  npmp_local: 610, # dqs313_qmaster		# npmp_local / DQS
  npmp_gui: 611, # dqs313_execd		# npmp_gui / DQS
  hmmp_ind: 612, # dqs313_intercell	# HMMP Indication / DQS
  qmqp: 628, 
  ipp: 631, # Internet Printing Protocol
  ldaps: 636, # LDAP over SSL
  tinc: 655, # tinc control port
  silc: 706, 
  kerberos_adm: 749, # Kerberos `kadmin' (v5)
  kerberos4: 750, # kerberos_iv kdc
  kerberos_master: 751, 
  krb_prop: 754, # krb5_prop hprop	# Kerberos slave propagation
  krbupdate: 760, # kreg		# Kerberos registration
  webster: 765, # Network dictionary
  moira_db: 775, # Moira database
  moira_update: 777, # Moira update protocol
  spamd: 783, # spamassassin daemon
  omirr: 808, # omirrd		# online mirror
  supfilesrv: 871, # SUP server
  rsync: 873, 
  swat: 901, # swat
  ftps_data: 989, # FTP over SSL (data)
  ftps: 990, 
  telnets: 992, # Telnet over SSL
  imaps: 993, # IMAP over SSL
  ircs: 994, # IRC over SSL
  pop3s: 995, # POP_3 over SSL
  customs: 1001, # pmake customs server
  socks: 1080, # socks proxy server
  proofd: 1093, 
  rootd: 1094, 
  rmiregistry: 1099, # Java RMI Registry
  kpop: 1109, # Pop with Kerberos
  supfiledbg: 1127, # SUP debugging
  skkserv: 1178, # skk jisho server port
  openvpn: 1194, 
  kazaa: 1214, 
  rmtcfg: 1236, # Gracilis Packeten remote config server
  nessus: 1241, # Nessus vulnerability
  wipld: 1300, # Wipl network monitor
  xtel: 1313, # french minitel
  xtelw: 1314, # french minitel
  lotusnote: 1352, # lotusnotes	# Lotus Note
  ms_sql_s: 1433, # Microsoft SQL Server
  ms_sql_m: 1434, # Microsoft SQL Monitor
  ingreslock: 1524, 
  prospero_np: 1525, # Prospero non_privileged
  support: 1529, # GNATS
  datametrics: 1645, # old_radius
  sa_msg_port: 1646, # old_radacct
  kermit: 1649, 
  l2f: 1701, # l2tp
  radius: 1812, 
  radius_acct: 1813, # radacct		# Radius Accounting
  msnp: 1863, # MSN Messenger
  unix_status: 1957, # remstats unix_status server
  log_server: 1958, # remstats log server
  remoteping: 1959, # remstats remoteping server
  cisco_sccp: 2000, # Cisco SCCP
  cfinger: 2003, # GNU Finger
  pipe_server: 2010, 
  search: 2010, # ndtp
  nfs: 2049, # Network File System
  knetd: 2053, # Kerberos de_multiplexor
  gnunet: 2086, 
  rtcm_sc104: 2101, # RTCM SC_104 IANA 1/29/99
  eklogin: 2105, # Kerberos encrypted rlogin
  kx: 2111, # X over Kerberos
  gsigatekeeper: 2119, 
  frox: 2121, # frox: caching ftp proxy
  iprop: 2121, # incremental propagation
  gris: 2135, # Grid Resource Information Server
  ninstall: 2150, # ninstall service
  cvspserver: 2401, # CVS client/server operations
  venus: 2430, # codacon port
  venus_se: 2431, # tcp side effects
  codasrv: 2432, # not used
  codasrv_se: 2433, # tcp side effects
  mon: 2583, # MON traps
  zebrasrv: 2600, # zebra service
  zebra: 2601, # zebra vty
  ripd: 2602, # ripd vty (zebra)
  ripngd: 2603, # ripngd vty (zebra)
  ospfd: 2604, # ospfd vty (zebra)
  bgpd: 2605, # bgpd vty (zebra)
  ospf6d: 2606, # ospf6d vty (zebra)
  ospfapi: 2607, # OSPF_API
  isisd: 2608, # ISISd vty (zebra)
  dict: 2628, # Dictionary server
  gsiftp: 2811, 
  gpsd: 2947, 
  afbackup: 2988, # Afbackup system
  afmbackup: 2989, # Afmbackup system
  gds_db: 3050, # InterBase server
  icpv2: 3130, # icp		# Internet Cache Protocol
  mysql: 3306, 
  nut: 3493, # Network UPS Tools
  distcc: 3632, # distributed compiler
  daap: 3689, # Digital Audio Access Protocol
  svn: 3690, # subversion	# Subversion protocol
  suucp: 4031, # UUCP over SSL
  sysrqd: 4094, # sysrq daemon
  sieve: 4190, # ManageSieve Protocol
  xtell: 4224, # xtell server
  epmd: 4369, # Erlang Port Mapper Daemon
  remctl: 4373, # Remote Authenticated Command Service
  fax: 4557, # FAX transmission service (old)
  hylafax: 4559, # HylaFAX client_server protocol (new)
  iax: 4569, # Inter_Asterisk eXchange
  distmp3: 4600, # distmp3host daemon
  mtn: 4691, # monotone Netsync Protocol
  radmin_port: 4899, # RAdmin Port
  munin: 4949, # lrrd		# Munin
  rfe: 5002, 
  mmcc: 5050, # multimedia conference control tool (Yahoo IM)
  enbd_cstatd: 5051, # ENBD client statd
  enbd_sstatd: 5052, # ENBD server statd
  sip: 5060, # Session Initiation Protocol
  sip_tls: 5061, 
  pcrd: 5151, # PCR_1000 Daemon
  aol: 5190, # AIM
  xmpp_client: 5222, # jabber_client	# Jabber Client Connection
  xmpp_server: 5269, # jabber_server	# Jabber Server Connection
  cfengine: 5308, 
  mdns: 5353, # Multicast DNS
  noclog: 5354, # noclogd with TCP (nocol)
  hostmon: 5355, # hostmon uses TCP (nocol)
  postgresql: 5432, # postgres	# PostgreSQL Database
  freeciv: 5556, # rptp		# Freeciv gameplay
  nrpe: 5666, # Nagios Remote Plugin Executor
  nsca: 5667, # Nagios Agent _ NSCA
  amqp: 5672, 
  mrtd: 5674, # MRT Routing Daemon
  bgpsim: 5675, # MRT Routing Simulator
  canna: 5680, # cannaserver
  ggz: 5688, # GGZ Gaming Zone
  x11: 6000, # x11_0		# X Window System
  x11_1: 6001, 
  x11_2: 6002, 
  x11_3: 6003, 
  x11_4: 6004, 
  x11_5: 6005, 
  x11_6: 6006, 
  x11_7: 6007, 
  gnutella_svc: 6346, # gnutella
  gnutella_rtr: 6347, # gnutella
  sge_qmaster: 6444, # Grid Engine Qmaster Service
  sge_execd: 6445, # Grid Engine Execution Service
  mysql_proxy: 6446, # MySQL Proxy
  sane_port: 6566, # sane saned	# SANE network scanner daemon
  ircd: 6667, # Internet Relay Chat
  afs3_fileserver: 7000, # bbs		# file server itself
  afs3_callback: 7001, # callbacks to cache managers
  afs3_prserver: 7002, # users & groups database
  afs3_vlserver: 7003, # volume location database
  afs3_kaserver: 7004, # AFS/Kerberos authentication
  afs3_volser: 7005, # volume managment server
  afs3_errors: 7006, # error interpretation service
  afs3_bos: 7007, # basic overseer process
  afs3_update: 7008, # server_to_server updater
  afs3_rmtsys: 7009, # remote cache manager service
  font_service: 7100, # xfs		# X Font Service
  zope_ftp: 8021, # zope management by ftp
  http_alt: 8080, # webcache	# WWW caching service
  tproxy: 8081, # Transparent Proxy
  omniorb: 8088, # OmniORB
  clc_build_daemon: 8990, # Common lisp build daemon
  xinetd: 9098, 
  bacula_dir: 9101, # Bacula Director
  bacula_fd: 9102, # Bacula File Daemon
  bacula_sd: 9103, # Bacula Storage Daemon
  git: 9418, # Git Version Control System
  xmms2: 9667, # Cross_platform Music Multiplexing System
  zope: 9673, # zope server
  webmin: 10000, 
  zabbix_agent: 10050, # Zabbix Agent
  zabbix_trapper: 10051, # Zabbix Trapper
  amanda: 10080, # amanda backup services
  kamanda: 10081, # amanda backup services (Kerberos)
  amandaidx: 10082, # amanda backup services
  amidxtape: 10083, # amanda backup services
  nbd: 10809, # Linux Network Block Device
  smsqp: 11201, # Alamin SMS gateway
  hkp: 11371, # OpenPGP HTTP Keyserver
  bprd: 13720, # VERITAS NetBackup
  bpdbm: 13721, # VERITAS NetBackup
  bpjava_msvc: 13722, # BP Java MSVC Protocol
  vnetd: 13724, # Veritas Network Utility
  bpcd: 13782, # VERITAS NetBackup
  vopied: 13783, # VERITAS NetBackup
  xpilot: 15345, # XPilot Contact Port
  sgi_cad: 17004, # Cluster Admin daemon
  isdnlog: 20011, # isdn logging system
  vboxd: 20012, # voice box system
  dcap: 22125, # dCache Access Protocol
  gsidcap: 22128, # GSI dCache Access Protocol
  wnn6: 22273, # wnn6
  binkp: 24554, # binkp fidonet protocol
  asp: 27374, # Address Search Protocol
  csync2: 30865, # cluster synchronization tool
  dircproxy: 57000, # Detachable IRC Proxy
  tfido: 60177, # fidonet EMSI over telnet
  fido: 60179, # fidonet EMSI over TCP
}.freeze
