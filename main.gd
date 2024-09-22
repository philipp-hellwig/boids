extends Node2D

@export var flock_size: int

var all_boids: Array
var boid: PackedScene = preload("res://boids/boid.tscn")
@onready var separation_weight := 2.0
@onready var alignment_weight := 0.2
@onready var cohesion_weight := 0.8

enum parameters {
	SEPARATION,
	ALIGNMENT,
	COHESION
}

signal parameter_changed(rule, value)

func _ready() -> void:
	for i in range(flock_size):
		var new_boid = boid.instantiate()
		var pos: Vector2 = Vector2(randf_range(0,800),randf_range(0,800))
		var rot := randi_range(0,360)
		add_child(new_boid)
		new_boid.position = pos
		new_boid.rotation = deg_to_rad(rot)
		all_boids.append(new_boid)
		# initialize parameters (weighing the rule importance)
		new_boid.separation_importance = separation_weight
		new_boid.alignment_importance = alignment_weight
		new_boid.cohesion_importance = cohesion_weight
