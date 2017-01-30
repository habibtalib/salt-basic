set-new-minion-role:
  salt.function:
    - name: grains.append
    - tgt: {{ pillar['target-minion'] }}
    - arg:
      - roles
      - hwaas-web

apply-states-on-new-minion:
  salt.state:
    - tgt: {{ pillar['target-minion'] }}
    - sls: hwaas-service
    - require:
      - salt: set-new-minion-role

refresh-pillar-on-new-minion:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: {{ pillar['target-minion'] }}
    - require:
      - salt: apply-states-on-new-minion

update-mine-data-from-new-minion:
  salt.function:
    - name: mine.update
    - tgt: {{ pillar['target-minion'] }}
    - require:
      - salt: refresh-pillar-on-new-minion

update-hwaas-online-grain:
  salt.function:
    - name: grains.append
    - arg:
      - hwaas
      - online
    - require:
      - salt: update-mine-data-from-new-minion

run-state-apply-on-load-balancer:
  salt.state:
    - tgt: roles:load-balancing
    - tgt_type: grain
    - sls: load-balance
    - require:
      - salt: update-hwaas-online-grain
