extends CharacterBody3D

@export var animation_player : AnimationPlayer
@onready var bushes = [$"../Bush", $"../Bush2",$"../Bush3"]
@onready var grass = [$"../Tall Grass", $"../Tall Grass2", $"../Tall Grass3", $"../Tall Grass4"]
@onready var rabbit = load("res://Scenes/rabbit.tscn")
@onready var body = $Node3D
@onready var enclosure_zone = Rect2(-24,-24, 50, 50)

@export var hunger : Timer
@export var starving : Timer
@export var breeding_timer : Timer

enum states {WANDERING, FLEEING, BREEDING, WAITING}
var state = states.WANDERING
var target
var direction
var speed = 13
var player
var nearest_grass
var breeding = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.speed_scale = 1
	breeding_timer.start()
	state = states.WANDERING
	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		animation_player.play("hop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#movement(1)
	pass
	
func _physics_process(delta):

	if $Area3D.overlaps_body($"../Player"):
		state = states.FLEEING
		
	if(state == states.FLEEING):
		to_nearest_bush()
		var combined_force = arrive_force(target, 1) + flee_force(player.get_global_position())
		velocity += combined_force.normalized()*speed
	elif(state == states.WANDERING):
		to_nearest_grass()
		velocity = arrive_force(nearest_grass, 0.1)
	elif(state == states.BREEDING):
		velocity = Vector3.ZERO
		state = states.WANDERING
		breeding_timer.start()
		get_parent().add(rabbit)
	if(velocity.length()>0):
		animation_player.play("hop")
	else:
		animation_player.stop()

	move_and_slide()
	#look_at(velocity.normalized())
	#if velocity.length()>0:
		#var direction = velocity.normalized()
		#var tar = atan2(direction.x, direction.z)
		#rotation.y = tar
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

func eat():
	hunger.start()
	starving.stop()
	if(breeding_timer.is_stopped()):
		state = states.BREEDING
	
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
	
	pass # Replace with function body.


func _on_hunger_timeout():
	starving.start()
	pass # Replace with function body.


func _on_starving_timeout():
	queue_free()
	pass # Replace with function body.


