extends CharacterBody3D

var Camera : Camera3D
var Head : Node3D

var moveSpeed : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 9.0

var lookSens : float = 0.5
var minXRotation : float = -85
var maxXRotation : float = 85
var mouseDir : Vector2

func _ready() -> void:
	Camera = $Camera
	Head = $Head
	remove_child(Camera)
	get_node("/root/Main").add_child.call_deferred(Camera)

func _input(event: InputEvent) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion:
		Camera.rotation_degrees.x += event.relative.y * -lookSens
		Camera.rotation_degrees.x = clamp(Camera.rotation_degrees.x, minXRotation, maxXRotation)
		Camera.rotation_degrees.y += event.relative.x * -lookSens

func _process(delta: float) -> void:
	Camera.position = Head.global_position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpForce
	
	var input = Input.get_vector("left", "right", "fwd", "bwd")
	var dir = Camera.basis.z * input.y + Camera.basis.x * input.x
	
	dir.y = 0
	dir = dir.normalized()
	
	velocity.x = dir.x * moveSpeed
	velocity.z = dir.z * moveSpeed
	
	move_and_slide()
