resource_name 'directory_wrapper'
property :name, String

action :create do
  directory new_resource.name do
    action :create
  end
end

action :delete do
  raise "

    Directory deletion not allowed fella
    Totally bad karma if we allowed that

  "
end
