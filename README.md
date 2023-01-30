## RDS Project
### Overview
This project uses Terraform to create and configure an Amazon RDS (Relational Database Service). It uses the RDS module created in the `modules/rds/` directory. The RDS is created in a VPC which is created using an AWS community supported VPC module. The RDS has the following specifications:
* Multi-AZ (availability zone) for high availability. In case of an infrastructure failure, Amazon RDS performs an automatic failover to the standby DB instance.
* The RDS instance is deployed in the private subnets for security.
* Uses a MySQL database engine.
* Secret management for database credentials(master username and password) with AWS Secret Manager.
* Uses 'io1' storage type to provide high durability and low latency storage.
* Provisioned IOPS to improve I/O performance.

Additionally, the code creates:
* An EC2 instance to act as a NAT (Network Address Translation) gateway for accessing the RDS from the public.
* An Elastic IP address for the NAT EC2 instance.
* A security group for the RDS instance, allowing traffic from the NAT EC2 instance.
* A security group for the NAT EC2 instance.


----
### Improvement and Reccommendations

* I used the VPC module from the Terraform registry due to time constraints. I will improve this by creating the VPC module from scratch. Doing this allows for customization, security, maintainability, and reusability, as opposed to using modules from the registry where you have limited control.

* Instead of saving the Terraform state locally, I would setup a remote backend storage using AWS S3 and Dynamo DB. This will store the Terraform project state in a S3 bucket and ensure state locking and consistency especially if multiple people are working on the project.

* Since it is an e-commerce website(considered read-intensive for databases, because of frequent reads of product information, customer data, and order history to display on the website), I will create a RDS replica(or more as required) to improve availability. More importantly, read-only traffic can be redirected to the replica(s) to offload the primary instance and improve performance. The RDS module covers for this edge case.


### How to Use
##### Requirements:
Before running this project, you should have Terraform CLI(1.1.7+) and AWS CLI installed.
* Update `terraform.tfvars` with the required variables.
* Add the required secrets(master username and password) to Secret Manager.
* Then `export` your IAM credentials to authenticate the Terraform AWS provider:

```
export AWS_ACCESS_KEY_ID=x
```
```
export AWS_SECRET_ACCESS_KEY=x
```

From the root directory, initialize and apply the project:
```
terraform init
```
```
terraform apply
```
