{{/*
Expand the name of the chart.
*/}}
{{- define "plaid-quickstart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "plaid-quickstart.fullname" -}}
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
{{- define "plaid-quickstart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "plaid-quickstart.labels" -}}
helm.sh/chart: {{ include "plaid-quickstart.chart" . }}
{{ include "plaid-quickstart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "plaid-quickstart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "plaid-quickstart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "plaid-quickstart.serviceAccountName" -}}
{{- $root := .root -}}
{{- $component := .component -}}
{{- if hasKey $root.Values "components" -}}
  {{- if and (hasKey $root.Values.components $component) (index $root.Values.components $component).serviceAccount.create -}}
    {{- default (printf "%s-%s" (include "plaid-quickstart.fullname" $root) $component) (index $root.Values.components $component).serviceAccount.name -}}
  {{- else -}}
    {{- default "default" (index $root.Values.components $component).serviceAccount.name -}}
  {{- end -}}
{{- else -}}
    {{- default "default" $root.Values.serviceAccount.name -}}
{{- end -}}
{{- end }}
