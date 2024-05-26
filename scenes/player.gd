extends RigidBody3D

## This is the speed of Cylinder.
@export_range(750.0,3000.0)	 var thrust:float = 1000.0

## This controls the rotation of cylinder.
@export var torque_thrust:float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0,0,torque_thrust * delta))
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0,0,-torque_thrust * delta))		
		#rotation.x += delta
		#rotate_z(-delta)
	pass


func _on_body_entered(body: Node) -> void:
	print(body)
	if "Goal" in body.get_groups():
		print("Winning!")
	if "Ground" in body.get_groups():
		print("jiangjiang")
	pass # Replace with function body.
