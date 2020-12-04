install_dante:
  pkg.installed:
    - name: dante-server

dante_user:
  user.present:
    - name: heiskane
    - shell: /usr/sbin/nologin
    - password: $6$Pojx5jnjRxDO2E96$tzZazL8Pvdv3YaLULra.UukbBPCE/Pn3g6smmbODAI6teQEBA4j4iJzGWrALYcj/z.4BKlEU/d2gLbbEbr99Y1

add_config:
  file.managed:
    - name: /etc/danted.conf
    - source: salt://dante/danted.conf
    - require:
      - pkg: install_dante

reload_dante:
  service.running:
    - name: danted
    - enable: True
    - restart: True
    - watch:
      - file: /etc/danted.conf
    - require:
      - pkg: install_dante


# This part will only allow connections to port 1080
# So ssh will not be allowed as this is intended to
# setup DISPOSABLE socks5 proxies fast
/etc/ufw/:
  file.recurse:
    - source: salt://dante/ufw/
    - file_mode: 640
