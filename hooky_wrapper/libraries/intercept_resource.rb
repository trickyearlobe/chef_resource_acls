def wrap_method(klass, method_to_wrap, cookbook_whitelist)
  original_method = klass.instance_method(method_to_wrap)

  klass.define_method(method_to_wrap) do |*args|
    Chef::Log.debug "#{klass}(#{name}).#{method_to_wrap} called by :-"
    Chef::Log.debug "  Source:    #{@source_line}"
    Chef::Log.debug "  Cookbook:  #{cookbook_name}"
    Chef::Log.debug "  Recipe:    #{recipe_name}"
    Chef::Log.debug "  Resource:  #{resource_name}"
    Chef::Log.debug "  Whitelist: #{cookbook_whitelist}"

    found_cookbook = false
    cookbook_whitelist.each do |candidate|
      if (@source_line =~ /cookbooks\/#{candidate}\//) || cookbook_name.nil?
        found_cookbook = true
      end
    end

    unless found_cookbook
      raise "

        Dave: #{resource_name} '#{name}' do
                action #{action}
              end

        Hal:  I'm sorry, I can't do that Dave

        Dave: WTF Hal?

        Hal:  Why not use the wrapper instead of doing it in
              #{cookbook_name}::#{recipe_name}:#{source_line_number} ?
              Actual path was #{@source_line}

        Dave: Who is this rapper you speak of ?

        Hal:  No Dave... its a community wrapper COOKBOOK... for wrapping
              untrusted community cookbooks.

        Dave: Doh... right... Can I do it some other way ?

        Hal:  Nope, not unless you want to get ejected from the pod bay doors.

        Hal:  The list of cookbooks approved to use the '#{resource_name}' resource
              is #{cookbook_whitelist}

      "
    end
    original_method.bind(self).(*args)
  end

end

def lock_resource(klass = nil, cookbook_whitelist = [])
  klass.instance_methods(false).each do |method_to_wrap|
    wrap_method(klass, method_to_wrap, cookbook_whitelist)
  end
end

lock_resource(::Chef::Resource::Directory, ['hooky_wrapper','openssl'])
