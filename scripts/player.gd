class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)

@export var speed:float = 300.00
@onready var muzzle = $Muzzle
@export var rate_of_fire = 0.2

var laser_scene = preload("res://scenes/laser.tscn")
var latest_touch_position = Vector2.ZERO
var initial_player_position = Vector2.ZERO

var shoot_cd := false
var screen_touch = false
var player_drag = false

#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			var space_state = get_world_2d().direct_space_state
			var query_params = PhysicsPointQueryParameters2D.new()
			query_params.position = event.position
			var result = space_state.intersect_point(query_params)
			if result.size() > 0 and result[0].collider == self:
				screen_touch = true
				#await get_tree().create_timer(rate_of_fire).timeout
		elif not event.is_pressed():
			print('event cancelled');
			screen_touch = false
			
	if event is InputEventScreenDrag:
		var space_state = get_world_2d().direct_space_state
		var query_params = PhysicsPointQueryParameters2D.new()
		query_params.position = event.position
		var result = space_state.intersect_point(query_params)
		latest_touch_position = event.position
		if result.size() > 0 and result[0].collider == self:
			player_drag = true
		elif not event.is_pressed():
			pass
			#player_drag = false
		
			

func _process(delta):
	if Input.is_action_pressed('shoot') || screen_touch:
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false
	if latest_touch_position != Vector2.ZERO:
		print('velocity', velocity)
		print('player_drag', player_drag)
		if player_drag:
			var delta_position = latest_touch_position - global_position
			print('delta_position', delta_position)
			print('latest_touch_position', latest_touch_position)
			print('global_position', global_position)
			print('global_position x', global_position.x)
			var direction = Vector2(latest_touch_position.x, latest_touch_position.y)
			print('direction',direction)
			velocity = direction
			print(velocity, 'velocity')
			#move_and_slide()
			# Apply this difference to the player's position
			#global_position = latest_touch_position


func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up","move_down"))	
	print(direction, 'direction')
	velocity = direction * speed
	print(velocity, 'velocity')
	move_and_slide()


func shoot():
	if shoot_cd:
		laser_shot.emit(laser_scene, muzzle.global_position)
		await get_tree().create_timer(rate_of_fire).timeout
	
func die():
	queue_free();
