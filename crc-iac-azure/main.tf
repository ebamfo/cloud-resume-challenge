resource "azurerm_resource_group" "res-0" {
  location = "uksouth"
  name     = "cloud-resume-challenge-chunk-1"
}
resource "azurerm_cdn_endpoint_custom_domain" "res-1" {
  cdn_endpoint_id = "/subscriptions/4885c523-a01c-418f-941b-cab57419ea27/resourceGroups/cloud-resume-challenge-chunk-1/providers/Microsoft.Cdn/profiles/resume/endpoints/ebamfo9"
  host_name       = "ebamforesume.cloud"
  name            = "ebamforesume-cloud"
  user_managed_https {
    key_vault_secret_id = "https://kv-pers-storage-uksouth.vault.azure.net/certificates/ssl-certificate-1"
  }
  depends_on = [
    azurerm_cdn_endpoint.res-41,
  ]
}
resource "azurerm_cdn_endpoint_custom_domain" "res-2" {
  cdn_endpoint_id = "/subscriptions/4885c523-a01c-418f-941b-cab57419ea27/resourceGroups/cloud-resume-challenge-chunk-1/providers/Microsoft.Cdn/profiles/resume/endpoints/ebamfo9"
  host_name       = "www.ebamforesume.cloud"
  name            = "www-ebamforesume-cloud"
  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
  }
  depends_on = [
    azurerm_cdn_endpoint.res-41,
  ]
}
resource "azurerm_cosmosdb_account" "res-4" {
  location            = "uksouth"
  name                = "cosmos-table-pers-prod"
  offer_type          = "Standard"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  tags = {
    defaultExperience       = "Azure Table"
    hidden-cosmos-mmspecial = ""
  }
  consistency_policy {
    consistency_level = "BoundedStaleness"
  }
  geo_location {
    failover_priority = 0
    location          = "uksouth"
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_cosmosdb_table" "res-5" {
  account_name        = "cosmos-table-pers-prod"
  name                = "ViewsCounter"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  depends_on = [
    azurerm_cosmosdb_account.res-4,
  ]
}
resource "azurerm_key_vault" "res-6" {
  location            = "uksouth"
  name                = "kv-pers-storage-uksouth"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  sku_name            = "standard"
  tenant_id           = "e66ab07b-78e6-489c-8ab5-f7376d0584ff"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_key_vault_certificate" "res-7" {
  key_vault_id = "/subscriptions/4885c523-a01c-418f-941b-cab57419ea27/resourceGroups/cloud-resume-challenge-chunk-1/providers/Microsoft.KeyVault/vaults/kv-pers-storage-uksouth"
  name         = "ssl-certificate-1"
  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }
    key_properties {
      exportable = true
      key_type   = "RSA"
      reuse_key  = false
    }
    lifetime_action {
      action {
        action_type = "EmailContacts"
      }
      trigger {
        lifetime_percentage = 80
      }
    }
    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
  depends_on = [
    azurerm_key_vault.res-6,
  ]
}
resource "azurerm_dns_zone" "res-8" {
  name                = "ebamforesume.cloud"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_dns_a_record" "res-9" {
  name                = "@"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  target_resource_id  = "/subscriptions/4885c523-a01c-418f-941b-cab57419ea27/resourceGroups/cloud-resume-challenge-chunk-1/providers/microsoft.cdn/profiles/resume/endpoints/ebamfo9"
  ttl                 = 60
  zone_name           = "ebamforesume.cloud"
  depends_on = [
    azurerm_dns_zone.res-8,
  ]
}
resource "azurerm_dns_cname_record" "res-10" {
  name                = "cdnverify"
  record              = "cdnverify.ebamfo9.azureedge.net"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  ttl                 = 3600
  zone_name           = "ebamforesume.cloud"
  depends_on = [
    azurerm_dns_zone.res-8,
  ]
}
resource "azurerm_dns_cname_record" "res-11" {
  name                = "www"
  record              = "ebamfo9.azureedge.net"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  ttl                 = 3600
  zone_name           = "ebamforesume.cloud"
  depends_on = [
    azurerm_dns_zone.res-8,
  ]
}
resource "azurerm_dns_ns_record" "res-12" {
  name                = "@"
  records             = ["ns1-34.azure-dns.com.", "ns2-34.azure-dns.net.", "ns3-34.azure-dns.org.", "ns4-34.azure-dns.info."]
  resource_group_name = "cloud-resume-challenge-chunk-1"
  ttl                 = 172800
  zone_name           = "ebamforesume.cloud"
  depends_on = [
    azurerm_dns_zone.res-8,
  ]
}
resource "azurerm_dns_txt_record" "res-14" {
  name                = "_acme-challenge"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  ttl                 = 3600
  zone_name           = "ebamforesume.cloud"
  record {
    value = "8D97zeRGSDcgeyU5-ACtQVw1I5pCqX7dT6rUU67rGwc"
  }
  record {
    value = "jT7_DiiMOnOP_zd1z_XSefBw3sCcjGftZ-ItIVtGY-4"
  }
  depends_on = [
    azurerm_dns_zone.res-8,
  ]
}
resource "azurerm_network_watcher" "res-15" {
  location            = "uksouth"
  name                = "NetworkWatcher_uksouth"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}

