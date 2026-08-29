extends Node
class_name StateBase

@onready var controlled_node: CharacterBody2D = self.owner

var state_machine: StateMachine

#region METHODS
func start():
	pass

func end():
	pass

#endregion
