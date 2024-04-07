### Riscv_Self Watering System

### Aim
In this project, we aim to create a self-watering system . The project measures both the water level sensor and the soil moisture sensor value and runs the system within a certain specified time interval, and the self-watering function is executed. The support circuit uses a water level measurement sensor, a soil moisture measurement sensor, and as an actuator a MOSFET that acts as a switch to activate the motor, and of course the water pump attached to it. 

### Block Diagram

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/c63a7ad4-d126-41f5-82a1-5107f399d9df)


### Flow Diagram

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/74c56cf9-df44-4d82-b893-f6fe540c5900)

### Mode of Operation
Water is fill up into the system depending on the level of moisture and on the current level of water (small chunks of water is applied every time activating the pump actuator (MOSFET) until the desired range is achieved. Some constants are hard-coded in this application but they could be programmable.
After system starts, ADC conversion control signal is set when conversion is done values are read and the soil sensor value is selected. If value read is LOW (Threshold is hard-coded in this app),  the MOSFET switch for the pump motor is activated and pump keeps running for a short period of time (this time is hard-coded in this app), the time will normally depend on size of enclosure and how fast we want to fill it up with water), after that the ADC conversion control signal is set  when conversion is done values for water level is selected and the value is compare to a hard-code range  (MIN-MAX), if value is within the range, we wait for a period of time and start the process again. The same is soil sensor has the correct value system waits for a period of time and the process starts again.

### Requirements

There are different types of sensors that we can use. We can try to select the ones that are easily attached to our RISC-V application. 
For moisture sensor we chose the Stemedu - Capacitive Analog Soil Moisture Sensor Module. Operating Voltage: DC 3.3-5.5V Output Voltage: DC 0-3.0V (this is a very popular sensor that can be use in Arduino applications.

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/f8042204-d710-4e72-9c77-c90486cf70d8)

For water level sensor we chose the ‎DIY-WATER-SENSOR-5 (also compatible with Arduino)
Supply voltage: 3.3 - 5V DC. Current consumption: less than 20mA. Output 0-5v

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/6b1fcd66-9e27-465e-b095-832b80965d83)

Water Pump Motor DC 3.3V - 5V  - Gikfun DC 3V-5V Micro Submersible Mini Water Pump EK1893

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/e52ace2b-9f9b-416d-8999-80f7dea14c70)

For MOSFET, we can use any MOSFET switch to ON/OFF the water pump motor (only needs one control signal)
As the system variables changes are very slow (soil/water level), we can use a slow ADC.  We chose the AD7606C-16 (16-bit 8-channel, 1 msps, parallel ADC Input, Simultaneous sampling ADC).  A bit overkill for this application but did not find another parallel one. We are only using 2 of the 8 inputs. We select the simplest configuration,  setting conversion start (CONVST) the 8 channels simultaneously will start conversion process, monitoring BUSY will determine when conversion is done. 

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/658f698d-0c87-40be-a07d-c7c2d95361b3)


We always do 8 reads (only need 2 are needed and 6 are dummy reads to get the value of all channels)

![image](https://github.com/joses-bot/jose_vdiasat_workshop/assets/83429049/c95d5cc3-3b2d-45af-8d43-e59ed4d5e897)

### Register architecture of x30 for GPIOs
![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/698df51a-73f1-4703-bdf3-64259dd74d4c)



### Code compile and simulation with SPIKE

![image](https://github.com/joses-bot/vsdiat_workshop/assets/83429049/a13e57e3-44b5-4515-a81f-4a4cced075a0)
