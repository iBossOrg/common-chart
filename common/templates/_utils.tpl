{{/*
Merge two YAML templates and output the result.
This takes an array of values:
- the top context
- optional template args
- the template name of the base (source)
- the template name of the overrides (destination)
*/}}
{{- define "common.util.merge" -}}
{{- $args       := compact . -}}
{{- $top        := first   $args -}}
{{- $args       := rest    $args -}}
{{- $template   := last    $args -}}
{{- $args       := initial $args -}}
{{- $overrides  := last    $args -}}
{{- $args       := initial $args -}}
{{- $template   := fromYaml (include $template (prepend $args $top)) | default (dict) -}}
{{- $overrides  := fromYaml (include $overrides $top) | default (dict) -}}
{{- toYaml (merge $overrides $template) -}}
{{- end -}}