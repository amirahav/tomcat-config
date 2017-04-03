module TomcatConfig
  module Helper
    def el6?
      case node['platform']
      when "amazon"
        true if %w{2013 2014 2015 2016}.include?(node['platform_version'].to_i)
      when "centos", "redhat"
        true if node['platform_version'].to_i == 6
      else
        false
      end
    end

    def el7?
      case node['platform']
      when "centos", "redhat"
        true if node['platform_version'].to_i == 7
      else
        false
      end
    end
  end
end

Chef::Node.send(:include, TomcatConfig::Helper)
Chef::Recipe.send(:include, TomcatConfig::Helper)
Chef::Resource.send(:include, TomcatConfig::Helper)
Chef::Provider.send(:include, TomcatConfig::Helper)
