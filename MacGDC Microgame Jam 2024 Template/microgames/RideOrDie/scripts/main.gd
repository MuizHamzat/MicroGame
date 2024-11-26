extends Microgame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Globals.target_alive = true


func _on_player_killed():
	lose_game.emit()
	await get_tree().create_timer(2).timeout
	finish_game.emit()


func _on_prize_collect():
	win_game.emit()
	# Play message
	await get_tree().create_timer(2).timeout
	finish_game.emit()
