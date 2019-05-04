{%- from 'pacman/map.jinja' import to_upgrade with context %}
unattended_upgrades:
  {% if to_upgrade %}
  pkg.latest:
  {% else %}
  test.nop:
  {% endif %}
    - names: {{ to_upgrade }}
