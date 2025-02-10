extends Area2D

@onready var raycast: RayCast2D = $RayCast2D
@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

signal enemy_destroyed(enemy)

const BULLET = preload("res://enemy/bullets/enemy_bullets.tscn")

var is_last = true

func _on_area_entered(area: Area2D) -> void:
	if area.name != "Killzone":
		area.queue_free()
		enemy_destroyed.emit(self)
		queue_free()


func _ready() -> void:
	timer.wait_time = randf_range(0.5, 1.0)
	timer.start()


func _process(_delta: float) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		# Check if the raycast touches another enemy
		if collider is Area2D and collider.is_in_group("Enemy"):
			is_last = false
	else:
		is_last = true


func shoot_enemy_bullet():
	var bullet_instance = BULLET.instantiate()
	bullet_instance.position = position
	get_parent().add_child(bullet_instance)
	bullet_instance.add_to_group("EnnemyBullets")


func _on_timer_timeout() -> void:
	if is_last and randi() % 4 == 0:
		shoot_enemy_bullet()
	timer.wait_time = randf_range(0.5, 1.0)
	timer.start()
