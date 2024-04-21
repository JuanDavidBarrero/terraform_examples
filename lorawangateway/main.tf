provider "awscc" {
  region = "us-east-1"
}

resource "awscc_iotwireless_wireless_gateway" "my_gateway" {
  name       = "RaspberryLorawanGateway"
  thing_name = "GatewayThing"
  lo_ra_wan = {
    gateway_eui = "9d3edbfffe796ea7"
    rf_region   = "AU915"
  }
}

resource "awscc_iotwireless_device_profile" "my_profile" {
  name = "new_AU915"
  lo_ra_wan = {
    rf_region     = "AU915"
    mac_version   = "1.0.3"
    supports_join = true
  }
}

resource "awscc_iotwireless_service_profile" "my_service" {
  name = "new_service"
  lo_ra_wan = {
    add_gw_metadata = false
  }
}

resource "awscc_iotwireless_destination" "my_destination" {
  expression      = "new_rule_lorawan"
  expression_type = "RuleName"
  name            = "new_destination"
  role_arn        = "xxxxxxxxxxxxxxxxxx" /* set the role arn create one or add one already made */
}

resource "awscc_iotwireless_wireless_device" "my_device" {
  name             = "new_device"
  destination_name = awscc_iotwireless_destination.my_destination.name
  type             = "LoRaWAN"
  lo_ra_wan = {
    dev_eui            = "2b4e8d7a1f3c9e0b"
    device_profile_id  = awscc_iotwireless_device_profile.my_profile.id
    service_profile_id = awscc_iotwireless_service_profile.my_service.id
    otaa_v10_x = {
      app_eui = "f0e1d2c3b4a59687"
      app_key = "8f7e6d5c4b3a2910e2f1d0c9b8a75642"
    }
  }
}
