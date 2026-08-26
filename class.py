class Sensor:
    def __init__(self, name: str, temperature: int = 0):
        self.name = name
        self.temperature = temperature

    def check_status(self) :
        status = "warning" if self.temperature > 70 else "normal"
        print(f"Status: {status}")
    
    def update_temperature(self, new_temp: int):
        self.temperature = new_temp
        print(f"Update new temperature ({self.temperature}) for sensor {self.name}")

sensor1 = Sensor("Sensor 1", 20)
sensor1.check_status()
sensor1.update_temperature(80)
sensor1.check_status