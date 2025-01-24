resource "aws_fsx_windows_file_system" "dring" {
  

  storage_capacity          = 100
  subnet_ids                = [aws_subnet.appstream2_private_2.id]
  throughput_capacity       = 1024
  active_directory_id       = aws_directory_service_directory.dring.id

}