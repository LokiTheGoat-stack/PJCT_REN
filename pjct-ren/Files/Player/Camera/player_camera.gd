extends Camera2D

var trauma: float = 0.0
var trauma_power: float = 1.0
var trauma_decay: float = 0.9

var noise: FastNoiseLite
var noise_y: float = 0.0
var noise_x: float = 0.0

var shake_intensity: float = 40.0 
var shake_speed: float = 30.0

func _ready():
	GlobalParameters.player_camera = self
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 1.0

func _process(delta):
	# Decaer el trauma con el tiempo
	if trauma > 0:
		trauma = max(trauma - trauma_decay * delta, 0)
		
		# Calcular la intensidad del shake (efecto "scream")
		var intensity = get_shake_intensity()
		
		# Aplicar el temblor a la cámara usando offset
		if intensity > 0.1:
			noise_y += delta * shake_speed
			noise_x += delta * shake_speed * 0.7  # Offset para movimiento más natural
			
			var shake_x = noise.get_noise_2d(1, noise_y) * intensity
			var shake_y = noise.get_noise_2d(2, noise_x) * intensity
			
			offset = Vector2(shake_x, shake_y)
		else:
			# Volver a la posición normal
			offset = Vector2.ZERO
	else:
		offset = Vector2.ZERO

# Función para calcular la intensidad final del shake
func get_shake_intensity() -> float:
	# El cuadrado hace que los temblores fuertes sean MUY fuertes (efecto scream)
	return shake_intensity * pow(trauma, trauma_power)

func apply_trauma(amount: float, decay:float):
	trauma = min(trauma + amount, 1.0)
	trauma_decay = decay
	
	noise.seed = randi()
	noise_y = 0.0
	noise_x = 0.0
