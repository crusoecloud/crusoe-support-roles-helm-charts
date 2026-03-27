# Crusoe Support Roles Helm Chart

A Helm chart for managing Kubernetes RBAC ClusterRoles and ClusterRoleBindings in Crusoe environments.

## Overview

This Helm chart simplifies the creation and management of cluster-wide RBAC roles and role bindings for support teams, providing fine-grained access control across the entire cluster.

### Built-in ClusterRoles

This chart creates four predefined ClusterRoles:

- **crusoe-support-readonly**: Comprehensive read-only access to cluster resources including:
  - Core resources: pods, services, deployments, nodes, storage, networking, RBAC
  - Includes CRDs: NVIDIA GPU Operator (ClusterPolicies, NvidiaDrivers), NVIDIA Network Operator (NICClusterPolicies, HostDeviceNetworks), AMD GPU and Network Operators, Cilium CNI, Multus CNI
  - Does not include pod log access.
- **crusoe-support-operator**: Includes all readonly permissions plus operational capabilities such as:
  - Delete pods (for stuck pods)
  - Cordon/uncordon nodes
  - Create pod evictions (for drain operations)
  - Scale and trigger rollouts for deployments, statefulsets, and daemonsets
  - Modify GPU/Network operator CRDs (ClusterPolicies, NvidiaDrivers, NICClusterPolicies, HostDeviceNetworks, NetworkAttachmentDefinitions)
- **crusoe-support-logs**: Limited to pod and pod log read access. Designed to be bound at the namespace level for granular log access control.
- **crusoe-support-debug**: Pod debugging capabilities designed to be bound at the namespace level for granular control:
  - Exec into pods and port-forward (for debugging)

## Installation

### Add the Helm repository

```bash
helm repo add crusoe-support-roles <repository-url>
helm repo update
```

### Install the chart

```bash
helm install my-support-roles crusoe-support-roles/crusoe-support-roles
```

### Install with custom values

```bash
helm install my-support-roles crusoe-support-roles/crusoe-support-roles -f custom-values.yaml
```

## Configuration

### Basic Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `roleBindings.enabled` | Enable cluster role bindings creation | `true` |
| `roleBindings.bindings` | List of cluster role bindings to create | See values.yaml |
| `namespaceRoleBindings.enabled` | Enable namespace-scoped role bindings creation | `true` |
| `namespaceRoleBindings.bindings` | List of namespace-scoped role bindings to create | See values.yaml |
| `commonLabels` | Labels to apply to all resources | `{}` |
| `commonAnnotations` | Annotations to apply to all resources | `{}` |

### Example Custom Values

#### Cluster-wide Access

Create ClusterRoleBindings to grant users or groups cluster-wide access:

```yaml
roleBindings:
  enabled: true
  bindings:
    - roleName: crusoe-support-readonly
      subjects:
        - kind: Group
          name: crusoe:support:readonly
          apiGroup: rbac.authorization.k8s.io
    - roleName: crusoe-support-operator
      subjects:
        - kind: Group
          name: crusoe:support:operator
          apiGroup: rbac.authorization.k8s.io
```

#### Namespace-scoped Access

Create namespace-scoped RoleBindings for granular control:

```yaml
namespaceRoleBindings:
  enabled: true
  bindings:
    # Bind logs role to system namespaces
    - roleName: crusoe-support-logs
      namespaces:
        - crusoe-system
        - kube-system
        - nvidia-gpu-operator
        # ... (see values.yaml for full list)
      subjects:
        - kind: Group
          name: crusoe:support:readonly
          apiGroup: rbac.authorization.k8s.io
        - kind: Group
          name: crusoe:support:operator
          apiGroup: rbac.authorization.k8s.io
    # Bind debug role to system namespaces
    - roleName: crusoe-support-debug
      namespaces:
        - crusoe-system
        - kube-system
        - nvidia-gpu-operator
        # ... (see values.yaml for full list)
      subjects:
        - kind: Group
          name: crusoe:support:operator
          apiGroup: rbac.authorization.k8s.io
```

## Usage

### Viewing Created ClusterRoles

```bash
kubectl get clusterroles -l app.kubernetes.io/instance=my-support-roles
```

### Viewing ClusterRoleBindings

```bash
kubectl get clusterrolebindings -l app.kubernetes.io/instance=my-support-roles
```

### Viewing Namespace-scoped RoleBindings

```bash
kubectl get rolebindings -A -l app.kubernetes.io/instance=my-support-roles
```

### Updating the Chart

```bash
helm upgrade my-support-roles crusoe-support-roles/crusoe-support-roles -f custom-values.yaml
```

### Uninstalling the Chart

```bash
helm uninstall my-support-roles
```

## Development

### Testing the Chart Locally

```bash
# Lint the chart
helm lint .

# Template the chart to see the rendered manifests
helm template my-support-roles . -f values.yaml

# Install from local directory
helm install my-support-roles . --dry-run --debug
```

### Packaging the Chart

```bash
helm package .
```

## License

Copyright Crusoe Energy Systems
