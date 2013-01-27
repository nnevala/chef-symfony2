
define :symfony2_site,
  :capistrano_owner => "deploy",
  :capistrano_group => "deploy",
  :site_owner => "ubuntu",
  :site_group => "ubuntu" do

  include_recipe "nginx"
  include_recipe "php"
  include_recipe "php::module_apc"
  include_recipe "php::module_intl"
  include_recipe "php::module_pgsql"
  include_recipe "php::module_mysql"
  include_recipe "php-fpm"

  site = params[:name]
  base_path = "#{params[:base_path]}/#{site}"

  [ "#{base_path}",
    "#{base_path}/releases",
    "#{base_path}/shared",
    "#{base_path}/shared/app",
    "#{base_path}/shared/app/logs",
    "#{base_path}/shared/app/cache" ].each do |path|
    directory path do
      owner params[:capistrano_owner]
      group params[:capistrano_group]
      mode "0775"
      action :create
      recursive true
    end
  end

  template "/etc/nginx/sites-available/#{site}" do
      source "site.erb"
      mode "0644"
      owner params[:site_owner]
      group params[:site_group]
      variables({
          :document_root => "#{site}/current/web",
          :server_name => site,
          :alternate_domains => Array(params[:alternate_domains]),
          :fastcgi_params => Array(params[:fastcgi_params])
      })
      notifies :restart, "service[nginx]"
  end

  # Nasty hack. As far as I can tell, PHP cookbok only allows
  # you to define only one ini file for file for one SAPI, cli
  # by default, so just symlinking to that here.
  link "/etc/php5/fpm/php.ini" do
    to "/etc/php5/cli/php.ini"
    notifies :restart, "service[nginx]"
    notifies :restart, "service[php5-fpm]"
  end

  nginx_site node['fqdn'] do
    enable true
    notifies :restart, "service[nginx]"
  end
end
