
extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
const jump_velocity = 4.5

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#setting up player movement
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	if Input.is_action_just_pressed("ui_accept"):
		apply_central_impulse(Vector3(0,1500,0) * delta)
	#apply force to mouse camera movement
	apply_central_force(twist_pivot.basis * input * 3000.0 * delta)
	
	#if escape is pressed, show mouse cursor and give us control of it
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#clamp camera movement down to avoid fully rotating around player	
	$TwistPivot.rotate_y(twist_input)
	$TwistPivot/PitchPivot.rotate_x(pitch_input)
	$TwistPivot/PitchPivot.rotation.x = clamp($TwistPivot/PitchPivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
