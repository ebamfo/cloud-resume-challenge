variable "azurerm_linux_function_app_connection_str" {
  description = "Connection string for cosmosdb table storage - default format"
  type = string
  sensitive = true
}

variable "cosmosdb-connection-str" {
  description = "Connection string for cosmosdb table storage - azure functions format"
  type = string
  sensitive = true
}

variable "azurerm_linux_function_app-storage-access-key" {
  description = "storage access key for azure functions app"
  type = string
  sensitive = true
}


variable "application_insights_connection_string" {
  description = "storage access key for azure functions app"
  type = string
  sensitive = true
}
 