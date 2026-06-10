variable "ami" {
    description = "The AMI to use for the instance"
    type = string
}   

variable "instance_type" {
    description = "The type of instance to use"
    type = string
}

variable "name" {
    description = "The name of the instance"
    type = string
    default = ""
}

variable "tags" {
    description = "The tags to apply to the instance"
    type = map(string)
    default = {}
}
