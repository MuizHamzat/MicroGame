extends Microgame

@onready var spawnTimer = $SpawnTimer
var enemy_scene: PackedScene = preload("res://microgames/RideOrDie/scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Globals.target_alive = true
	spawnTimer.start()



func _on_player_killed():
	lose_game.emit()
	await get_tree().create_timer(2).timeout
	finish_game.emit()


func _on_prize_collect():
	win_game.emit()
	# Play message
	await get_tree().create_timer(2).timeout
	finish_game.emit()


func _on_spawn_timer_timeout() -> void:
	if Globals.target_alive:
		var enemy_instance = enemy_scene.instantiate()
		add_child(enemy_instance)
	
		#Set a random position for the spawned enemy
		enemy_instance.global_position = Vector2(
			randf() * 640,
			randf() * 360
		)
