extends RigidBody3D

@export var animation_player : AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.speed_scale = 1
	movement(1)
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		animation_player.play("hop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func movement(speed):
	linear_velocity = global_basis.x * speed
