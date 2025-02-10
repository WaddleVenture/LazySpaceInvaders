extends Node2D

const ENEMY = preload("res://enemy/enemy.tscn")

var enemies = []
var direction = 1
var speed = 200
var move_down = false

var left_limit = 50
var right_limit
var step_down = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemy()
	right_limit = get_viewport_rect().size.x - 50


func _on_enemy_destroyed(enemy):
	enemies.erase(enemy)

func spawn_enemy():
	var start_x = 50
	var start_y = 50
	var spacing_x = 100
	var spacing_y = 100

	for i in range(7):
		for j in range(3):
			var enemy_instance = ENEMY.instantiate()
			enemy_instance.position = Vector2(start_x + i * spacing_x, start_y + j * spacing_y)
			add_child(enemy_instance)
			enemy_instance.add_to_group("Enemy")
			enemies.append(enemy_instance)
			
			# Connect signal
			enemy_instance.enemy_destroyed.connect(_on_enemy_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_amount = speed * delta * direction
	var should_descend = false

	for enemy in enemies:
		if enemy.position.x + move_amount > right_limit or enemy.position.x + move_amount < left_limit:
			should_descend = true
			break

	if should_descend:
		direction *= -1
		move_down = true

	for enemy in enemies:
		if move_down:
			enemy.position.y += step_down
		else:
			enemy.position.x += move_amount
	move_down = false 
	
	if len(enemies) == 0:
		reload_scene()


func _on_borders_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_killzone_area_entered(_area: Area2D) -> void:
	get_tree().reload_current_scene()


func _on_player_area_entered(_area: Area2D) -> void:
	call_deferred("reload_scene")
	
func reload_scene():
	get_tree().reload_current_scene()
