# tf_ext_ds_user_org_membership
This repo shows how to make the organizations a user is a member of available to the Terraform code and continue working with them.

The example uses an external data source. The shell script gets called during Terraform apply.

Please also see the notes in the script.

Here is the outline:

My user mkaesz@hashicorp.com is in two organizations. When I execute 'terraform apply', the shell script calls the TFE admin/users endpoint with the username as parameter. The username is provided from within Terraform (but could also come from somewhere else as part of the script). The script return a JSON map (required by Terraform) with string values. The example then uses the returned map and executed a local-exec from within a null_resource (just for illustration). The output then shows that the local-exec gets executed two times - once per organization which I am a member of.

Output of execution:

'''mkaesz@hashicorp ~/w/t/e/user_membership> terraform apply
data.external.org_membership: Refreshing state...

data "external" "org_membership" {
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.example["msk"] will be created
  + resource "null_resource" "example" {
      + id = (known after apply)
    }

  # null_resource.example["msk2"] will be created
  + resource "null_resource" "example" {
      + id = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

null_resource.example["msk"]: Creating...
null_resource.example["msk2"]: Creating...
null_resource.example["msk"]: Provisioning with 'local-exec'...
null_resource.example["msk2"]: Provisioning with 'local-exec'...
null_resource.example["msk2"] (local-exec): Executing: ["/bin/sh" "-c" "echo msk2"]
null_resource.example["msk"] (local-exec): Executing: ["/bin/sh" "-c" "echo msk"]
null_resource.example["msk2"] (local-exec): msk2
null_resource.example["msk"] (local-exec): msk
null_resource.example["msk"]: Creation complete after 0s [id=7797757597600513696]
null_resource.example["msk2"]: Creation complete after 0s [id=6745800050653526708]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

orgs_of_user = [
  "msk",
  "msk2",
]
orgs_of_user_2 = {
  "msk" = "msk"
  "msk2" = "msk2"
}
'''
