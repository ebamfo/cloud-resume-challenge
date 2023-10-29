output "rgname" {
  value       = azurerm_resource_group.crc-test-rg.name
  description = "Displaying Resource Group name"
}

output "appname" {
  value       = azurerm_linux_function_app.funcapp-crc-test-01.name
  description = "Displaying Azure Function name"
}

output "cdn-endpnt-url" {
  value       = azurerm_cdn_endpoint.cdn-endpoint-crc-test.fqdn
  description = "Displaying CDN Endpoint url"
}

output "api-endpoint" {
  value = "https://${azurerm_linux_function_app.funcapp-crc-test-01.default_hostname}/api/HttpTrigger3"
  description = "Azure function URL"
}

output "funcapp-publish-profile" {
  value= azurerm_linux_function_app.funcapp-crc-test-01.site_credential
  description = "Azure Function App publishing profile"
  sensitive = true
}

output "strg-acc-name" {
  value = azurerm_storage_account.strg-crc-test.name
  description = "Storage Account Name"
}