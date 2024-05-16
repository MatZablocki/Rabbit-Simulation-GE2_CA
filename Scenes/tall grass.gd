extends MeshInstance3D
@onready var area3d = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in area3d.get_overlapping_bodies():
		body.eat()
	pass


