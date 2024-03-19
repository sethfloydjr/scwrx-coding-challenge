# SCWRX Coding Challenge
___

## SUMMARY:

This project is not 100% complete and not how I wanted to leave things. A few things that were left off due to time constraints were:
* Automated way of updating the app and rolling the deployment out to the EKS cluster
* There was an issue with the app not being served with HTTPS that I would have liked to fix. I feel like that is either a kube load balancer setting or possibly a setting in the EKS_Node_Group settings.
* On any other project there would need to be logging and monitoring stood up as well.
* There should also be a linting and test step for the application

Ultimately this project is not complete but to be fair I didn't have the time I would have liked to tackle something like this that involved tools and tech that I was not familiar with. I had never even seen a Flask app until this project and I had never spun up a Kubernetes cluster with Terraform, much less a EKS cluster in AWS. Although not complete I'm still pretty happy with this exercise because I learned a ton in a very short amount of time.

For the record I did get this all working but not to what I would consider "production ready".

This project was originally written to run with GitLab's CI/CD but could easily be run with GitHub Actions as well.

---

## INSTRUCTIONS:

* "Deploy this flask app and make it production-ready - Make reasonable assumptions"

---

## ASSUMPTIONS:
* There is a "terraform only" user in this AWS account that has access to create whatever infra it needs. It only builds infra and is not used for any service related actions and does not have console access.

* The infra is built using Terraform version `0.12.26`

* The `gitlab-ci.yml` file has been mis-named on purpose to prevent the pipelines from running. To reenable you would rename with a `.` at the beginning of the file name.

___

## TERRAFORM WALKTHROUGH:
This covers a few of the files that contain spec for the infrastructure code built by Terraform.

### - cluster.tf -
This holds the code that builds the actual cluster along with the node group which is the Auto Scaling Group of the cluster.

### - iam.tf -
Role and role policy attachments for the cluster

### - security_groups.tf -
Security groups that filter network access to the instances.

### - user.tf -
A 'service' user created for performing strictly on EKS related functions.

### - vpc.tf -
A module to build the VPC that the cluster will use solely for itself. Should there be other infra or services that would need to go in this account then the would have their own VPC and connect as needed through vpc peering.

### - versions.tf -
This file is used to maintain what version is allowed to build and test the infrastructure in terraform. It is NOT related to the version that is used in Gitlab pipeline to pull the terraform docker image. This version makes sure that everyone who checks this code out, stays on the same version locally as well as what is used across the board in this project.


---

## GITLAB-CI WALKTHROUGH:

### ENVIRONMENT VARIABLES:
The following env vars will need to be added to your Gitlab Project under Settings > CI/CD > Variables
* `DOCKER_PWORD` - Your Docker hub password. - Make sure `mask variable` is checked.
* `DOCKER_UNAME` - Your Docker Hub username. - Make sure `mask variable` is checked.
* `TERRAFORM_VERSION` - The version of Terraform docker image that you want to pull for building the infrastructure in.
* `TF_VAR_AWS_ACCESS_KEY_ID` - Your AWS access key for the user that has access to build the infrastructure using terraform.
* `TF_VAR_AWS_SECRET_ACCESS_KEY` - The accompanying secret key for your user to build the infrastructure using terraform.

### .GITLAB-CI.YML:

* The gitlab pipeline uses the `Docker:stable` image as its base container to run the rest of the steps within itself.
* The "Docker In Docker" service is enabled to be able to run other containers for various steps within this same build job.
* Variables are declared and a path for cache is defined. This is where the output of a `terraform plan` will be placed. I specifically do not add the AWS keys variables here. Although you end up having a couple of extra lines in each script section that uses them it also makes the AWS related commands shorter and easier to read.
* `.tf_setup: &tf_image` is a setting that is passed to the Terraform steps so that the specific version of the Hashicorp Terraform container can be used. It provides the entry point as well.
* The stages are declared. I specifically "spread out" the stages so that when you are looking at the pipeline in Gitlab it is easier to see the order of builds rather than letting them run in no particular order.
* The Terraform steps are declared. Validate and Plan will run on every push to make sure there are no surprise infrastructure changes that might happen. The Apply step is set to be only run on the Master branch and can only be manually applied. This prevents unintentional changes being applied.
* Finally, the Docker stage builds a new Docker image and pushes it to docker hub where the EKS cluster can pull it from. It is only run if there are changes to any files within the `application/` directory and will only run on the Master branch.


---

## POST CLUSTER STANDUP:
The following are steps to finalize your settings locally and have the ability to connect to the cluster using `kubectl`.

* Create your kubeconfig file. By default it will be stored in `~/.kube/config`
`AWS_PROFILE=terraform aws eks --region <region> update-kubeconfig --name <name_of_cluster>`

You would gather the URL for your load balancer by using the following command:
* `kubectl get svc` which will give you soemthing similar to this `a042e3ffd22e14a67967349c47de93fb-635537038.us-east-1.elb.amazonaws.com`

For this particular application you would add the port to the end of the URL... `:5000`


---

## PRODUCTION DEPLOYMENT PROCEDURE:
1. Make a change to /application/flaskapp/
2. From here you would push your change and merge to master branch once it was peer reviewed, approved, and there are not any other unexpected changes that would be applied to the Terraform.
3. There is a build step in the .gitlab-ci file that would set up a container to connect to the EKS cluster, auth to it and follow these steps to deploy the new version of the application:
* `kubectl scale --replicas=2 deployment setheryops-flaskapp-deploy`
* `kubectl delete pod <name of oldest pod>`
* `kubectl scale --replicas=1 deployment setheryops-flaskapp-deploy`
* From here if you refresh your browser you will see your new change reflected.
