variable "ami_id" {
    description = "The ID of the AMI to use for the EC2 instance." #optional
    type        = string
    default = ""
    
}

variable "instance_type" {
    description = "The type of instance to use for the EC2 instance." #optional
    type        = string
    default = ""
  
  }

variable "name" {
    description = "The name of the EC2 instance." #optional
    type        = string
    default = ""
 
  }