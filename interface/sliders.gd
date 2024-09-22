extends Control


@onready var separation_label: Label = $MarginContainer/VBoxContainer/SeparationLabel
@onready var separation_slider: HSlider = $MarginContainer/VBoxContainer/SeparationSlider
@onready var alignment_label: Label = $MarginContainer/VBoxContainer/AlignmentLabel
@onready var alignment_slider: HSlider = $MarginContainer/VBoxContainer/AlignmentSlider
@onready var cohesion_label: Label = $MarginContainer/VBoxContainer/CohesionLabel
@onready var cohesion_slider: HSlider = $MarginContainer/VBoxContainer/CohesionSlider


func _ready() -> void:
	separation_label.text = "Separation:\n" + str(Main.separation_weight)
	alignment_label.text = "Alignment:\n" + str(Main.alignment_weight)
	cohesion_label.text = "Cohesion:\n" + str(Main.cohesion_weight)
	separation_slider.value = Main.separation_weight
	alignment_slider.value = Main.alignment_weight
	cohesion_slider.value = Main.cohesion_weight

func _on_separation_slider_value_changed(value: float) -> void:
	Main.parameter_changed.emit(Main.parameters.SEPARATION, value)
	separation_label.text = "Separation:\n" + str(value)
	
func _on_alignment_slider_value_changed(value: float) -> void:
	Main.parameter_changed.emit(Main.parameters.ALIGNMENT, value)
	alignment_label.text = "Alignment:\n" + str(value)
	
func _on_cohesion_slider_value_changed(value: float) -> void:
	Main.parameter_changed.emit(Main.parameters.COHESION, value)
	cohesion_label.text = "Cohesion:\n" + str(value)
