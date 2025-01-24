# IMAGE BUILDER APPLICATION ICOBATCH
resource "aws_appstream_image_builder" "icobatch_builder" {
  name          = "terra-Icobatch"
  image_name    = "Image_Name"
  instance_type = "stream.standard.medium"

  vpc_config {
    subnet_ids = [aws_subnet.appstream2_private_2.id]
  }

  tags = {
    Name = "premier image builder"
  }
}

# FLEETS ICOBATCH 
resource "aws_appstream_fleet" "icobatch_fleet" {
  name           = "fleet-icobatch-automate"
  display_name   = "fleet-icobatch-automate"
  instance_type  = "stream.standard.medium"
  image_name     = "Image_Name"

  fleet_type     = "ON_DEMAND"

  vpc_config {
    subnet_ids = [
      aws_subnet.appstream2_public.id,
      aws_subnet.appstream2_private_1.id,
      aws_subnet.appstream2_private_2.id
    ]
  }

  compute_capacity {
    desired_instances = 3
  }
}

# STACKS ICOBATCH 
resource "aws_appstream_stack" "icobatch_stack" {
  name         = "stacks-automatise-icobatch"
  display_name = "stacks-automatise-icobatch"

  storage_connectors {
    connector_type      = "HOMEFOLDERS"
  }

  user_settings {
    action     = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  user_settings {
    action     = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  user_settings {
    action     = "DOMAIN_PASSWORD_SIGNIN"
    permission = "ENABLED"
  }
  user_settings {
    action     = "DOMAIN_SMART_CARD_SIGNIN"
    permission = "DISABLED"
  }
  user_settings {
    action     = "FILE_DOWNLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "FILE_UPLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "PRINTING_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  application_settings {
    enabled        = true
    settings_group = "SettingsGroup"
  }

  tags = {
    TagName = "TagValue"
  }
}

# ASSOCIATE FLEET WITH THE STACKS
resource "aws_appstream_fleet_stack_association" "icobatch_full" {
  fleet_name = aws_appstream_fleet.icobatch_fleet.name
  stack_name = aws_appstream_stack.icobatch_stack.name
}