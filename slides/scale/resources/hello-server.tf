resource "aws_instance" "hello-server" {
    ami = "ami-04902260ca3d33422"
    instance_type = "t2.micro"
    
    user_data = file("${path.module}/setup.sh")
    
    associate_public_ip_address = true
    subnet_id = module.network.subnets[0].public.id
    vpc_security_group_ids = [
        module.network.http-port.id
    ]
    
    tags = {
        Name = "hello-server"
    }
}