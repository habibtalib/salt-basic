base:
  'roles:hwaas-web':
    - match: grain
    - nodejs-package
    - hwaas-service
  'roles:load-balancing':
    - match: grain
    - load-balance
