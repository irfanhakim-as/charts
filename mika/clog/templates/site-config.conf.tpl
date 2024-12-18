{{/*
Apache site-config.conf template
*/}}
{{- define "clog.site-config-conf" -}}
<VirtualHost *:80>
    ServerName DOMAIN:443
    UseCanonicalName On
    ServerAdmin SERVER_ADMIN
    DocumentRoot /clog
    WSGIScriptAlias / /clog/clog/wsgi.py
    WSGIDaemonProcess DOMAIN python-path=/clog
    WSGIProcessGroup DOMAIN

    <Directory /clog/clog>
        <Files wsgi.py>
            Require all granted
        </Files>
    </Directory>

    Alias /static /static
    <Directory /static>
        Require all granted
    </Directory>

    Alias /media /clog/media
    <Directory /clog/media>
        Require all granted
    </Directory>

    ErrorLog LOG_MOUNT_PATH/apache.error.log
    CustomLog LOG_MOUNT_PATH/apache.access.log combined
</VirtualHost>
{{- end }}
