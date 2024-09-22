extends CharacterBody2D
class_name Boid

const SPEED = 2000.0
@export var rotation_speed := 2.0
var separation_importance: float
var alignment_importance: float
var cohesion_importance: float
var neighbors: Array = []
var obstacles: Array = []
@onready var ray_container: Node2D = $RayContainer
@onready var screen_size:= get_viewport_rect().size
@onready var avoidance_line: Line2D = $AvoidanceLine


func _ready() -> void:
	Main.parameter_changed.connect(update_parameter)
	#avoidance_line.add_point(Vector2.ZERO, 0)
	#avoidance_line.add_point(Vector2.UP*20, 1)
	#avoidance_line.width = 2
	#avoidance_line.default_color = Color(0, 0, 1, 1)

func update_parameter(parameter, value) -> void:
	if parameter == Main.parameters.SEPARATION:
		separation_importance = value
	if parameter == Main.parameters.ALIGNMENT:
		alignment_importance = value
	if parameter == Main.parameters.COHESION:
		cohesion_importance = value

func _physics_process(delta: float) -> void:
	apply_separation(delta)
	apply_alignment(delta)
	apply_cohesion(delta)
	velocity =  Vector2.DOWN.rotated(rotation) * SPEED * delta
	obstacles = [] # clear obstacle list
	move_and_slide()
	screen_wrap()

func get_avoidance_vector(obstacle_positions:Array) -> Vector2:
	var avoidance_vec: Vector2 = Vector2.ZERO
	if len(obstacle_positions)>0:
		for obstacle in obstacle_positions:
			avoidance_vec += obstacle/obstacle.length() 
		#avoidance_vec /= float(len(obstacles))
		avoidance_vec *= -1
	return avoidance_vec
	
func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

func apply_separation(delta) -> void:
	var avoidance_vector: Vector2 = Vector2.ZERO
	for ray:RayCast2D in ray_container.get_children():
		if ray.is_colliding():
			var obstacle:= ray.get_collision_point()
			obstacles.append(to_local(obstacle))
	avoidance_vector = get_avoidance_vector(obstacles)
	# visualize avoidance vector:
	#avoidance_line.remove_point(1)
	#avoidance_line.add_point(avoidance_vector, 1)
	# simple instantaneous rotation:
	#look_at(to_global(avoidance_vector))
	
	if avoidance_vector != Vector2.ZERO:
		rotate_towards(avoidance_vector, delta, separation_importance)
		
func apply_alignment(delta):
	var avg_direction := Vector2.ZERO
	for neighbor in neighbors:
		avg_direction += Vector2(0, 1).rotated(neighbor.rotation)
	avg_direction /= float(len(neighbors))
	rotate_towards(avg_direction, delta, alignment_importance)
	
func apply_cohesion(delta):
	if len(neighbors) > 0:
		var center_position:= Vector2.ZERO
		for neighbor in neighbors:
			center_position += neighbor.global_position
		center_position/= len(neighbors)
		center_position = to_local(center_position)
		rotate_towards(center_position, cohesion_importance, delta)

func rotate_towards(to:Vector2, delta, weight) -> void:
	var _theta = wrapf(atan2(to.x, to.y) - rotation, -PI, PI)
	rotation += clamp(rotation_speed * weight * delta, 0, abs(_theta)) * sign(_theta)


func _on_neighbor_body_entered(body: Node2D) -> void:
	if body in neighbors:
		neighbors.erase(body)


func _on_neighbor_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		neighbors.append(body)
