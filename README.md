## Crusoe Managed Kubernetes Support Roles Helm Charts

This repository defines the official Crusoe Managed Kubernetes Support Roles Helm Charts for use with [Crusoe Cloud](https://crusoecloud.com/).

## Support

**The Crusoe Support Roles are intended to enable support access to Crusoe Managed Kubernetes (CMK) clusters.** 
This guide assumes that the user has already set up CMK on Crusoe Cloud.


## Changelog

Please refer to the [CHANGELOG](CHANGELOG.md) for breaking changes and upgrade instructions.


## Security

To report a security vulnerability, please follow the process described in our [security policy](SECURITY.md).


## Installation


To install the Crusoe Support Roles chart in the `crusoe-system` namespace:

    helm install <chart alias> <repo alias>/crusoe-support-roles -n crusoe-system

To uninstall the chart, which will disable access from Crusoe operators:

    helm delete <chart alias>


## Usage

This chart will be installed as part of a normal CMK cluster install going forward. For any cluster created
before it was available, please install this chart to enable the Crusoe support team to access your cluster.