## AWS CLI Commands for IoT Operations

### Send Data to Wireless Device
# This command sends data to a wireless device in AWS IoT. Replace placeholders with actual values.

```
aws iotwireless send-data-to-wireless-device \
    --id "963e304fxxxxx" \
    --transmit-mode "1" \
    --payload-data "eyJtc2ciOiJIb2xhIGp1YW4gZGF2aWQifQ==" \
    --output "json" \
    --wireless-metadata "LoRaWAN={FPort=5}"
```


### Publish Message to IoT Core Topic
# This command publishes a message to a specified topic in AWS IoT Core. Replace topic and payload placeholders.

```
aws iot-data publish --topic "topic_name" \
     --payload "Message_content"  \
     --qos 0
```