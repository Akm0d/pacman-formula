/etc/pacman.conf:
  file.managed:
    - source: salt://pacman/files/pacman.conf.jinja2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
