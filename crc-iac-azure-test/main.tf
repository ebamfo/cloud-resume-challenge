terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#Generate random integer for each deployment
resource "random_integer" "ri" {
  min = 1
  max = 50000
}

resource "azurerm_resource_group" "crc-test-rg" {
  name     = "rg-crc-test${random_integer.ri.result}"
  location = "uksouth"

  depends_on = [random_integer.ri]
}

##COSMOSDB SECTION FOR VIEWCOUNT

resource "azurerm_cosmosdb_account" "db-acc" {
  location            = azurerm_resource_group.crc-test-rg.location
  name                = "cosmos-table-pers-test${random_integer.ri.result}"
  offer_type          = "Standard"
  resource_group_name = azurerm_resource_group.crc-test-rg.name

  tags = {
    defaultExperience       = "Azure Table"
    hidden-cosmos-mmspecial = ""
  }
  consistency_policy {
    consistency_level = "BoundedStaleness"
  }
  geo_location {
    failover_priority = 0
    location          = azurerm_resource_group.crc-test-rg.location
  }
  capabilities {
    name = "EnableTable"
  }
  capabilities {
    name =  "EnableServerless"
  }
  depends_on = [
    azurerm_resource_group.crc-test-rg,
  ]
}

resource "azurerm_cosmosdb_table" "db-acc-table" {
  name                = "ViewsCounter"
  resource_group_name = azurerm_resource_group.crc-test-rg.name
  account_name        = azurerm_cosmosdb_account.db-acc.name

  depends_on = [azurerm_cosmosdb_account.db-acc]
}

##STORAGE FOR FUNCTION APP

resource "azurerm_storage_account" "strg-crc-test" {
  name                     = "ebamfo9x${random_integer.ri.result}"
  location                 = azurerm_resource_group.crc-test-rg.location
  resource_group_name      = azurerm_resource_group.crc-test-rg.name
  account_replication_type = "LRS"
  account_tier             = "Standard"

  static_website {
    error_404_document = "error.html"
    index_document     = "resume.html"
  }
}

resource "azurerm_storage_container" "strg-crc-code" {
  name = "strg-cont01"
  storage_account_name = azurerm_storage_account.strg-crc-test.name
  container_access_type = "container"
}

##FUNCTION APP SECTION##

resource "azurerm_service_plan" "serv_plan-crc-test-01" {
  location            = azurerm_resource_group.crc-test-rg.location
  name                = "ASP-crc-test"
  resource_group_name = azurerm_resource_group.crc-test-rg.name
  os_type             = "Linux"
  sku_name            = "Y1"

  depends_on = [azurerm_resource_group.crc-test-rg]
}

resource "azurerm_linux_function_app" "funcapp-crc-test-01" {
  name                 = "funcapp-crc-test${random_integer.ri.result}"
  resource_group_name  = azurerm_resource_group.crc-test-rg.name
  storage_account_name = azurerm_storage_account.strg-crc-test.name
  location             = azurerm_resource_group.crc-test-rg.location
  https_only           = true

  storage_account_access_key = azurerm_storage_account.strg-crc-test.primary_access_key
  service_plan_id            = azurerm_service_plan.serv_plan-crc-test-01.id

  app_settings = {
    CosmosDBConnectionString1 = local.cosmosdb_connection_strings[0]
    WEBSITE_RUN_FROM_PACKAGE  = local.package_url
    SCM_DO_BUILD_DURING_DEPLOYMENT=true
    ENABLE_ORYX_BUILD=true
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.application_insights.connection_string
    application_insights_key               = azurerm_application_insights.application_insights.instrumentation_key

    cors {
      allowed_origins = ["*","https://portal.azure.com"]
    }
    application_stack {
      python_version = "3.9"
    }
  }
}


##CDN SECTION##

resource "azurerm_cdn_profile" "cdn-profile-crc-test-01" {
  name                = "cdn-profile${random_integer.ri.result}"
  location            = "global"
  resource_group_name = azurerm_resource_group.crc-test-rg.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "cdn-endpoint-crc-test" {
  name                = "ebamfo-crc-endpnt${random_integer.ri.result}"
  profile_name        = azurerm_cdn_profile.cdn-profile-crc-test-01.name
  location            = "global"
  resource_group_name = azurerm_resource_group.crc-test-rg.name

  origin {
    name      = "cdn-name${random_integer.ri.result}"
    host_name = azurerm_storage_account.strg-crc-test.primary_web_host
  }

  depends_on = [azurerm_cdn_profile.cdn-profile-crc-test-01]
}

resource "azurerm_application_insights" "application_insights" {
  name                = "application-insights"
  location            = azurerm_resource_group.crc-test-rg.location
  resource_group_name = azurerm_resource_group.crc-test-rg.name
  application_type    = "other"
}



locals {
  cosmosdb_connection_strings = azurerm_cosmosdb_account.db-acc.connection_strings
  package_url = join("",[azurerm_storage_account.strg-crc-test.primary_blob_endpoint, azurerm_storage_container.strg-crc-code.name,"/crc_code_test.zip"])
}


