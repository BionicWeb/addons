#!/usr/bin/env bashio

DEVICE="$(bashio::config 'device')"
RUN_INTERVAL="$(bashio::config 'run_interval')"
AMPERAGE_FACTOR="$(bashio::config 'amperage_factor')"
WATT_FACTOR="$(bashio::config 'watt_factor')"
QPIRI="$(bashio::config 'qpiri')"
QPIWS="$(bashio::config 'qpiws')"
QMOD="$(bashio::config 'qmod')"
QPIGS="$(bashio::config 'qpigs')"

if ! bashio::services.available "mqtt"; then
    bashio::log.error "No internal MQTT service found"
    bashio::exit.nok "Please install an MQTT addon like mosquitto!"
else
    bashio::log.info "MQTT service found, fetching credentials ..."
    MQTT_HOST=$(bashio::services mqtt "host")
    MQTT_PORT=$(bashio::services mqtt "port")
    MQTT_USER=$(bashio::services mqtt "username")
    MQTT_PASSWORD=$(bashio::services mqtt "password")
    bashio::log.info "${MQTT_HOST}"
    bashio::log.info "${MQTT_PORT}"
    bashio::log.info "${MQTT_USER}"
    bashio::log.info "${MQTT_PASSWORD}"

    echo "{"                                    >  /etc/inverter/mqtt.json
    echo "  \"server\": \"$MQTT_HOST\","        >> /etc/inverter/mqtt.json
    echo "  \"port\": \"$MQTT_PORT\","          >> /etc/inverter/mqtt.json
    echo "  \"topic\": \"homeassistant\","      >> /etc/inverter/mqtt.json
    echo "  \"devicename\": \"voltronic\","     >> /etc/inverter/mqtt.json
    echo "  \"username\": \"$MQTT_USER\","      >> /etc/inverter/mqtt.json
    echo "  \"password\": \"$MQTT_PASSWORD\""   >> /etc/inverter/mqtt.json
    echo "}"                                    >> /etc/inverter/mqtt.json
fi

if bashio::config.has_value 'device'; then
    DEVICE="$(bashio::config 'device')"
else
    DEVICE="/dev/hidraw0"
fi

if bashio::config.has_value 'run_interval'; then
    RUN_INTERVAL="$(bashio::config 'run_interval')"
else
    RUN_INTERVAL=120
fi

if bashio::config.has_value 'amperage_factor'; then
    AMPERAGE_FACTOR="$(bashio::config 'amperage_factor')"
else
    AMPERAGE_FACTOR=1.0
fi

if bashio::config.has_value 'watt_factor'; then
    WATT_FACTOR="$(bashio::config 'watt_factor')"
else
    WATT_FACTOR=1.01
fi

if bashio::config.has_value 'qpiri'; then
    QPIRI="$(bashio::config 'qpiri')"
else
    QPIRI=104
fi

if bashio::config.has_value 'qpiws'; then
    QPIWS="$(bashio::config 'qpiws')"
else
    QPIWS=40
fi

if bashio::config.has_value 'qmod'; then
    QMOD="$(bashio::config 'qmod')"
else
    QMOD=5
fi
if bashio::config.has_value 'qpigs'; then
    QPIGS="$(bashio::config 'qpigs')"
else
    QPIGS=110
fi

echo "device=$DEVICE"                       >  /etc/inverter/inverter.conf
echo "run_interval=$RUN_INTERVAL"           >> /etc/inverter/inverter.conf
echo "amperage_factor=$AMPERAGE_FACTOR"     >> /etc/inverter/inverter.conf
echo "watt_factor=$WATT_FACTOR"             >> /etc/inverter/inverter.conf
echo "qpiri=$QPIRI"                         >> /etc/inverter/inverter.conf
echo "qpiws=$QPIWS"                         >> /etc/inverter/inverter.conf
echo "qmod=$QMOD"                           >> /etc/inverter/inverter.conf
echo "qpigs=$QPIGS"                         >> /etc/inverter/inverter.conf