extends Area2D

@onready var color_rect: ColorRect = $ColorRect

var window_width : float 
var paddle_width : float

const BULLET = preload("res://player/bullets/player_bullets.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_width = get_viewport_rect().size.x
	paddle_width = color_rect.size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# Paddle movements
	if Input.is_action_pressed("ui_left"):
		position.x -= 500 * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += 500 * delta
	
	position.x = clamp(position.x, paddle_width / 2, window_width - paddle_width / 2)
	
	# Instantiate bullets if the player press space
	if Input.is_action_just_pressed("ui_select"):
		var bullet_instance = BULLET.instantiate()
		bullet_instance.position = position
		get_parent().add_child(bullet_instance)
		bullet_instance.add_to_group("Bullets")
