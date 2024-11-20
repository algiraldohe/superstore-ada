locals {
  prefix         = upper("tf")
  warehouse_name = "${local.prefix}_${upper("compute_wh")}_${upper(terraform.workspace)}"
  database_name  = "${local.prefix}_${upper("daverse")}_${upper(terraform.workspace)}"
}