data "external" "org_membership" {
  program = ["bash", "${path.root}/get_user_organization_membership.sh"]

  query = {
    username = "mkaesz@hashicorp.com" 
  }
}

resource "null_resource" "example" {
  for_each = data.external.org_membership.result
  provisioner "local-exec" {
    command = "echo ${each.value}"
  }
}

output "orgs_of_user" {
  value = [for org in data.external.org_membership.result: org]
}

output "orgs_of_user_2" {
  value = data.external.org_membership.result
}
  
