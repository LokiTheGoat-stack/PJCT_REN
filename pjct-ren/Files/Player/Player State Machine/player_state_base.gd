extends Node
class_name PlayerStateBase

@onready var controlled_node: CharacterBody2D = self.owner

var state_machine: PlayerStateMachine

#region METHODS
func start():
	pass

func end():
	pass

#endregion
