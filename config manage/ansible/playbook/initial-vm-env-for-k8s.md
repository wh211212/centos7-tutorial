# 初始化vm配置为了k8s集群安装

- hosts: k8s
  become: yes
  become_method: sudo
  tasks:
  - name: General packages are installed
    yum: name={{ item }} state=installed
    with_items:
      - vim-enhanced
      - wget
      - net-tools
    tags: General_Packages

    