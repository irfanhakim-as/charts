{{/*
Nginx common.conf template
*/}}
{{- define "grocy.common-conf" -}}
charset utf-8;

location / {
    try_files $uri /index.php$is_args$query_string;
}

location ~* .(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 365d;
}

location ~ \.php$ {
    fastcgi_pass   {{ .Release.Name }}-grocy-svc:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
}

location ~ /\.ht {
    deny  all;
}
{{- end }}
