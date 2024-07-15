{{/*
Cloudflare-DDNS config.json template
*/}}
{{- define "cloudflareddns.config-json" -}}
{
  "cloudflare": [
    {
      "authentication": {
        "api_token": "API_TOKEN"
      },
      "zone_id": "ZONE_ID",
      "subdomains": [
        {{- $subdomains := .Values.cloudflareddns.subdomains }}
        {{- range $index, $subdomain := $subdomains }}
        {
          "name": {{ $subdomain.hostname | quote }},
          "proxied": {{ $subdomain.proxied | default "false" | toString }}
        }{{ if ne $index (sub (len $subdomains) 1) }},{{ end }}
        {{- end }}
      ]
    }
  ],
  "a": ENABLE_IPV4,
  "aaaa": ENABLE_IPV6,
  "purgeUnknownRecords": false,
  "ttl": 300
}
{{- end }}
