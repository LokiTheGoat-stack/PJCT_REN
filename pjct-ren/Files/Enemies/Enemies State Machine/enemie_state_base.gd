extends Node
class_name EnemieStateBase

@onready var controlled_node: Node = self.owner
var state_machine: EnemieStateMachine

#region METHODS
func start():
	pass

func end():
	pass
#endregion

#!!!!!! No tocar nada para que los estados sigan funcionando
