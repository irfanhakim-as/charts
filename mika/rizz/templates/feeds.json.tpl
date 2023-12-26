{{/*
Mastodon /base/lib/feeds.json template
*/}}
{{- define "rizz.feeds-json" -}}
{
    "feeds": [
        {{- $feeds := .Values.rizz.rss }}
        {{- range $index, $feed := $feeds }}
        {
            "id": {{ $feed.id | toString | quote }},
            "url": {{ $feed.feed | toString | quote }},
            "date_format": {{ $feed.pubdate_format | default "%a, %d %b %Y %H:%M:%S %z" | toString | quote }}
        }{{ if ne $index (sub (len $feeds) 1) }},{{ end }}
        {{- end }}
    ]
}
{{- end }}
