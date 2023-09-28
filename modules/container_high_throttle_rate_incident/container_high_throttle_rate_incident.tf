resource "shoreline_notebook" "container_high_throttle_rate_incident" {
  name       = "container_high_throttle_rate_incident"
  data       = file("${path.module}/data/container_high_throttle_rate_incident.json")
  depends_on = [shoreline_action.invoke_throttle_check,shoreline_action.invoke_restart_container]
}

resource "shoreline_file" "throttle_check" {
  name             = "throttle_check"
  input_file       = "${path.module}/data/throttle_check.sh"
  md5              = filemd5("${path.module}/data/throttle_check.sh")
  description      = "The container may be processing more requests than it can handle, leading to a high throttle rate."
  destination_path = "/agent/scripts/throttle_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_container" {
  name             = "restart_container"
  input_file       = "${path.module}/data/restart_container.sh"
  md5              = filemd5("${path.module}/data/restart_container.sh")
  description      = "A Script to restart the docker container"
  destination_path = "/agent/scripts/restart_container.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_throttle_check" {
  name        = "invoke_throttle_check"
  description = "The container may be processing more requests than it can handle, leading to a high throttle rate."
  command     = "`chmod +x /agent/scripts/throttle_check.sh && /agent/scripts/throttle_check.sh`"
  params      = ["MAX_THROTTLE_RATE","CONTAINER_NAME"]
  file_deps   = ["throttle_check"]
  enabled     = true
  depends_on  = [shoreline_file.throttle_check]
}

resource "shoreline_action" "invoke_restart_container" {
  name        = "invoke_restart_container"
  description = "A Script to restart the docker container"
  command     = "`chmod +x /agent/scripts/restart_container.sh && /agent/scripts/restart_container.sh`"
  params      = ["ADDITIONAL_PARAMETERS","IMAGE_NAME","CONTAINER_NAME"]
  file_deps   = ["restart_container"]
  enabled     = true
  depends_on  = [shoreline_file.restart_container]
}

