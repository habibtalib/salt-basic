include:
  - hwaas-site

supervisor:
  pkg.installed:
    - require:
      - sls: hwaas-site
  service.running:
    - watch:
      - file: /etc/supervisor/conf.d/hwaas-site.conf

restart-hwaas-site:
  supervisord.running:
    - name: hwaas-site
    - watch:
      - sls: hwaas-site

/etc/supervisor/conf.d/hwaas-site.conf:
  file.managed:
    - source: salt://hwaas-service/supervisor.conf
    - require:
      - pkg: supervisor
