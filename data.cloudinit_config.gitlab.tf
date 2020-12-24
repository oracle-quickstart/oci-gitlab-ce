data cloudinit_config gitlab {
  gzip          = false
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "./metadata.gitlab.cloud-config",
      {
        GITLAB_SSH_PORT = var.gitlab_ssh_port,
      }
    )
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      "./metadata.gitlab.sh", {
        GITLAB_SSH_PORT = var.gitlab_ssh_port,
      }
    )
  }
}
