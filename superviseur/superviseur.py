import paho.mqtt.client as mqtt

# Seuil
SEUIL = 28

# Fonction appelée lors de la connexion au broker
def on_connect(client, userdata, flags, reason_code, properties):
    print("Superviseur connecté au broker MQTT", flush=True)
    print(f"Seuil d'alerte : {SEUIL} °C", flush=True)
    client.subscribe("immeuble/#")

# Fonction appelée à chaque message reçu
def on_message(client, userdata, msg):

    # Récupérer le nom de la salle
    salle = msg.topic.split("/")[1]

    # Récupérer la température
    temperature = float(msg.payload.decode())

    # Afficher la mesure
    print(f"{salle} : {temperature} °C", flush=True)

    # Vérifier le seuil
    if temperature > SEUIL:
        print(f"ALERTE : température trop élevée dans {salle} !", flush=True)

# Création du client MQTT
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

# Association des fonctions
client.on_connect = on_connect
client.on_message = on_message

# Connexion au broker
client.connect("broker", 1883)

# Attendre et traiter les messages
client.loop_forever()