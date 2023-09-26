# Proxy Forge

Proxy Forge is a free and open-source tool that helps you to set up OSI level 4 proxies with rotating IPs on the Digital Ocean platform. It is a powerful and innovative solution that addresses one of the most pressing challenges faced by developers and businesses in today's digital landscape: IP throttling and blacklisting. Proxy Forge empowers you to conquer these obstacles by providing a seamless, reliable, and easy-to-deploy solution.

In simpler terms, Proxy Forge helps you to create a pool of rotating IP addresses that you can use to access the internet. This can be useful for a variety of purposes, such as avoiding IP bans, scraping websites, and testing web applications.

Proxy Forge is a powerful tool that can be used by both developers and businesses. It is easy to use and deploy, and it provides a number of features that make it a valuable tool for anyone who needs to access the internet anonymously or avoid IP bans.

## Features

- **Rotating IPs:** Automatically rotates IP addresses from a set of deployed droplets to avoid detection and blacklisting.
- **Terraform Scripts:** Provides Terraform scripts for straightforward setup and management.
- **Scalability:** Easily scale your proxy fleet up or down to handle your specific needs.
- **Customizable Configuration:** Fine-tune proxy settings to match your requirements. (check [below](#customizations))
- **IP Throttling Avoidance:** Effectively bypass IP throttling mechanisms used by websites and services.
- **Detailed Logging:** Comprehensive logging for monitoring and troubleshooting.
- **Open Source:** Proxy Forge is open-source, allowing for community contributions and customization.

## Why DigitalOcean?

There are many reasons why you might choose to use DigitalOcean over other cloud providers. Some of the key benefits include:

- **Simplicity:** DigitalOcean is known for its simple and user-friendly interface. It is easy to get started with DigitalOcean, even if you are new to cloud computing.
- **Affordability:** DigitalOcean offers competitive pricing for its cloud services. It also offers a generous free tier that includes 1 Droplet, 25 GB of storage, and 2 TB of bandwidth per month.
- **Performance:** DigitalOcean uses high-performance hardware for its Droplets, so you can be sure that your applications will run smoothly.
- **Reliability:** DigitalOcean has a strong track record of reliability and uptime.
- **Community:** DigitalOcean has a large and active community of users and developers. This means that there is a wealth of resources available to help you get the most out of your DigitalOcean account.

## Up and Running

### Prerequisites

Before using Proxy Forge, ensure you have the following prerequisites in place:

1. [Digital Ocean Account](https://www.digitalocean.com/?refcode=a7587e994b7e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge): If you do not have an account, I would recommend creating it through my referral to get **200 USD credits for 60 days**. In this time you can test this solution.

2. [Terraform](https://docs.digitalocean.com/reference/terraform/getting-started/) installed on your local machine

### Steps

1.  Clone the repository

    ```console
    git clone --depth=1 --branch=main https://github.com/tbhaxor/ProxyForge.git proxyforge
    cd proxyforge
    ```

2.  Create a file for terraform variables.

    ```console
    touch terraform.tfvars
    ```

    > **Note** Skip it, if you wish to provide the variables and values from [environment config](https://developer.hashicorp.com/terraform/cli/config/environment-variables#tf_var_name).

3.  Setup at least `token` and `region` in the file. See [variables](#variables) section below.

4.  Initialize the provider, plan and apply the changes

    ```console
    terraform init
    terraform plan
    terraform apply
    ```

5.  Wait for some time for squid proxy to setup and load balancer to initialize routing.
6.  (Optional) Test the deployment

    ```sh
    LOAD_BALANCER_IP=$(terraform output -raw lb-ip)
    SQUID_USERNAME=proxyforge # assuming you did not change squid-credentials.username in the tfvars
    SQUID_PASSWORD=proxyforge # assuming you did not change squid-credentials.password in the tfvars

    while true; do curl -x "http://proxyforge:proxyforge@$LOAD_BALANCER_IP:80" https://ifconfig.me; echo; done
    ```

### Variables

|    Variable Name    |                        Default                         | Description                                                                                                                                                                                                                                                                                                                             |
| :-----------------: | :----------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|       `token`       |                          N/A                           | **Required** API token with read/write permissions. [see more](https://docs.digitalocean.com/reference/api/create-personal-access-token/)                                                                                                                                                                                               |
|      `region`       |                          N/A                           | **Required** Datacenter region to deploy all the resources. [see more](https://docs.digitalocean.com/products/platform/availability-matrix/)                                                                                                                                                                                            |
|  `ssh-fingerprint`  |                        _`null`_                        | SSH fingerprint id for droplets to use. If this is ommited, it will send you one-time-password on the email. Can be obtained from [security tab](https://i.imgur.com/TNTj7D8.png) of [accounts](https://cloud.digitalocean.com/account/security) page. [see also](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/) |
|      `prefix`       |                          _pf_                          | A prefix to quickly identify proxy-forge resources.                                                                                                                                                                                                                                                                                     |
|    `slave-count`    |                          _2_                           | Number of instances on which squid proxy will be installed.                                                                                                                                                                                                                                                                             |
|     `lb-count`      |                          _1_                           | Number of master nodes to setup for load balancer, min `1` is required.                                                                                                                                                                                                                                                                 |
|     `tag-name`      |                  _proxy-forge-slave_                   | Tag name to group slave droplets.                                                                                                                                                                                                                                                                                                       |
|   `droplet-size`    |            _{ slave = "s-1vcpu-1gb-amd" }_             | Droplet size to use.                                                                                                                                                                                                                                                                                                                    |
|      `project`      |                     _Proxy Forge_                      | Name of the project to associate all the resources.                                                                                                                                                                                                                                                                                     |
| `squid-credentials` | _{ password = "proxyforge", username = "proxyforge" }_ | Squid proxy HTTP basic authentication.credentials                                                                                                                                                                                                                                                                                       |

## Customizations

Configuring ProxyForge to suit your specific needs is a straightforward process. All you need to do is update the settings in the `terraform.tfvars` file to align with your requirements. This file serves as a central configuration hub, allowing you to tailor ProxyForge precisely to your preferences without diving deep into complex setup procedures.

> **Note** After you choose to make any changes from below, make sure to apply it on digitalocean
>
> ```console
> terraform plan
> terraform apply
> ```

### Change the Squid Credentials

```hcl
squid-credentials = {
    username = "YOUR NEW USERNAME",
    password = "Y0ur53cr37P@55W0rD"
}
```

### Increase or Decrease Proxy Droplets

```hcl
slave-count = 5
```

## Future Plans

- Add a user friendly dashboard for administration of squid accounts
- Make a master service to destroy and spin-up new droplet in same region
- Multiple regions support

## License

Proxy Forge is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

## Contact Me

Thank you for choosing Proxy Forge! I hope this tool helps you overcome IP throttling and blacklisting challenges, making your web-related tasks smoother and more efficient. If you have any questions or encounter issues, feel free to reach out to me. Happy proxying!

Website: https://tbhaxor.com <br />
Email Address: tbhaxor `at` gmail `dot` com <br />
LinkedIn: @tbhaxor <br />
Twitter: @tbhaxor <br />
Discord: @tbhaxor.com <br />
Reddit: @tbhaxor <br />
