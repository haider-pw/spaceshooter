extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@onready var player_spawn_position = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group('player')
	assert(player!=null)
	print(player.global_position)
	print(player_spawn_position.global_position)
	player.laser_shot.connect(_on_player_laser_shot)
	player.global_position = player_spawn_position.global_position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()
	elif Input.is_action_just_pressed('reset'):
		get_tree().reload_current_scene()
	pass
	
func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate();
	laser.global_position = location
	laser_container.add_child(laser)
	pass


func _on_enemy_spawn_timer_timeout():
	#var enemy = enemy_scenes.pick_random().instantiate()
	#enemy.global_position = Vector2(randf_range(50, 490),50)
	#enemy_container.add_child(enemy)
	pass # Replace with function body.
