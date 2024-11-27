extends Microgame

@onready var gameTimer = $GameTimer
@onready var spawnTimer = $SpawnTimer
@onready var player = $Player

var enemy_scene: PackedScene = preload("res://microgames/RideOrDie/scenes/enemy.tscn")
var gold_enemy_scene: PackedScene = preload("res://microgames/RideOrDie/scenes/goldEnemy.tscn")

var game_over = false
var gold_spawned = false
@export var min_gold_chance = 0
@export var max_gold_chance = 1
@export var gold_spawn_start = 7.0
@export var gold_spawn_guaranteed = 3.0
var screen_size = Vector2(640,360)
var spawn_distance = 50
var enemy_count = 0
var enemy_spawn_cap = 30


signal game_over_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	gameTimer.start()
	spawnTimer.start()



func _on_player_gold_killed() -> void:
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


func _on_spawn_timer_timeout():
	if not game_over and enemy_count < enemy_spawn_cap:
		#Set a random position for the spawned enemy
		#Pick an edge of the screen for the enemy to spawn
		var edge = randi() % 2 #0=Bottom, 1=Right, 2=Top, 3=Left
		var spawn_position = Vector2()
		
		#Set the spawn position based off the value of edge
		match edge:
			#0:	#Bottom
				#spawn_position = Vector2(randf()*screen_size.x, screen_size.y+spawn_distance)
			0:	#Right
				spawn_position = Vector2(screen_size.x+spawn_distance, randf()*200 + 160) #screen_size.y
			#2: 	#Top
				#spawn_position = Vector2(randf()*screen_size.x, -spawn_distance)
			1:	#Left
				spawn_position = Vector2(-spawn_distance, randf()*200 + 160) #screen_size.y

		#Create chance to spawn gold enemy
		var gold_chance = min_gold_chance
		#Give a 1% chance for gold enemy to spawn before 7 seconds
		#When 7 seconds are left, increase chance of gold enemy being spawned
		#When 3 seconds are left, guaranteed spawn the gold enemy
		if gameTimer.time_left <= gold_spawn_start and gameTimer.time_left >= gold_spawn_guaranteed:
			gold_chance = lerpf(min_gold_chance, max_gold_chance, (gameTimer.wait_time - gameTimer.time_left) / (gameTimer.wait_time - gold_spawn_guaranteed))
		else:
			if gameTimer.time_left >= 7.0:
				gold_chance = min_gold_chance
			else:
				gold_chance = max_gold_chance
			
		#Spawn an enemy
		var rand_float = randf()
		var enemy_instance
		if rand_float < gold_chance and not gold_spawned:
			#Spawn special enemy
			enemy_instance = gold_enemy_scene.instantiate()
			gold_spawned = true
		else:
			#Spawn regular enemy
			enemy_instance = enemy_scene.instantiate()
		
		
		#Add that scene as a child of the main scene
		add_child(enemy_instance)
		#Set the enemy's set_player() function to take the player's instance as a parameter
		enemy_instance.set_player(player)
		#This will allow the enemy to know of the existence of the player instance
		
		enemy_instance.global_position = spawn_position
		enemy_count += 1


func _on_game_over_signal() -> void:
	player.game_over = true
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.game_over = true


func _on_player_enemy_killed() -> void:
	enemy_count -= 1
