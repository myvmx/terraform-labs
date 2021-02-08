resource "azurerm_resource_group" "webapps"{
    name = "webapps"
    location = var.loc
    tags = var.tags
}
resource "random_string" "webapprnd" {
  length  = 8
  lower   = true
  number  = true
  upper   = false
  special = false
}

resource "azurerm_app_service_plan" "free" {
    name                = "plan-free-${var.webapplocs[count.index]}-${count.index}"
    count = 3
    location            =  var.webapplocs[count.index]
    resource_group_name =  azurerm_resource_group.webapps.name
    tags                =  azurerm_resource_group.webapps.tags

    kind                = "Linux"
    reserved            = true
    sku {
        tier = "Free"
        size = "F1"
    }
}

resource "azurerm_app_service" "citadel" {
    name                = "webapp-${random_string.webapprnd.result}-${var.loc}-${count.index}"
    count = 3
    location            = var.webapplocs[count.index]
    resource_group_name = azurerm_resource_group.webapps.name
    tags                = azurerm_resource_group.webapps.tags

    app_service_plan_id = azurerm_app_service_plan.free[count.index].id
}