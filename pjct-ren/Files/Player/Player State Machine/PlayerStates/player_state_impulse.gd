extends PlayerStateBase

var timer: float
var impulse_time: float = 0.5
var impulse: bool = false
var can_move: bool = false
var node_position: Vector2
var inicial_direction: Vector2
var impulse_velocity

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#mover al personaje al centro del impulso
	if can_move:
		inicial_direction = (node_position - controlled_node.global_position).normalized()
		controlled_node.velocity = inicial_direction * 500
	#verificar que el jugador esta en el centro
	if (node_position - controlled_node.global_position).length() < 5:
		can_move = false
		impulse = true
	
	
	#mover al jugador en la direccion del impulso
	if impulse:
		controlled_node.velocity = impulse_velocity
		#print(str(controlled_node.velocity))
	
	
	#si se termino el impulso cambiar a fall
	if impulse: timer -= delta
	if impulse and timer <= 0:
		impulse = false
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
	
	controlled_node.move_and_slide()

#endregion

func start_impulse(direction:Vector2,speed:float,node):
	#parametros iniciales al hacer el impulso
	controlled_node.velocity = Vector2.ZERO
	node_position = node.global_position
	impulse_velocity = direction * speed
	timer = impulse_time
	can_move = true
