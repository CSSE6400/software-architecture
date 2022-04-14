resource "aws_instance" "hello-server" {
    ami = "ami-04902260ca3d33422"
    instance_type = "t2.micro"
    
    user_data = file("./setup.sh")
    
    security_groups = [
        aws_security_group.hello-server.name
    ]
    
    tags = {
        Name = "hello-server"
    }
}