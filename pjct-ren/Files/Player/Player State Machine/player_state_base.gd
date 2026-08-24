extends Node
class_name PlayerStateBase

@onready var controlled_node: Node = $"."

var state_machine: PlayerStateMachine

#region METHODS
func start():
	pass

func end():
	pass

#endregion

#!!!!!! No tocar nada para que los estados sigan funcionando
