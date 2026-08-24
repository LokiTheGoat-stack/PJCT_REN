extends Node
class_name PlayerStateMachine

@onready var controlled_node: Node = $".."
@export var default_state: PlayerStateBase

var current_state: PlayerStateBase = null

func _ready() -> void:
	call_deferred("default_state_start")

# STATE_CONTROL se encarga de los cambios de estado
#region STATE_CONTROL
func default_state_start() -> void:
	current_state = default_state
	state_start()

func state_start() -> void:
	current_state.controlled_node = controlled_node
	current_state.state_machine = self
	current_state.start()

func change_to(new_state:String) -> void:
	if current_state and current_state.has_method("end"): current_state.end()
	current_state = get_node(new_state)
	state_start()
#endregion

# AUTOMATIC_METHODS controla las funsiones prosses, input y sus variantes de current_state
#region AUTOMATIC_METHODS
func _process(delta: float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(delta)

func _input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input(event)

func _unhandled_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"):
		current_state.on_unhandled_input(event)

func _unhandled_key_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_key_input"):
		current_state.on_unhandled_key_input(event)
#endregion

#!!!!!! No tocar nada para que los estados sigan funcionando
