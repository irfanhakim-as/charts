{{/*
Apache site-config.conf template
*/}}
{{- define "rizz.site-config-conf" -}}
<VirtualHost *:80>
    ServerName DOMAIN:443
    UseCanonicalName On
    ServerAdmin support@mikahomelab.com
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

    ErrorLog /var/log/apache2/apache.error.log
    CustomLog /var/log/apache2/apache.access.log combined
</VirtualHost>
{{- end }}
