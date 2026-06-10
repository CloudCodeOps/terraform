module "dev" {
  source = "../day-9-modules"
  instance_type = "t3.micro"
  name = "dev-instance"
  ami = "ami-00e801948462f718a"
  
}