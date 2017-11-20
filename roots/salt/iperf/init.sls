iperf_user:
  user.present:
    - name: iperf
    - shell: /bin/bash
    - groups:
      - sudo
    - password: some_password

apt_prereqs:
  pkg.installed:
    - pkgs:
      - iperf: 2.0.5*

logrotate_conf:
  file.managed:
    - name: /etc/logrotate.d/iperf
    - source: salt://iperf/files/iperf-logrotate.conf

iperf_service:
  file.managed:
    - name: /etc/systemd/system/iperf.service
    - source: salt://iperf/files/iperf.service

iperf_timestamp_script:
  file.managed:
    - name: /home/iperf/iperf-timestamp.sh
    - source: salt://iperf/files/iperf-timestamp.sh
    - user: iperf
    - mode: 744
    - require:
      - user: iperf_user

iperf_log_directory:
  file.directory:
    - name: /var/log/iperf
    - user: iperf
    - require:
      - user: iperf_user

/home/iperf/iperf-timestamp.sh:
  cron.present:
    - user: iperf
    - minute: 0
    - require:
      - file: iperf_timestamp_script

enable_iperf_service:
  service.running:
    - name: iperf
    - enable: True
    - watch:
      - file: iperf_service
    - require:
      - pkg: apt_prereqs
      - cron: /home/iperf/iperf-timestamp.sh
      - file: iperf_log_directory
      - file: iperf_service
