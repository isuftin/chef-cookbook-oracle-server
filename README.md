# OWI Oracle Server Cookbook

This cookbook is used to set up an Oracle database server on a CentOS 6.x machine

## Requirements

The Oracle server installation file from Oracle. This is not freely available and is not made available with this cookbook. The testing was done on a VM with 6G of RAM and 60GB HD. For specific requirements, check [the Oracle documentation](https://docs.oracle.com/database/121/LADBI/pre_install.htm#LADBI7533)

### Platforms

- CentOS 6.x

### Chef

- Chef 12.0 or later

### Cookbooks

- Required
-- sysctl

- Optional
-- Stig

## Attributes

`["owi-oracle-server"]["config"]["data_bag"]["name"]` = The name of the encrypted databag which holds the admin password

`["owi-oracle-server"]["config"]["data_bag"]["item"]["credentials"]` = The name of the data bag item holding the admin password 

`["owi-oracle-server"]["config"]["oracle_user"]` = Service user account created on the system (Default: oracle)

`["owi-oracle-server"]["config"]["oracle_group"]` = Service user account group created on the system (Default: oinstall)

`["owi-oracle-server"]["config"]["oracle_sid"]` = Database SID to create (Default: admin)

`["owi-oracle-server"]["config"]["oracle_home"]` = Home directory of the service account (Default: /u01/oradata/auto/app/oracle/product/12.1.0/dbhome_1)

`["owi-oracle-server"]["config"]["oracle_base"]` = Application directory, typically in the home directory of the service account (Default: /u01/oradata/auto)

`["owi-oracle-server"]["config"]["db_domain"]` = In a distributed database system, DB_DOMAIN specifies the logical location of the database within the network structure. [Read here](https://docs.oracle.com/cd/B19306_01/server.102/b14237/initparams046.htm#REFRN10036). If no value is set, this will be set dynamically. On a standalone server, this probably does not need to be set. (Default: None.)

`["owi-oracle-server"]["config"]["memory_target"]` = Configuration option. Read [more info here](https://docs.oracle.com/cd/B28359_01/server.111/b28310/memory003.htm) (Default: 2G)

`["owi-oracle-server"]["config"]["install_location"]` = Source location of the installation file zip (Default: file:///tmp/kitchen/data/install.zip - This is where Test Kitchen places it)

## Usage

### owi-oracle-server::default

Just include `owi-oracle-server` in your node"s `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[owi-oracle-server]"
  ]
}
```

You will also want to add sysctl-specific settings in your attributes. This is required by the Oracle installation and is managed by the third-party sysctl cookbook:

```json
{
      "sysctl" : {
        "params" : {
          "net.core.wmem_max" : "1048576",
          "net.core.wmem_default" : "262144",
          "net.core.rmem_max" : "4194304",
          "net.core.rmem_default" : "262144",
          "net.ipv4.ip_local_port_range" : "9000 65535",
          "fs.filemax" : "6815744",
          "fs.aio-max-nr" : "1048576",
          "kernel.semmsl" : "250",
          "kernel.semmns" : "32000",
          "kernel.semopm" : "100",
          "kernel.semmni" : "128",
          "kernel.shmmni" : "4096",
          "kernel.panic_on_oops" : "1"
        }
      }
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

