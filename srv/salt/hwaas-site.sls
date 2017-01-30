include:
  - nodejs-package

hwaas-user:
  user.present:
    - name: hwaas
    - home: /home/hwaas

git-client-package:
  pkg.installed:
    - name: git

hwaas-source:
  git.latest:
    - name: https://github.com/floyd-may/hwaas.git
    - rev: master
    - force_reset: True
    - target: /home/hwaas/hwaas-site
    - require:
      - user: hwaas-user
      - pkg: git-client-package
      - sls: nodejs-package

hwaas-npm-install:
  cmd.wait:
    - name: npm install
    - cwd: /home/hwaas/hwaas-site
    - watch:
      - git: hwaas-source

hwaas-build-script:
  cmd.wait:
    - name: npm run-script build
    - cwd: /home/hwaas/hwaas-site
    - watch:
      - git: hwaas-source

