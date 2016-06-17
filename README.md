# OWI Oracle Server Cookbook

This cookbook is used to set up an Oracle database server on a CentOS 6.x machine

## Requirements



### Platforms

- CentOS 6.x

### Chef

- Chef 12.0 or later

### Cookbooks


## Attributes

`['owi-oracle-server']['config']['data_bag']['name']` = The name of the encrypted databag which holds the admin password
`['owi-oracle-server']['config']['data_bag']['item']['credentials']` = The name of the data bag item holding the admin password 
`['owi-oracle-server']['config']['oracle_user']` = Service user account created on the system 
`['owi-oracle-server']['config']['oracle_group']` = Service user account group created on the system
`['owi-oracle-server']['config']['oracle_sid']` = Database SID to create
`['owi-oracle-server']['config']['oracle_home']` = Home directory of the service account
`['owi-oracle-server']['config']['oracle_base']` = Application directory, typically in the home directory of the service account
`['owi-oracle-server']['config']['db_domain']` = ?
`['owi-oracle-server']['config']['memory_target']` = Configuration option
`['owi-oracle-server']['config']['install_location']` = Source location of the installation file zip

## Usage

### owi-oracle-server::default

Just include `owi-oracle-server` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[owi-oracle-server]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

License: Public Domain

Authors: Ivan Suftin <isuftin@usgs.gov>

