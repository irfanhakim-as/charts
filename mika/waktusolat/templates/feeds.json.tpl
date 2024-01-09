{{/*
Mastodon /base/lib/feeds.json template
*/}}
{{- define "waktusolat.feeds-json" -}}
{
    "feeds": [
        {{- $feeds := .Values.waktusolat.feed }}
        {{- range $index, $feed := $feeds }}
        {
            "uid": {{ $feed.id | toString | quote }},
            "endpoint": {{ $feed.endpoint | toString | quote }},
            "is_enabled": {{ $feed.enabled | default "true" | toString }},
        }{{ if ne $index (sub (len $feeds) 1) }},{{ end }}
        {{- end }}
    ]
}
{{- end }}
