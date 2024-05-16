extends CharacterBody3D

@export var animation_player : AnimationPlayer
@onready var bushes = [$"../Bush", $"../Bush2",$"../Bush3"]
@onready var grass = [$"../Tall Grass", $"../Tall Grass2", $"../Tall Grass3", $"../Tall Grass4"]
@onready var body = $Node3D
@onready var enclosure_zone = Rect2(-24,-24, 50, 50)

enum states {WANDERING, FLEEING}
var state = states.WANDERING
var target
var direction
var speed = 15
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
		velocity = arrive_force(target, 1)
	elif(state == states.WANDERING):
		pass
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
	
func arrive_force(target:Vector3, slowingDistance:float):
	var toTarget = target - global_transform.origin
	var dist = toTarget.length()
	
	if dist < 2:
		return Vector3.ZERO
	
	var ramped = (dist / slowingDistance) * speed
	var limit_length = min(speed, ramped)
	var desired = (toTarget * limit_length) / dist 
	return desired - velocity

#func enclosure_steering() -> Vector3:
	#var desired_velocity: Vector3 = Vector3.ZERO
	#print(position.x, "  ", enclosure_zone.position.x)
	#if position.x < enclosure_zone.position.x:
		#desired_velocity.x += 1
	#elif position.x > enclosure_zone.position.x + enclosure_zone.size.x:
		#desired_velocity.x -= 1
	#if position.z < enclosure_zone.position.y:
		#desired_velocity.z += 1
	#elif position.z > enclosure_zone.position.y + enclosure_zone.size.y:
		#desired_velocity.z -= 1
		#
	#desired_velocity = desired_velocity.normalized() * speed
	#if desired_velocity != Vector3.ZERO:
		#return desired_velocity - velocity
	#else:
		#return Vector3.ZERO
	
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
	#direction = (target - get_global_position()).normalized()
	#direction = Vector3(direction.x,0,direction.z)
	#look_at(direction)
	pass


func _on_area_3d_body_entered(body):
	state = states.FLEEING
	to_nearest_bush()
	pass # Replace with function body.
