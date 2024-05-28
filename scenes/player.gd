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
	if "Goal" in body.get_groups():
		print(get_tree().current_scene)
		set_process(false)
		if get_tree().current_scene.name == "Level_4":
			complete_level()
		else:
			var file_path = body.file_path
			var tween = create_tween()
			tween.tween_interval(1.0)
			tween.tween_callback(
				level_upgrade.bind(file_path)
			)
			
	if "Ground" in body.get_groups():
		set_process(false)
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_callback(crash)
		
		
	pass # Replace with function body.sss
	
func crash():
	get_tree().call_deferred("reload_current_scene")
	pass
	
func complete_level():
	get_tree().quit()
	
func level_upgrade(file_path):
	get_tree().call_deferred("change_scene_to_file",file_path)
