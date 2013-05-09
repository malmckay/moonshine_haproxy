module Moonshine
  module HaproxyTop
    # Define options for this plugin via the <tt>configure</tt> method
    # in your application manifest:
    #
    #    configure(:haproxy => {:foo => true})
    #
    # Moonshine will autoload plugins, just call the recipe(s) you need in your
    # manifests:
    #
    #    recipe :haproxy_top
    def haproxy_top(options = {})
      # define the recipe
      # options specified with the configure method will be
      # automatically available here in the options hash.
      #    options[:foo]   # => true

      options = HashWithIndifferentAccess.new({
        :version => '1.4.15'
      }.merge(options))

      exec 'install hatop',
       :command => [
         "wget http://hatop.googlecode.com/files/hatop-#{options[:version]}.tar.gz -O hatop-#{options[:version]}.tar.gz",
         'tar xzf hatop-0.7.7.tar.gz',
         "cd hatop-#{options[:version]}",
         'install -m 755 bin/hatop /usr/local/bin',
         'install -m 644 man/hatop.1 /usr/local/share/man/man1',
         'gzip /usr/local/share/man/man1/hatop.1',
         ].join(' && '),
       :cwd => '/usr/local/src',
       :require => package('haproxy'),
       :unless => "test -f /usr/local/bin/hatop && test #{options[:version]} = `/usr/local/bin/hatop --version | awk '{print $3}'`"

    end
    
  end
end
