# chef_resource_acls

A thing to hook resources so only certain cookbooks can use them

The `hooky_wrapper` has a library that can whitelist cookbooks to use a resource
(example is the directory resource)

It also has a resource provider which wraps the directory resource and limits the actions
you can make on a directory.

The `directory_consumer` uses the `hooky_wrapper` cookbook to indirectly call the directory resource (which is allowed). It subsequently calls the directory resource directly (which is not allowed) which raises an exception.
