extends Microgame

@onready var spawnTimer = $SpawnTimer
@onready var player = $Player
var enemy_scene: PackedScene = preload("res://microgames/RideOrDie/scenes/enemy.tscn")

var game_over = false

signal game_over_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	spawnTimer.start()


func _on_prize_collect():
	win_game.emit()
	game_over = true
	game_over_signal.emit()
	# Play message
	await get_tree().create_timer(2).timeout
	finish_game.emit()


func _on_player_player_death():
	lose_game.emit()
	game_over = true
	game_over_signal.emit()
	await get_tree().create_timer(2).timeout
	finish_game.emit()


func _on_spawn_timer_timeout() -> void:
	if not game_over:
		#Create an instance of the enemy scene
		var enemy_instance = enemy_scene.instantiate()
		#Add that scene as a child of the main scene
		add_child(enemy_instance)
		#Set the enemy's set_player() function to take the player's instance as a parameter
		enemy_instance.set_player(player)
		#This will allow the enemy to know of the existence of the player instance
	
		#Set a random position for the spawned enemy
		enemy_instance.global_position = Vector2(
			randf() * 640,
			randf() * 360
		)


func _on_game_over_signal() -> void:
	player.game_over = true
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.game_over = true
