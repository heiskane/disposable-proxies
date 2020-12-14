install_dante:
  pkg.installed:
    - name: dante-server

# Get users from /srv/pillar/users
{% for user in pillar['users'] %}
{{ user }}:
  user.present:
    - shell: /usr/sbin/nologin
    - password: {{ pillar['users'][user]['password'] }}
    - hash_password: True

{% endfor %}

add_config:
  file.managed:
    - name: /etc/danted.conf
    - source: salt://dante/danted.conf
    - require:
      - pkg: install_dante

danted:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/danted.conf
    - require:
      - pkg: install_dante

# TODO Set dafaut firewall rule for incoming to DROP pr something
dante_tcp:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - dport: 1080
    - proto: tcp
    - save: True

dante_udp:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - dport: 1080
    - proto: udp
    - save: True
