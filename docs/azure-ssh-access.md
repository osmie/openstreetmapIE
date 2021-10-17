# Accessing Azure VMs

 - Install the [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   binaries on your device.

 - Login to your azure account

   ```bash
   az login
   ```

 - Install the ssh extension

   ```bash
   az extension add --name ssh
   ```

 - Access hosts using the following command:

   ```bash
   az ssh vm -g <resource group> -n <host>
   ```

   Example:
   ```bash
   az ssh vm -g www -n www-prod-01
   ```


# Troubleshooting

## azure-cli version

While configuring IAM in azure, we discovered that the version of `azure-cli`
varies based on source (debian repo has a version that is quite OLD).

You can verify the version with the following command:

```bash
az --version
```

Example from October 2021:
```bash
$ az --version
azure-cli                         2.29.0

core                              2.29.0
telemetry                          1.0.6

Extensions:
ssh                                0.1.8

Python location '/opt/az/bin/python3'
Extensions directory '/home/dhunt/.azure/cliextensions'

Python (Linux) 3.6.10 (default, Oct  8 2021, 09:26:51)
[GCC 10.2.1 20210110]

Legal docs and information: aka.ms/AzureCliLegal


Your CLI is up-to-date.

Please let us know how we are doing: https://aka.ms/azureclihats
and let us know if you're interested in trying out our newest features: https://aka.ms/CLIUXstudy
```
