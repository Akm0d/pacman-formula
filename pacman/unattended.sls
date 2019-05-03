{% set pillar = salt['pillar.get']('pacman') %}

{% if grains.os_family == 'Arch' %}
pacman:
  # List packages by repo
  # If a repo is in the pillar's list of repos, then see if packages in that repo have upgrades
  # upgrade packages

{% endif %} 
