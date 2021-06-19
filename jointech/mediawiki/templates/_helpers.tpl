{{/*
Expand the name of the chart.
*/}}
{{- define "mediawiki.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mediawiki.fullname" -}}
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
{{- define "mediawiki.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mediawiki.labels" -}}
helm.sh/chart: {{ include "mediawiki.chart" . }}
{{ include "mediawiki.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mediawiki.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mediawiki.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common environment values
*/}}
{{- define "mediawiki.env" -}}
- name: WG_SERVER
  value: {{ .Values.wiki.server | quote }}

- name: MEDIAWIKI_ADMIN_USER
  value: "admin"

- name: MEDIAWIKI_ADMIN_PASS
  value: "hardcodedexamplepasswordthatwillbereplacedlater" # FIXME

- name: ALLOW_PUBLIC_EDIT
  value: "true"  # FIXME

- name: WG_SECRET_KEY
  value: {{ .Values.wiki.secretKey }}

- name: WG_DB_TYPE
  value: {{ .Values.database.type }}

- name: WG_DB_SERVER
  value: {{ .Values.database.server }}

- name: WG_DB_PORT
  value: {{ .Values.database.port | quote }}

- name: WG_DB_NAME
  value: {{ .Values.database.name }}

- name: WG_DB_USER
  {{- if .Values.database.secretName }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.secretName }}
      key: username
  {{- else }}
  value: {{ .Values.database.username }}
  {{- end }}

- name: WG_DB_PASSWORD
  {{- if .Values.database.secretName }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.secretName }}
      key: password
  {{- else }}
  value: {{ .Values.database.password }}
  {{- end }}

#WG_SITENAME="Test Wiki"
#WG_SCRIPT_PATH=""
#WG_SERVER="https://wiki.example.com"
#SEMANTIC_URL="wiki.example.com"
#WG_ENABLE_UPLOADS="false"
#WG_ENABLE_EMAIL="false"
#WG_UPLOAD_PATH="/uploads"
#WG_META_NAMESPACE="Meta"
#WG_LANGUAGE_CODE="en"
#MEDIAWIKI_ADMIN_USER="admin"
#MEDIAWIKI_ADMIN_PASS="password"
#WG_DB_TYPE="sqlite"
#WG_DB_SERVER=""
#WG_DB_NAME="my_wiki"
#WG_DB_PASSWORD="password"
#WG_DB_PREFIX=""
#WG_DB_MWSCHEMA=""
#WG_DATABASE_DIR="/var/www/data"
#WG_SECRET_KEY="0000000000000000000000000000000000000000000000000000000000000000"
#WG_EMERGENCY_CONTACT="admin@example.com"
#WG_PASSWORD_SENDER="wiki@example.com"
#ALLOW_PUBLIC_REGISTRATION="false"
#ALLOW_PUBLIC_EDIT="false"
#ALLOW_PUBLIC_READ="true"
#DISABLE_ICONS="false"
#DEBUG="false"

{{- end }}
