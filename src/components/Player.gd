extends Node2D


# Declare member variables here. Examples:
const __DIVE_DIST_FACTOR := 0.25;
const __DIVE_MAX_DIST := 1000.0;
var __diveSpeed := 0.0;
var __diveDirection := Vector2.ZERO;
var __willDiveOnRelease := false;
var __canUseInput = true;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.__canUseInput = ($RigidBody2D.linear_velocity == Vector2.ZERO) or ($RigidBody2D.sleeping);
	
	if ((self.__canUseInput == true) && Input.is_action_pressed("dive")):
		self.__willDiveOnRelease = true;
		var space_state = get_world_2d().direct_space_state;
		
		var startPos : Vector2 = $RigidBody2D.global_position;
		var endPos : Vector2 = self.get_global_mouse_position();
		var distance = min(startPos.distance_to(endPos), self.__DIVE_MAX_DIST);
		self.__diveSpeed = self.__DIVE_DIST_FACTOR * distance;
		
	elif((self.__canUseInput == true) && (self.__willDiveOnRelease)):
		self.__willDiveOnRelease = false;
		self.fnDive(Vector2.RIGHT * self.__diveSpeed);
	pass

func fnDive (paramForce : Vector2) -> void:
	$RigidBody2D.apply_central_impulse(paramForce);
	return;
