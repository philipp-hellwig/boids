extends Node2D


@export var angle_between_rays := deg_to_rad(20)
@export var vision_range: int
@export var cone_of_vision: int
@onready var cone_rad := deg_to_rad(cone_of_vision)

func _ready() -> void:
	var num_rays := cone_rad/angle_between_rays
	for i in num_rays:
		var ray := RayCast2D.new()
		var angle := angle_between_rays * (i-num_rays/2)
		ray.target_position = Vector2.DOWN.rotated(angle) * vision_range
		add_child(ray)
		ray.enabled = true
		#var line = Line2D.new()
		#line.add_point(Vector2.ZERO, 0)
		#line.add_point(Vector2.DOWN.rotated(angle) * vision_range, 1)
		#line.width = 1
		#line.default_color = Color(0, 1, 0, .1)
		#ray.add_child(line)
#
#
#func _process(delta: float) -> void:
	#for ray in get_children():
		#if ray.is_colliding():
			#ray.get_child(0).default_color = Color(1,0,0,.2)
		#else:
			#ray.get_child(0).default_color = Color(0, 1, 0, .1)
