{{/*
Common metadata.
This template takes an array of values:
- the top context
- optional one or more resources
- optional template name of the overrides

# Example values.yaml
global:
  labels: {}
  selectors: {}
  annotations: {}

resource:
  name: myresource
  labels: {}
  selectors: {}
  annotations: {}
*/}}
{{- define "common.metadata" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- if typeIs "string" (last $args) -}}
{{- template "common.util.merge" (append . "common.metadata.tpl") -}}
{{- else -}}
{{- template "common.metadata.tpl" . -}}
{{- end -}}
{{- end -}}

{{- define "common.metadata.tpl" }}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $resource := last     $args | default (dict) -}}
{{- $fullName := include "common.fullname" $top -}}
name: {{ list $fullName $resource.name | compact | join "-" | quote }}
labels:
  {{- include "common.labels" . | nindent 2 }}
annotations:
  {{- include "common.annotations" . | nindent 2 }}
{{- end -}}

{{/*
Common labels.
This template takes an array of values:
- the top context
- optional one or more resources
*/}}
{{- define "common.labels" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $global   := $top.Values.global | default (dict) -}}
{{- $labels   := dict -}}
{{- range $values := prepend $args $global -}}
{{- with $values.labels -}}
{{- $labels = $labels | merge . -}}
{{- end -}}
{{- end -}}
{{- toYaml $labels }}
{{- include "common.selectors" . | nindent 0 }}
{{- with $top.Chart.AppVersion }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $top.Release.Service | quote }}
helm.sh/chart: {{ include "common.chart" $top | quote }}
{{- end -}}

{{/*
Selector labels.
This template takes an array of values:
- the top context
- optional one or more resources
*/}}
{{- define "common.selectors" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $global   := $top.Values.global | default (dict) -}}
{{- $labels   := dict -}}
{{- range $values := prepend $args $global -}}
{{- with $values.selectors -}}
{{- $labels = $labels | merge . -}}
{{- end -}}
{{- end -}}
{{- toYaml $labels }}
app.kubernetes.io/name: {{ include "common.name" $top | quote }}
app.kubernetes.io/instance: {{ $top.Release.Name | quote }}
{{- end -}}

{{/*
Common annotations.
This template takes an array of values:
- the top context
- optional one or more resources
*/}}
{{- define "common.annotations" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $global   := $top.Values.global | default (dict) -}}
{{- $annotations := dict -}}
{{- range $values := prepend $args $global -}}
{{- with $values.annotations -}}
{{- $annotations = $annotations | merge . -}}
{{- end -}}
{{- end -}}
{{- toYaml $annotations }}
{{- end -}}