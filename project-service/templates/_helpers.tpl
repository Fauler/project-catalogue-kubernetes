{{- define "project-service.name" -}}
{{- .Chart.Name }}
{{- end }}

{{- define "project-service.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "project-service.labels" -}}
app.kubernetes.io/name: {{ include "project-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "project-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "project-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

