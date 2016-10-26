#
# Cookbook Name:: tomcat-config
# Recipe:: default
#
# Copyright 2016, Boundless
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java'
include_recipe 'chef-vault'

keystore_password = chef_vault_item("certs", "java_keystore")['password'] if node['tomcat']['https_port']

tomcat_install 'tomcat8' do
  version node['tomcat']['version']
  tomcat_user node['tomcat']['user']
  tomcat_group node['tomcat']['group']
  install_path node['tomcat']['install_path']
  exclude_manager node['tomcat']['exclude_manager_webapp']
  exclude_hostmanager node['tomcat']['exclude_manager_webapp']
end

tomcat_service '8' do
  action [:start, :enable]
  sensitive true
  tomcat_user node['tomcat']['user']
  tomcat_group node['tomcat']['group']
  install_path node['tomcat']['install_path']
  env_vars [
    { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' },
    { 'JAVA_OPTS' => node['tomcat']['java_opts'] }
  ]
  service_vars [
    { 'LimitNOFILE' => '65535' }
  ]
end

service node['tomcat']['service_name'] do
  action :nothing
end

template "#{node['tomcat']['install_path']}/conf/server.xml" do
  source 'server.xml.erb'
  owner node['tomcat']['user']
  group node['tomcat']['group']
  sensitive true
  mode 0644
  notifies :restart, "service[#{node['tomcat']['service_name']}]"
  variables(
    http_port: node['tomcat']['http_port'],
    secure: node['tomcat']['secure'],
    scheme: node['tomcat']['scheme'],
    uriencoding: node['tomcat']['uriencoding'],
    ajp_port: node['tomcat']['ajp_port'],
    ajp_redirect_port: node['tomcat']['ajp_redirect_port'],
    ajp_listen_ip: node['tomcat']['ajp_listen_ip'],
    ajp_packetsize: node['tomcat']['ajp_packetsize'],
    shutdown_port: node['tomcat']['shutdown_port'],
    max_threads: node['tomcat']['max_threads'],
    https_port: node['tomcat']['https_port'],
    https_max_threads: node['tomcat']['https_max_threads'],
    https_protocols: node['tomcat']['https_protocols'],
    https_ciphers: node['tomcat']['https_ciphers'],
    keystore_file: node['tomcat']['keystore_file'],
    keystore_password: keystore_password,
    truststore_password: keystore_password,
    keystore_type: node['tomcat']['keystore_type'],
    keystore_alias: node['tomcat']['keystore_alias'],
    tomcat_auth: node['tomcat']['tomcat_auth'],
    client_auth: node['tomcat']['client_auth'],
    app_base: node['tomcat']['app_base'],
    ldap_servers: node['tomcat']['ldap_servers'],
    ldap_port: node['tomcat']['ldap_port'],
    ldap_bind_user: node['tomcat']['ldap_bind_user'],
    ldap_bind_pwd: node['tomcat']['ldap_bind_pwd'],
    ldap_user_base: node['tomcat']['ldap_user_base'],
    ldap_role_base: node['tomcat']['ldap_role_base'],
    ldap_domain_name: node['tomcat']['ldap_domain_name'],
    ldap_group: node['tomcat']['ldap_group'],
    ldap_user_search: node['tomcat']['ldap_user_search'],
    ldap_role_search: node['tomcat']['ldap_role_search'],
    access_log_pattern: node['tomcat']['access_log_pattern']
  )
end

template "#{node['tomcat']['install_path']}/conf/web.xml" do
  source 'web.xml.erb'
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode 0644
  notifies :restart, "service[#{node['tomcat']['service_name']}]"
  variables(
    cors: node['tomcat']['cors']['enabled'],
    allowed_origins: node['tomcat']['cors']['allowed_origins'],
    allowed_methods: node['tomcat']['cors']['allowed_methods'],
    allowed_headers: node['tomcat']['cors']['allowed_headers'],
    exposed_headers: node['tomcat']['cors']['exposed_headers'],
    credentials: node['tomcat']['cors']['credentials'],
    preflight_maxage: node['tomcat']['cors']['preflight_maxage'],
    http_to_https: node['tomcat']['http_to_https'],
    request_dumper: node['tomcat']['request_dumper']
  )
end

directory "/var/log/tomcat8" do
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode 0755
end

directory "#{node['tomcat']['install_path']}/logs" do
  action :delete
  recursive true
  not_if "test -L #{node['tomcat']['install_path']}/logs"
end

link "#{node['tomcat']['install_path']}/logs" do
  to "/var/log/tomcat8"
end

template "/etc/logrotate.d/tomcat8" do
  source "logrotate.erb"
  mode 0644
  variables(
    log_dir: "/var/log/tomcat8"
  )
end

template "#{node['tomcat']['install_path']}/conf/logging.properties" do
  source "logging.properties.erb"
  owner node['tomcat']['user']
  group node['tomcat']['group']
  notifies :restart, "service[#{node['tomcat']['service_name']}]"
  mode 0644
  variables(
    log_level: node['tomcat']['loglevel']
  )
end

unless node['tomcat']['exclude_manager_webapp']
  tomcat_vault = chef_vault_item("tomcat", "admin_manager")
  template "#{node['tomcat']['install_path']}/conf/tomcat-users.xml" do
    source "tomcat-users.xml.erb"
    mode 0644
    owner node['tomcat']['user']
    group node['tomcat']['group']
    notifies :restart, "service[#{node['tomcat']['service_name']}]"
    variables(
      roles: ['manager-gui'],
      users: [ 
        {'name' => tomcat_vault['username'],  'password' => tomcat_vault['password'], 'roles' => ['manager-gui', 'manager', 'manager-script']}   
      ]
    )
  end

  cookbook_file "#{node['tomcat']['install_path']}/conf/Catalina/localhost/manager.xml" do
    source 'manager.xml'
    sensitive true
    mode 0644
    owner node['tomcat']['user']
    group node['tomcat']['group']
    notifies :restart, "service[#{node['tomcat']['service_name']}]"
  end
end

template "#{node['tomcat']['install_path']}/conf/context.xml" do
  source "context.xml.erb"
  mode 0644
  owner node['tomcat']['user']
  group node['tomcat']['group']
  notifies :restart, "service[#{node['tomcat']['service_name']}]"
  variables(
    jndi_connections: node['tomcat']['jndi_connections']
  )
end
