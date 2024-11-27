extends Microgame

@onready var spawnTimer = $SpawnTimer
@onready var player = $Player

var enemy_scene: PackedScene = preload("res://microgames/RideOrDie/scenes/enemy.tscn")

var screen_size = Vector2(640,360)
var spawn_distance = 50
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
		#Set a random position for the spawned enemy
		var edge = randi() % 4
		var spawn_position = Vector2()
		
		match edge:
			0:	#Bottom
				spawn_position = Vector2(randf()*screen_size.x, screen_size.y+spawn_distance)
			1:	#Right
				spawn_position = Vector2(screen_size.x+spawn_distance, randf()*screen_size.y)
			2: 	#Top
				spawn_position = Vector2(randf()*screen_size.x, -spawn_distance)
			3:	#Left
				spawn_position = Vector2(-spawn_distance, randf()*screen_size.y)
		
		#Create an instance of the enemy scene
		var enemy_instance = enemy_scene.instantiate()
		#Add that scene as a child of the main scene
		add_child(enemy_instance)
		#Set the enemy's set_player() function to take the player's instance as a parameter
		enemy_instance.set_player(player)
		#This will allow the enemy to know of the existence of the player instance
		
		enemy_instance.global_position = spawn_position


func _on_game_over_signal() -> void:
	player.game_over = true
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.game_over = true
