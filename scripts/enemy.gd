class_name Enemy extends Area2D

@export var speed = 150
@export var hp = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	global_position.y += speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func die():
	queue_free();


func _on_body_entered(body):
	if body is Player:
		body.die()
		die();
	pass # Replace with function body.

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.
