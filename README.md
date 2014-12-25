# Terraform bug

## The template

    resource "aws_route_table" "private" {
      vpc_id = "${aws_vpc.default.id}"
      route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
      }
      route {
        cidr_block = "10.0.0.0/16"
        gateway_id = "pcx-abcd"
      }
      tags { Name = "${concat(\"rtb-private-\",var.region_name)}" }
    }

## Apply

    $ terraform apply

Updates ```terraform.tfstate``` with the below:

    "aws_route_table.private": {
        "type": "aws_route_table",
        "depends_on": [
            "aws_vpc.default",
            "aws_instance.nat"
        ],
        "primary": {
            "id": "rtb-cfd9b9aa",
            "attributes": {
                "id": "rtb-cfd9b9aa",
                "route.#": "2",
                "route.1790308496.cidr_block": "10.0.0.0/16",
                "route.3119882668.cidr_block": "0.0.0.0/0",
                "route.3119882668.instance_id": "i-460975aa",
                "tags.Name": "rtb-private-virginia",
                "vpc_id": "vpc-abc"
            }
        }
    }

## Refresh

      $ terraform refresh

No Updates ```terraform.tfstate```, it remains:

      "aws_route_table.private": {
          "type": "aws_route_table",
          "depends_on": [
              "aws_vpc.default",
              "aws_instance.nat"
          ],
          "primary": {
              "id": "rtb-cfd9b9aa",
              "attributes": {
                  "id": "rtb-cfd9b9aa",
                  "route.#": "2",
                  "route.1790308496.cidr_block": "10.0.0.0/16",
                  "route.3119882668.cidr_block": "0.0.0.0/0",
                  "route.3119882668.instance_id": "i-460975aa",
                  "tags.Name": "rtb-private-virginia",
                  "vpc_id": "vpc-abc"
              }
          }
      },

## Plan

Plan suggests modifications, even though there are no modifications

    $ terraform plan -module-depth=1

    ...
    ~ module.primary-services.aws_route_table.private
    route.3810732900.cidr_block:  "" => "0.0.0.0/0"
    route.3810732900.gateway_id:  "" => ""
    route.3810732900.instance_id: "" => "i-460975aa"
    route.3996912366.cidr_block:  "" => "10.0.0.0/16"
    route.3996912366.gateway_id:  "" => "pcx-abcd"
    route.3996912366.instance_id: "" => ""

The state file remains the same

## Apply

Apply makes the updates

    $ terraform apply

    ...
    module.primary-services.aws_route_table.private: Modifying...
      route.3810732900.cidr_block:  "" => "0.0.0.0/0"
      route.3810732900.gateway_id:  "" => ""
      route.3810732900.instance_id: "" => "i-460975aa"
      route.3996912366.cidr_block:  "" => "10.0.0.0/16"
      route.3996912366.gateway_id:  "" => "pcx-abcd"
      route.3996912366.instance_id: "" => ""
    module.primary-services.aws_route_table.private: Modifications complete
    ...


```terraform.tfstate``` updated with below:

    "aws_route_table.private": {
        "type": "aws_route_table",
        "depends_on": [
            "aws_vpc.default",
            "aws_instance.nat"
        ],
        "primary": {
            "id": "rtb-cfd9b9aa",
            "attributes": {
                "id": "rtb-cfd9b9aa",
                "route.#": "4",
                "route.1790308496.cidr_block": "10.0.0.0/16",
                "route.3119882668.cidr_block": "0.0.0.0/0",
                "route.3119882668.instance_id": "i-460975aa",
                "route.3810732900.cidr_block": "0.0.0.0/0",
                "route.3810732900.gateway_id": "",
                "route.3810732900.instance_id": "i-460975aa",
                "route.3996912366.cidr_block": "10.0.0.0/16",
                "route.3996912366.gateway_id": "pcx-abcd",
                "route.3996912366.instance_id": "",
                "tags.Name": "rtb-private-virginia",
                "vpc_id": "vpc-abc"
            }
        }
    }
