resource "aws_directory_service_directory" "dring" {
    
  name                       = "sucess.com"
  password                   = "Sososososo93!"
  edition                    = "Standard"
  type                       = "MicrosoftAD"
  vpc_settings {
    vpc_id                   = aws_vpc.appstream2.id
    subnet_ids               = [ aws_subnet.appstream2_public.id, aws_subnet.appstream2_private_2.id]
  }
} 