extends Area2D
class_name UpImpulse

@onready var marker: Marker2D = $Mark/Marker2D
@onready var marker_2: Marker2D = $Mark/Marker2D2

var can_interact: bool = false
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Impulse")
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if can_interact:
		if Input.is_action_just_pressed("JUMP"):
			player.impulse(Vector2(0,-1), 1000)
			can_interact = false



func _on_body_entered(body: Node2D) -> void:
	can_interact = true
func _on_body_exited(body: Node2D) -> void:
	can_interact = false
