{% set pillar = salt['pillar.get']('pacman') %}
{% set unattended_repos = [] %}
{% set to_upgrade = [] %}

{% if grains.os_family == 'Arch' %}
  {% for repo in pillar.get('repos', {}) %}
    {% if repo is not string %}
      {% set repo = repo.keys()[0] %}
    {% endif %}
    {% do unattended_repos.append(repo) %}
  {% endfor %}

  {% set refresh_db = salt['pkg.refresh_db']() %}
  {% set packages = salt['pkg.list_repo_pkgs'](byrepo=True) %}
  {% set upgrades = salt['pkg.list_upgrades'](byrepo=True) %}

  {% for repo, has_updates in refresh_db.get('repos', {}).items() %}
    {% if has_updates and repo in unattended_repos %}
      {% do to_upgrade.extend(upgrades[repo]) %}
    {% endif %}
  {% endfor %}

{% endif %}

unattended_upgrades:
  {% if to_upgrade %}
  pkg.latest:
  {% else %}
  test.nop:
    - names: {{ to_upgrade }}
  {% endif %}
