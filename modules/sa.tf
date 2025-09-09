

locals {
  sas = {
    for k, v in try(var.foundation.sas, {}) : k => merge(
      {
        # overrideable defaults
        contaioners          = {}
        location             = local.default_resource_group.location
        resource_group_name  = local.default_resource_group.name
        dns_servers          = []
      },
      v
    )
  }

  containers = {
    for entry in flatten([
      for sa_key, sa_data in local.sas : [
        for container_key, container_data in sa_data.containers :
        merge(
          {
            sa                                             = sa_key
            container                                      = container_key
          },
          container_data,
          {
            storage_account_id = azurerm_storage_account.sas[sa_key].id
          }
        )
      ]
    ]) : "${entry.sa}-${entry.container}" => entry
  }
}

resource "azurerm_storage_account" "sas" {
  for_each = local.sas
  
  name                     = each.key
  location                 = each.value.location
  resource_group_name      = data.azurerm_resource_group.resource_group[each.value.resource_group_name].name
  access_tier              = each.value.access_tier
  account_kind             = each.value.account_kind
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  is_hns_enabled           = each.value.storage_is_hns_enabled
  network_rules {
    default_action             = each.value.network_rules.default_action
    ip_rules                   = each.value.network_rules.ip_rules
    virtual_network_subnet_ids = each.value.network_rules.virtual_network_subnet_ids
  }
identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_container" "containers" {
  for_each = local.containers

  name                          = each.value.container
  storage_account_id            = each.value.storage_account_id
  container_access_type         = each.value.container_access_type
}

output "sas_output" {
  value = local.sas
}

output "containers_output" {
  value = local.containers
}