
node[:symfony2][:sites].each do |site|
  symfony2_site site[:site] do
      base_path site[:base_path]
      alternate_domains site[:alternate_domains]
      fastcgi_params site[:fastcgi_params]
      deploy_owner site[:deploy_owner]
      deploy_group site[:deploy_group]
      site_owner site[:site_owner]
      site_group site[:site_group]
  end
end
