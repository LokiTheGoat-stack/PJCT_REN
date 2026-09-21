extends PlayerStateBase

@onready var death_menu: DeathMenu = $"../../../DeathMenu"

func start():
	death_menu.visible = true
	death_menu.start()
	


#region ALWAYS_ON_FUNC


#endregion
