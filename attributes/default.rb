default['tomcat']['install_path'] = '/opt/tomcat8'
default['tomcat']['version'] = '8.5.13'
default['tomcat']['service_name'] = 'tomcat_8'
default['tomcat']['cors']['enabled'] = false
default['tomcat']['cors']['allowed_origins'] = "*"
default['tomcat']['cors']['allowed_methods'] = "GET,POST,HEAD,OPTIONS,PUT,PATCH"
default['tomcat']['cors']['allowed_headers'] = "Content-Type,X-Requested-With,accept,Origin,Access-Control-Request-Method,Access-Control-Request-Headers"
default['tomcat']['cors']['exposed_headers'] = "Access-Control-Allow-Origin,Access-Control-Allow-Credentials"
default['tomcat']['cors']['credentials'] = true
default['tomcat']['cors']['preflight_maxage'] = 10
default['tomcat']['http_to_https'] = false
default['tomcat']['request_dumper'] = false
default['tomcat']['user'] = 'tomcat'
default['tomcat']['group'] = 'tomcat'
default['tomcat']['loglevel'] = 'INFO'
default['tomcat']['http_port'] = 8080
default['tomcat']['https_max_threads'] = 150
default['tomcat']['https_port'] = 8443
default['tomcat']['ajp_port'] = 8009
default['tomcat']['ajp_redirect_port'] = nil
default['tomcat']['ajp_listen_ip'] = nil
default['tomcat']['ajp_packetsize'] = '8192'
default['tomcat']['https_protocols'] = nil
default['tomcat']['https_ciphers'] = nil
default['tomcat']['secure'] = nil
default['tomcat']['scheme'] = nil
default['tomcat']['uriencoding'] = 'UTF-8'
default['tomcat']['shutdown_port'] = 8005
default['tomcat']['max_threads'] = nil
default['tomcat']['keystore_file'] = 'keystore.jks'
default['tomcat']['keystore_type'] = 'jks'
default['tomcat']['keystore_alias'] = nil
default['tomcat']['tomcat_auth'] = true
default['tomcat']['client_auth'] = false
default['tomcat']['app_base'] = 'webapps'
default['tomcat']['jndi_connections'] = []
default['tomcat']['ldap_servers'] = []
default['tomcat']['ldap_port'] = 389
default['tomcat']['ldap_bind_user'] = nil
default['tomcat']['ldap_bind_pwd'] = nil
default['tomcat']['ldap_user_base'] = nil
default['tomcat']['ldap_role_base'] = nil
default['tomcat']['ldap_group'] = nil
default['tomcat']['ldap_domain_name'] = nil
default['tomcat']['ldap_user_search'] = "(sAMAccountName={0})"
default['tomcat']['ldap_role_search'] = "(member={0})"
default['tomcat']['access_log_pattern'] = 'common'
default['tomcat']['max_heap'] = "#{(node['memory']['total'].to_i * 0.6).floor / 1024}m"
default['tomcat']['java_opts'] = "-Djava.awt.headless=true -Xms256m -Xmx#{node['tomcat']['max_heap']} -XX:+UseParNewGC -XX:+UseConcMarkSweepGC"
default['tomcat']['exclude_manager_webapp'] = false
default['tomcat']['tarball_url'] = nil
default['tomcat']['verify_checksum'] = true
