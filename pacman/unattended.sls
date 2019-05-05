{%- from 'pacman/map.jinja' import to_upgrade, unattended_repos with context -%}
{%- set refresh_db = salt['pkg.refresh_db']() -%}
{%- set packages = salt['pkg.list_repo_pkgs'](byrepo=True) -%}
{%- set upgrades = salt['pkg.list_upgrades'](byrepo=True) -%}
{%- for repo, has_updates in refresh_db.get('repos', {}).items() -%}
  {%- if has_updates and repo in unattended_repos -%}
    {%- do to_upgrade.extend(upgrades[repo].keys()) -%}
  {%- endif -%}
{%- endfor -%}
unattended_upgrades:
  {% if to_upgrade %}
  pkg.latest:
    - names:  {{ to_upgrade }}
  {% else %}
  test.nop:
    - names:  {{ unattended_repos }}
  {% endif %}
