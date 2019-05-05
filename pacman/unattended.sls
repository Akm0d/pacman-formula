{%- from 'pacman/map.jinja' import to_upgrade, unattended_repos with context -%}
{%- set refresh_db = salt['pkg.refresh_db']() -%}
{%- set packages = salt['pkg.list_repo_pkgs'](byrepo=True) -%}
{%- set upgrades = salt['pkg.list_upgrades'](byrepo=True).keys() -%}
{%- for repo in unattended_repos -%}
    {%- do to_upgrade.extend(packages.get(repo, {}).keys()| intersect(upgrades)) -%}
{%- endfor -%}
unattended_upgrades:
  {%- if to_upgrade %}
  pkg.latest:
    - names:  {{ to_upgrade|json }}
  {%- else %}
  test.nop:
    - names:  {{ unattended_repos }}
  {%- endif %}
