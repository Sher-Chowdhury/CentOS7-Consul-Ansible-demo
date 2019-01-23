template {
  source = "/etc/consul-template/consul-templates/common/users.ctmpl"
  destination = "/etc/consul-template/rendered-templates/common/users.yml"
  command = "/bin/bash -c '/bin/ansible-playbook -i 127.0.0.1, /etc/consul-template/rendered-templates/common/users.yml || true'"
  command_timeout = "60s"
  perms = 0600
  wait {
    min = "5s"
    max = "10s"
  }
}