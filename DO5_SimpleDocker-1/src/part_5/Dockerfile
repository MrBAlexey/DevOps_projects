FROM nginx
WORKDIR /home/
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./server_prt_5.c .
COPY ./run.sh .

RUN apt-get update && apt-get install -y gcc spawn-fcgi libfcgi-dev; \
    # рекурсивное изменение владельца каталогов и их содержимого
    chown -R nginx:nginx /etc/nginx/nginx.conf; \
    chown -R nginx:nginx /var/cache/nginx; \
    chown -R nginx:nginx /home; \
    #создаёт файл, в котором будет храниться номер (PID) главного процесса
    touch /var/run/nginx.pid; \
    chown -R nginx:nginx /var/run/nginx.pid; \
    chmod 755 /usr/bin/umount; \
	chmod 755 /usr/bin/passwd; \
	chmod 755 /usr/bin/mount; \
	chmod 755 /usr/bin/newgrp; \
	chmod 755 /usr/bin/chsh; \
	# * setgid file: grwxr-xr-x usr/bin/expiry
	chmod 755 /usr/bin/su; \
	# * setgid file: grwxr-xr-x usr/sbin/unix_chkpwd
	# * setgid file: grwxr-xr-x usr/bin/chage
	chmod 755 /usr/bin/gpasswd; \
	chmod 755 /usr/bin/chfn; \
	rm -rf /var/lib/apt/lists
    
USER nginx
ENTRYPOINT ["sh", "./run.sh"]
HEALTHCHECK NONE