{{/*
Expand the name of the chart.
*/}}
{{- define "crusoe-support-roles.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "crusoe-support-roles.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "crusoe-support-roles.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "crusoe-support-roles.labels" -}}
helm.sh/chart: {{ include "crusoe-support-roles.chart" . }}
{{ include "crusoe-support-roles.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "crusoe-support-roles.selectorLabels" -}}
app.kubernetes.io/name: {{ include "crusoe-support-roles.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Readonly RBAC rules - shared between readonly and operator roles
*/}}
{{- define "crusoe-support-roles.readonlyRules" -}}
# Core resources - read only
- apiGroups: [""]
  resources:
    - pods
    - services
    - endpoints
    - configmaps
    - persistentvolumeclaims
    - persistentvolumes
    - nodes
    - namespaces
    - events
    - serviceaccounts
    - resourcequotas
    - limitranges
  verbs: ["get", "list", "watch"]
# Apps - read only
- apiGroups: ["apps"]
  resources:
    - deployments
    - daemonsets
    - statefulsets
    - replicasets
  verbs: ["get", "list", "watch"]
# Batch - read only
- apiGroups: ["batch"]
  resources:
    - jobs
    - cronjobs
  verbs: ["get", "list", "watch"]
# Networking - read only
- apiGroups: ["networking.k8s.io"]
  resources:
    - networkpolicies
  verbs: ["get", "list", "watch"]
# Discovery - read only
- apiGroups: ["discovery.k8s.io"]
  resources:
    - endpointslices
  verbs: ["get", "list", "watch"]
# Policy - read only
- apiGroups: ["policy"]
  resources:
    - poddisruptionbudgets
  verbs: ["get", "list", "watch"]
# Storage - read only
- apiGroups: ["storage.k8s.io"]
  resources:
    - storageclasses
    - volumeattachments
  verbs: ["get", "list", "watch"]
# RBAC - read only (for debugging auth issues)
- apiGroups: ["rbac.authorization.k8s.io"]
  resources:
    - roles
    - rolebindings
    - clusterroles
    - clusterrolebindings
  verbs: ["get", "list", "watch"]
# NVIDIA GPU Operator CRDs - read only
- apiGroups: ["nvidia.com"]
  resources:
    - clusterpolicies
    - nvidiadrivers
    - computedomains
  verbs: ["get", "list", "watch"]
# NVIDIA Network Operator CRDs - read only
- apiGroups: ["mellanox.com"]
  resources:
    - hostdevicenetworks
    - nicclusterpolicies
  verbs: ["get", "list", "watch"]
# AMD GPU/Network Operator CRDs - read only
- apiGroups: ["amd.com"]
  resources:
    - deviceconfigs
    - networkconfigs
    - remediationworkflowstatuses
  verbs: ["get", "list", "watch"]
# Multus CNI CRDs - read only
- apiGroups: ["k8s.cni.cncf.io"]
  resources:
    - network-attachment-definitions
  verbs: ["get", "list", "watch"]
# Cilium CRDs - read only
- apiGroups: ["cilium.io"]
  resources:
    # Network Policy & Traffic Management
    - ciliumnetworkpolicies
    - ciliumclusterwidenetworkpolicies
    - ciliumlocalredirectpolicies
    - ciliumenvoyconfigs
    - ciliumclusterwideenvoyconfigs
    # Endpoint & Identity Management
    - ciliumendpoints
    - ciliumendpointslices
    - ciliumidentities
    - ciliumnodes
    - ciliumexternalworkloads
    # Load Balancing & IP Management
    - ciliumloadbalancerippools
    - ciliumpodippools
    - ciliumcidrgroups
    # Gateway & Configuration
    - ciliumgatewayclassconfigs
    - ciliuml2announcementpolicies
    - ciliumnodeconfigs
  verbs: ["get", "list", "watch"]
{{- end }}
