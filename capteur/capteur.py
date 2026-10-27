import os
import time
import random
import paho.mqtt.client as mqtt

# Récupérer le nom de la salle
salle = os.getenv("SALLE", "bureau-101")

# Définir le topic MQTT
topic = f"immeuble/{salle}/temperature"

# Créer le client MQTT
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

# Se connecter au broker
client.connect("broker", 1883)
client.loop_start()

# Simuler les températures
while True:
    temperature = random.uniform(21, 24)

    # Simuler parfois une température trop élevée
    if random.randint(1, 7) == 1:
        temperature += random.uniform(8, 10)

    temperature = round(temperature, 1)

    # Envoyer la température au broker
    client.publish(topic, str(temperature))

    # Afficher la mesure
    print(f"{salle} : {temperature} °C", flush=True)

    # Attendre 3 secondes
    time.sleep(3)