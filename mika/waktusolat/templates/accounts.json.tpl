{{/*
WaktuSolat /base/lib/accounts.json template
*/}}
{{- define "waktusolat.accounts-json" -}}
{
    "accounts": [
        {{- $accounts := .Values.waktusolat.account }}
        {{- range $index, $account := $accounts }}
        {{- $normalised_api := $account.api | toString | replace "https" "" | replace ":" "" | replace "/" "" | replace "." "-" }}
        {{- $token_secret := printf "%s-%s.secret" $account.id $normalised_api | toString | replace " " "" }}
        {
            "uid": {{ $account.id | toString | quote }},
            "access_token": {{ printf "/base/base/%s" $token_secret | toString | quote }},
            "api_base_url": {{ $account.api | toString | quote }},
            "is_bot": {{ $account.bot | default "true" | toString }},
            "is_discoverable": {{ $account.discoverable | default "true" | toString }},
            "is_enabled": {{ $account.enabled | default "true" | toString }},
            {{- if $account.display_name }}
            "display_name": {{ $account.display_name | toString | quote }}
            {{- else }}
            "display_name": {{ $account.display_name | default "null" | toString }}
            {{- end }},
            "fields": [
                {{- $fields := $account.fields }}
                {{- range $i, $field := $fields }}
                [
                    {{ $field.name | toString | quote }},
                    {{ $field.value | toString | quote }}
                ]{{ if ne $i (sub (len $fields) 1) }},{{ end }}
                {{- end }}
            ],
            "host": {{ $account.host | default "mastodon" | toString | quote }},
            "is_locked": {{ $account.locked | default "false" | toString }},
            {{- if $account.note }}
            "note": {{ $account.note | toString | quote }}
            {{- else }}
            "note": {{ $account.note | default "null" | toString }}
            {{- end }}
        }{{ if ne $index (sub (len $accounts) 1) }},{{ end }}
        {{- end }}
    ]
}
{{- end }}
