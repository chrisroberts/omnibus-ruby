
# make solaris produce less rageface

return unless node['platform'] == "solaris2"

ENV['PATH'] = "/opt/csw/bin:/usr/local/bin:/usr/sfw/bin:/usr/ccs/bin:/usr/sbin:/usr/bin"

node.normal['omnibus']['build-user'] = 'jenkins'

%w{/usr/local /usr/local/bin}.each do |dir|
  directory dir do
    owner  "root"
    group  "sys"
    mode   "0755"
    action :create
  end
end

template "/etc/default/login" do
  source "default.login"
  user   "root"
  group  "sys"
  mode   "0444"
end

template "/etc/default/su" do
  source "default.su"
  user   "root"
  group  "sys"
  mode   "0444"
end

include_recipe "opencsw"

%w{gcc3core gcc3g++}.each do |pkg|
  opencsw pkg
end

%w{gmake ggrep coreutils gtar}.each do |pkg|
  opencsw pkg
end

link "/opt/csw/bin/make" do
  to "/opt/csw/bin/gmake"
end
link "/opt/csw/bin/tar" do
  to "/opt/csw/bin/gtar"
end
link "/opt/csw/bin/install" do
  to "/opt/csw/bin/ginstall"
end
link "/opt/csw/bin/grep" do
  to "/opt/csw/bin/ggrep"
end
link "/opt/csw/bin/egrep" do
  to "/opt/csw/bin/gegrep"
end
link "/opt/csw/bin/fgrep" do
  to "/opt/csw/bin/gfgrep"
end

template "/.profile" do
  source "root-profile"
  owner "root"
  group "root"
  mode "0600"
end

