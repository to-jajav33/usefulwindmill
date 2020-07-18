extends Node2D


# Declare member variables here. Examples:
var __diveSpeed : float = 300.0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("dive")):
		self.fnDive(Vector2.RIGHT * self.__diveSpeed);
	return;

func fnDive (paramForce : Vector2) -> void:
	var canDive = true;
	
	if (canDive):
		$RigidBody2D.apply_central_impulse(paramForce);
		canDive = false;
	return;