resource "azurerm_storage_account" "res-17" {
  account_kind                    = "Storage"
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  default_to_oauth_authentication = true
  location                        = "uksouth"
  name                            = "cloudresumechallenga98f"
  resource_group_name             = "cloud-resume-challenge-chunk-1"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_storage_container" "res-19" {
  name                 = "azure-webjobs-hosts"
  storage_account_name = "cloudresumechallenga98f"
}
resource "azurerm_storage_container" "res-20" {
  name                 = "azure-webjobs-secrets"
  storage_account_name = "cloudresumechallenga98f"
}
resource "azurerm_storage_container" "res-21" {
  name                 = "scm-releases"
  storage_account_name = "cloudresumechallenga98f"
}
resource "azurerm_storage_share" "res-23" {
  name                 = "func-pers-prod-01a435"
  quota                = 5120
  storage_account_name = "cloudresumechallenga98f"
}
resource "azurerm_storage_account" "res-26" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = "uksouth"
  name                     = "ebamfo9"
  resource_group_name      = "cloud-resume-challenge-chunk-1"
  static_website {
    error_404_document = "error.html"
    index_document     = "resume.html"
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_storage_container" "res-28" {
  name                 = "$web"
  storage_account_name = "ebamfo9"
}
resource "azurerm_storage_container" "res-29" {
  name                 = "hello"
  storage_account_name = "ebamfo9"
}
resource "azurerm_service_plan" "res-33" {
  location            = "uksouth"
  name                = "ASP-cloudresumechallengechunk2-b186"
  os_type             = "Linux"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  sku_name            = "Y1"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_linux_function_app" "res-34" {
  app_settings = {
    CONNECTION_STR = local.cosmosdb_connection_string
  }
  builtin_logging_enabled    = false
  client_certificate_mode    = "Required"
  https_only                 = true
  location                   = "uksouth"
  name                       = "func-pers-prod-01"
  resource_group_name        = "cloud-resume-challenge-chunk-1"
  service_plan_id            = azurerm_service_plan.res-33.id
  storage_account_access_key = azurerm_storage_account.res-17.primary_access_key
  storage_account_name       = "cloudresumechallenga98f"
  tags = {
    "hidden-link: /app-insights-conn-string"         = azurerm_application_insights.res-43.connection_string
    "hidden-link: /app-insights-instrumentation-key" = azurerm_application_insights.res-43.instrumentation_key
    "hidden-link: /app-insights-resource-id"         = "/subscriptions/4885c523-a01c-418f-941b-cab57419ea27/resourceGroups/cloud-resume-challenge-chunk-1/providers/microsoft.insights/components/func-pers-prod-01"
  }
  site_config {
    application_insights_connection_string = azurerm_application_insights.res-43.connection_string
    application_insights_key               = azurerm_application_insights.res-43.instrumentation_key
    ftps_state                             = "FtpsOnly"
    application_stack {
      python_version = "3.9"
    }
    cors {
      allowed_origins = ["https://ebamforesume.cloud", "https://portal.azure.com", "https://www.ebamforesume.cloud"]
    }
  }
  depends_on = [
    azurerm_service_plan.res-33,
  ]
}
resource "azurerm_function_app_function" "res-38" {
  config_json     = "{\"bindings\":[{\"authLevel\":\"anonymous\",\"direction\":\"in\",\"methods\":[\"get\",\"post\"],\"name\":\"req\",\"type\":\"httpTrigger\"},{\"direction\":\"out\",\"name\":\"$return\",\"type\":\"http\"}],\"scriptFile\":\"__init__.py\"}"
  function_app_id = "/subscriptions/4885c523-a01c-418f-941b-cab57419ea27/resourceGroups/cloud-resume-challenge-chunk-1/providers/Microsoft.Web/sites/func-pers-prod-01"
  name            = "HttpTrigger3"
  depends_on = [
    azurerm_linux_function_app.res-34,
  ]
}
resource "azurerm_app_service_custom_hostname_binding" "res-39" {
  app_service_name    = "func-pers-prod-01"
  hostname            = "func-pers-prod-01.azurewebsites.net"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  depends_on = [
    azurerm_linux_function_app.res-34,
  ]
}
resource "azurerm_cdn_profile" "res-40" {
  location            = "global"
  name                = "resume"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  sku                 = "Standard_Microsoft"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_cdn_endpoint" "res-41" {
  is_compression_enabled = true
  location               = "global"
  name                   = "ebamfo9"
  origin_host_header     = "ebamfo9.z33.web.core.windows.net"
  profile_name           = "resume"
  resource_group_name    = "cloud-resume-challenge-chunk-1"
  delivery_rule {
    name  = "HTTPtoHTTPS"
    order = 1
    request_scheme_condition {
      match_values = ["HTTP"]
    }
    url_redirect_action {
      protocol      = "Https"
      redirect_type = "Found"
    }
  }
  origin {
    host_name = "ebamfo9.z33.web.core.windows.net"
    name      = "ebamfo9-z33-web-core-windows-net"
  }
  depends_on = [
    azurerm_cdn_profile.res-40,
  ]
}
resource "azurerm_monitor_action_group" "res-42" {
  name                = "Application Insights Smart Detection"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  short_name          = "SmartDetect"

  email_receiver {
    name                    = "sendtoadmin"
    email_address           = "ebamfo9@gmail.com"
    use_common_alert_schema = true
  }
  arm_role_receiver {
    name                    = "Monitoring Contributor"
    role_id                 = "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
    use_common_alert_schema = true
  }
  arm_role_receiver {
    name                    = "Monitoring Reader"
    role_id                 = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
    use_common_alert_schema = true
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_application_insights" "res-43" {
  application_type    = "web"
  location            = "uksouth"
  name                = "func-pers-prod-01"
  resource_group_name = "cloud-resume-challenge-chunk-1"
  sampling_percentage = 0
  workspace_id        = "/subscriptions/4885c523-a01c-418f-941b-cab57419ea27/resourceGroups/DefaultResourceGroup-SUK/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-4885c523-a01c-418f-941b-cab57419ea27-SUK"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}

resource "azurerm_monitor_metric_alert" "alert-grp" {
  name                = "Count-alert"
  resource_group_name = azurerm_resource_group.res-0.name
  scopes              = [azurerm_application_insights.res-43.id]
  description         = "Action will be triggered when Failure count is greater than 5."
  severity = 0

  
  criteria {
    metric_namespace = "azure.applicationinsights"
    metric_name = "HttpTrigger3 Count"
    aggregation = "Total"
    operator = "GreaterThan"
    threshold = 50
  }


  action {
    action_group_id = azurerm_monitor_action_group.res-42.id
  }
}


locals {
  cosmosdb_connection_string = join("",["DefaultEndpointsProtocol=https;AccountName=",
   azurerm_cosmosdb_account.res-4.name,
  ";AccountKey=", azurerm_cosmosdb_account.res-4.secondary_key,
   ";TableEndpoint=https://",
   azurerm_cosmosdb_account.res-4.name,
   ".table.cosmos.azure.com:443/;"])
}