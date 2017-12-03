import pytest
import paho.mqtt.client as client
import queue

flush_timeout = 0.1


class TestMqttConfig(object):

    def setup_class(self):
        self.queue = queue.Queue()

        def on_connect(client, userdata, rc):
            assert rc == 0
            print("Connected with result code " + str(rc))

        def on_message(client, userdata, msg):
            print("Discarding " + msg.topic + " " + str(msg.payload))

        self.mqtt_host = "localhost"
        self.client_id = "test"
        self.client = client.Client(client_id="test", clean_session=True)
        self.client.on_connect = on_connect
        self.client.on_message = on_message
        self.client.connect(self.mqtt_host, 1883, 60)
        self.client.subscribe("ha/#")
        self.client.loop_start()
        self.set_initial_temperatures(self)

    def teardown(self):
        self.flush()

    def teardown_class(self):
        self.client.loop_stop()

    def watch_topic(self, topic):
        def expect(client, userdata, msg):
            self.queue.put(msg)
            print(msg.topic + " " + str(msg.payload))

        self.client.message_callback_add(topic, expect)
        print("Added callback for %s" % topic)

    def flush(self, timeout=0):
        while True:
            try:
                self.queue.get(timeout=timeout)
            except queue.Empty:
                return

    def wait_message(self, topic, payload, timeout=1, last=False):
        while True:
            try:
                msg = self.queue.get(timeout=timeout)
            except queue.Empty:
                return None

            if msg.topic == topic and msg.payload.decode('utf-8') == payload:
                return msg

    def set_initial_temperatures(self):
        for room in [
            "study/west",
            "annex-hall",
            "bedroom-ros",
            "lounge/east",
            "kitchen",
            "hall/west",
            "hall/east",
            "library",
            "ballroom/east",
            "bedroom-mark/south",
            "bedroom-mark/north",
        ]:
            temperature_topic = "ha/mock/%s/temperature/state" % room
            self.client.publish(temperature_topic, 20)

    @pytest.mark.parametrize("room", [
        "study/west",
        "annex-hall",
        "bedroom-ros",
    ])
    def test_annex_boiler_turns_on(self, room):
        temperature_topic = "ha/mock/%s/temperature/state" % room
        boiler_topic = "ha/annex/heating/command"

        self.watch_topic(boiler_topic)
        self.flush(timeout=flush_timeout)
        self.client.publish(temperature_topic, 3, qos=1)
        assert self.wait_message(boiler_topic, "ON") is not None

        self.client.publish(temperature_topic, 23, qos=1)

    @pytest.mark.parametrize("room", [
        "lounge/east",
        "kitchen",
        #"hall/west",
        #"hall/east",
        "library",
        "ballroom/east",
        "bedroom-mark/south",
        "bedroom-mark/north",
    ])
    def test_main_boiler_turns_on(self, room):
        temperature_topic = "ha/mock/%s/temperature/state" % room
        boiler_topic = "ha/main/heating/command"

        self.watch_topic(boiler_topic)
        self.flush(timeout=flush_timeout)
        self.client.publish(temperature_topic, 3, qos=1)
        assert self.wait_message(boiler_topic, "ON") is not None

        self.client.publish(temperature_topic, 23, qos=1)


if __name__ == '__main__':
    pytest.main()
