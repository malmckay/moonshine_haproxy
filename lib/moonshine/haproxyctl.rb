module Moonshine
  module Haproxyctl
    # Define options for this plugin via the <tt>configure</tt> method
    # in your application manifest:
    #
    #    configure(:haproxy => {:foo => true})
    #
    # Moonshine will autoload plugins, just call the recipe(s) you need in your
    # manifests:
    #
    #    recipe :haproxyctl
    def haproxyctl(options = {})
      # define the recipe
      # options specified with the configure method will be
      # automatically available here in the options hash.
      #    options[:foo]   # => true

      options = HashWithIndifferentAccess.new({
        :version => '0.2.0'
      }.merge(options))

      exec 'install haproxyctl',
       :command => [
         'git clone https://github.com/flores/haproxyctl.git',
         'ln -s /usr/local/src/haproxyctl/haproxyctl /etc/init.d/haproxyctl',
         ].join(' && '),
       :cwd => '/usr/local/src',
       :require => exec('install haproxy'),
       :unless => "test -f /etc/init.d/haproxyctl && test #{options[:version]} = `/etc/init.d/haproxyctl version | awk '{print $2}'`"

    end
    
  end
end
