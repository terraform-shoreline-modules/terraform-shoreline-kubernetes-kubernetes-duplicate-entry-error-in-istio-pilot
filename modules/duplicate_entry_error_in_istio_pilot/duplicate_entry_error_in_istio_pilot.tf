resource "shoreline_notebook" "duplicate_entry_error_in_istio_pilot" {
  name       = "duplicate_entry_error_in_istio_pilot"
  data       = file("${path.module}/data/duplicate_entry_error_in_istio_pilot.json")
  depends_on = [shoreline_action.invoke_log_analysis,shoreline_action.invoke_restart_istio_pilot_service]
}

resource "shoreline_file" "log_analysis" {
  name             = "log_analysis"
  input_file       = "${path.module}/data/log_analysis.sh"
  md5              = filemd5("${path.module}/data/log_analysis.sh")
  description      = "Configuration errors: The duplicate entry error may occur if there are configuration errors in the instance or labels of Istio Pilot. This could happen due to a misconfiguration while setting up Istio Pilot or changes made to the configuration by mistake."
  destination_path = "/agent/scripts/log_analysis.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_istio_pilot_service" {
  name             = "restart_istio_pilot_service"
  input_file       = "${path.module}/data/restart_istio_pilot_service.sh"
  md5              = filemd5("${path.module}/data/restart_istio_pilot_service.sh")
  description      = "Restart the Istio Pilot service to see if that resolves the issue. If not, attempt to roll back to a previous version of the service that was working correctly."
  destination_path = "/agent/scripts/restart_istio_pilot_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_log_analysis" {
  name        = "invoke_log_analysis"
  description = "Configuration errors: The duplicate entry error may occur if there are configuration errors in the instance or labels of Istio Pilot. This could happen due to a misconfiguration while setting up Istio Pilot or changes made to the configuration by mistake."
  command     = "`chmod +x /agent/scripts/log_analysis.sh && /agent/scripts/log_analysis.sh`"
  params      = ["POD_NAME","YOUR_LOG_FILE_PATH","NAMESPACE","YOUR_CONTAINER_NAME"]
  file_deps   = ["log_analysis"]
  enabled     = true
  depends_on  = [shoreline_file.log_analysis]
}

resource "shoreline_action" "invoke_restart_istio_pilot_service" {
  name        = "invoke_restart_istio_pilot_service"
  description = "Restart the Istio Pilot service to see if that resolves the issue. If not, attempt to roll back to a previous version of the service that was working correctly."
  command     = "`chmod +x /agent/scripts/restart_istio_pilot_service.sh && /agent/scripts/restart_istio_pilot_service.sh`"
  params      = ["ISTIO_PILOT_DEPLOYMENT_NAME","ISTIO_PILOT_APP_LABEL"]
  file_deps   = ["restart_istio_pilot_service"]
  enabled     = true
  depends_on  = [shoreline_file.restart_istio_pilot_service]
}

