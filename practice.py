def check_temperature(temp: float) -> str:
    if temp > 70:
        return "Tempeature is too high"
    elif temp < 0:
        return "Temperature is too low"
    else:
        return "Normal tempurature"

sensors = [
    {"name": "Sensor A", "temp": 45.5},
    {"name": "Sensor B", "temp": 75.2},
    {"name": "Sensor C", "temp": -5.0},
]

for sensor in sensors:
    status = check_temperature(sensor["temp"])
    print(f"{sensor['name']}: {sensor['temp']}°C - {status}")


device_list = [
    {"name": "Device 1", "status": True},
    {"name": "Device 2", "status": True},
    {"name": "Device 3", "status": False}
]

for device in device_list:
    status: str =  "On" if device["status"] else "Off"
    print(f"{device["name"]} is {status}")
