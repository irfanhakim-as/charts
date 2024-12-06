{{/*
Ghost config.json template
*/}}
{{- define "ghost.config-json" -}}
{{- $domain := .Values.ghost.domain | default "localhost" | toString | quote }}
{{- $port := .Values.service.port | default "2368" | toString }}
{{- $mailSecure := .Values.mail.secure | default "true" | toString }}
{{- $mailService := .Values.mail.service | default "Google" | toString | quote }}
{{- $smtpHost := .Values.mail.smtp.host | default "smtp.gmail.com" | toString | quote }}
{{- $smtpPort := .Values.mail.smtp.port | default "465" | toString }}
{{- $smtpUser := .Values.mail.smtp.user | toString }}
{{- $smtpPassword := .Values.mail.smtp.password | toString | quote }}
{{- $mailFrom := .Values.mail.from_email | default $smtpUser | toString | quote }}
{{- $db_type := .Values.db.type | default "mysql" | toString | quote }}
{{- $db_name := .Values.db.name | toString | quote }}
{{- $db_user := .Values.db.user | toString | quote }}
{{- $db_password := .Values.db.password | toString | quote }}
{{- $db_host := .Values.db.host | toString | quote }}
{{- $db_port := .Values.db.port | default "3306" | toString | quote }}
{{- $install_dir := .Values.ghost.install_dir | default "/home/nonroot/app/ghost" | toString }}
{{- $dataMountPath := .Values.storage.data.mountPath | default (printf "%s/content" $install_dir) | toString | quote }}
{
    "url": {{ $domain }},
    "admin": {
        "url": {{ $domain }}
    },
    "server": {
        "port": {{ int $port }},
        "host": "0.0.0.0"
    },
    "mail": {
        "transport": "SMTP",
        "from": {{ $mailFrom }},
        "options": {
            "service": {{ $mailService }},
            "host": {{ $smtpHost }},
            "port": {{ int $smtpPort }},
            "secure": {{ $mailSecure }},
            "auth": {
                "user": {{ $smtpUser | quote }},
                "pass": {{ $smtpPassword }}
            }
        }
    },
    "logging": {
        "transports": [
            "stdout"
        ]
    },
    "database": {
        "client": {{ $db_type }},
        "connection": {
            "host": {{ $db_host }},
            "user": {{ $db_user }},
            "password": {{ $db_password }},
            "database": {{ $db_name }},
            "port": {{ $db_port }}
        }
    },
    "process": "local",
    "paths": {
        "contentPath": {{ $dataMountPath }}
    }
}
{{- end }}
