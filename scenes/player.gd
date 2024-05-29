extends RigidBody3D
var level_status:bool = true
## This is the speed of Cylinder.
@export_range(750.0,3000.0)	 var thrust:float = 1000.0

## This controls the rotation of cylinder.
@export var torque_thrust:float = 100
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_l: GPUParticles3D = $BoosterParticles_L
@onready var booster_particles_r: GPUParticles3D = $BoosterParticles_R
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		booster_particles.emitting = true
		apply_central_force(basis.y * delta * thrust)
		if not rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0,0,torque_thrust * delta))
		booster_particles_r.emitting = true
		if not rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles_r.emitting = false
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0,0,-torque_thrust * delta))		
		booster_particles_l.emitting = true
		if not rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles_l.emitting = false
	if rocket_audio.playing and not Input.is_action_pressed("boost") and not Input.is_action_pressed("rotate_left") and not Input.is_action_pressed("rotate_right"):
		rocket_audio.stop()
		#rotation.x += delta
		#rotate_z(-delta)
	pass


func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups() and level_status:
		print(get_tree().current_scene)
		level_status = false
		set_process(false)
		success_audio.play()
		success_particles.emitting = true
		if get_tree().current_scene.name == "Level_4":
			complete_level()
		else:
			var file_path = body.file_path
			var tween = create_tween()
			tween.tween_interval(1.0)
			tween.tween_callback(
				level_upgrade.bind(file_path)
			)
			
	if "Ground" in body.get_groups() and level_status:
		level_status = false
		set_process(false)
		$FailAudio.play()
		explosion_particles.emitting = true
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
