AWS Cloudformation examples

This folder contains AWS Cloudformation templates.

"create_network_stack.yaml" template creates the following resources:
 - VPC
 - 2 Public Subnets
 - 2 Private Subnets
 - Internet Gatewey
 - Routing Table with default Route
 - Security Group
 - 2 VMs (first in PublicSubnetA, second in PublicSubnetB)


To deploy network stack along with simple SG and 2 VMs the following command needs to be issued:

"aws cloudformation create-stack --stack-name NetStack --template-body file://create_network_stack.yaml"

To modify NetStack (only 1 entry in SG is changed the following command needs to be issued)

"aws cloudformation update-stack --stack-name NetStack --template-body file://modify_network_stack.yaml"

