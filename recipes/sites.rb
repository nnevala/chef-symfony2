
node[:symfony2][:sites].each do |site|
  symfony2_site site[:site] do
      base_path site[:base_path]
      alternate_domains site[:alternate_domains]
      fastcgi_params site[:fastcgi_params]
  end
end
