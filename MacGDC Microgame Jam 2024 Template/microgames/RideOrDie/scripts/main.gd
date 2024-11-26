extends Microgame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()



func _on_player_killed() -> void:
	lose_game.emit()
