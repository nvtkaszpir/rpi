#!/bin/bash
#shows the speed of the I2C device
var="$(xxd -ps /sys/class/i2c-adapter/i2c-1/of_node/clock-frequency)"
var=${var//[[:blank:].\}]/}
printf "%d\\n" "0x${var}"
