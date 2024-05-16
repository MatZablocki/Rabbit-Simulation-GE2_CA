extends CharacterBody3D

@export var animation_player : AnimationPlayer
@onready var bushes = [$"../Bush", $"../Bush2",$"../Bush3"]
@onready var grass = [$"../Tall Grass", $"../Tall Grass2", $"../Tall Grass3", $"../Tall Grass4"]
@onready var body = $Node3D
@onready var enclosure_zone = Rect2(-24,-24, 50, 50)

@export var hunger : Timer
@export var starving : Timer
@export var breeding_timer : Timer

enum states {WANDERING, FLEEING, BREEDING, WAITING}
var state = states.WANDERING
var target
var direction
var speed = 15
var player
var nearest_grass
var breeding = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.speed_scale = 1
	
	
	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		animation_player.play("hop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#movement(1)
	pass
	
func _physics_process(delta):
	if(state == states.FLEEING):
		var combined_force = arrive_force(target, 1) + flee_force(player.get_global_position())
		velocity += combined_force.normalized()*speed
	elif(state == states.WANDERING):
		if breeding:
			state = states.BREEDING
		else:
			velocity = arrive_force(nearest_grass, 1)
	elif(state == states.WAITING):
		velocity = Vector3.ZERO
	if(velocity.length()>0.1):
		animation_player.play("hop")
	else:
		animation_player.play("RESET")
	move_and_slide()
	
	
	pass
	
func seek_force(target: Vector3):	
	var toTarget = target - global_transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * speed
	return desired - velocity
	
func flee_force(target: Vector3):	
	var toTarget = target - global_transform.origin
	toTarget = toTarget.normalized()
	var desired = -toTarget * speed
	return desired - velocity
	
func arrive_force(target:Vector3, slowingDistance:float):
	var toTarget = target - global_transform.origin
	var dist = toTarget.length()
	
	if dist < 2:
		return Vector3.ZERO
	
	var ramped = (dist / slowingDistance) * speed
	var limit_length = min(speed, ramped)
	var desired = (toTarget * limit_length) / dist 
	return desired - velocity

func stop_flee():
	state = states.WANDERING
	print("ss")

	
func to_nearest_bush():
	var nearest = 99999
	var near_bush
	for bush in bushes:
		var temp_vector = bush.get_global_position() - get_global_position()
		var temp_length = temp_vector.length()
		if temp_length <= nearest:
			nearest = temp_length
			var temp = bush.get_global_position()
			target = Vector3(temp.x,0,temp.z)
	return target

func to_nearest_grass():
	var nearest = 99999
	var near_grass
	for x in grass:
		var temp_vector = x.get_global_position() - get_global_position()
		var temp_length = temp_vector.length()
		if temp_length <= nearest:
			nearest = temp_length
			var temp = x.get_global_position()
			nearest_grass = Vector3(temp.x,0,temp.z)

	return target

func _on_area_3d_body_entered(body):
	state = states.FLEEING
	player = body
	to_nearest_bush()
	pass # Replace with function body.


func _on_hunger_timeout():
	starving.start()
	pass # Replace with function body.


func _on_starving_timeout():
	queue_free()
	pass # Replace with function body.


func _on_breeding_timeout():
	breeding = true
	pass # Replace with function body.
