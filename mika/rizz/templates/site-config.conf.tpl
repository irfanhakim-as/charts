{{/*
Apache site-config.conf template
*/}}
{{- define "rizz.site-config-conf" -}}
<VirtualHost *:80>
    ServerName DOMAIN:443
    UseCanonicalName On
    ServerAdmin SERVER_ADMIN
    DocumentRoot /base
    WSGIScriptAlias / /base/base/wsgi.py
    WSGIDaemonProcess DOMAIN python-path=/base
    WSGIProcessGroup DOMAIN

    <Directory /base/base>
        <Files wsgi.py>
            Require all granted
        </Files>
    </Directory>

    Alias /static /static
    <Directory /static>
        Require all granted
    </Directory>

    ErrorLog LOG_MOUNT_PATH/apache.error.log
    CustomLog LOG_MOUNT_PATH/apache.access.log combined
</VirtualHost>
{{- end }}
