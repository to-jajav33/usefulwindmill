extends Node2D


# Declare member variables here. Examples:
enum MODES {
	DIVE,
	SHOOT
}

enum TOGGLE_MODES {
	ON,
	OFF
}

const __DIVE_DIST_FACTOR := 0.25;
const __DIVE_MAX_DIST := 1000.0;
var __toggleShootMode : int = TOGGLE_MODES.OFF;
var __diveSpeed := 0.0;
var __diveDirection := Vector2.ZERO;
var __willDiveOnRelease := false;
var __canDive = true;
var __currentMode : int = MODES.DIVE;
var __previousMode : int = MODES.DIVE;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("toggle_shoot")):
		fnHandleToggleShoot();
	
	if (self.__currentMode == MODES.DIVE):
		self.fnHandleDive();
	elif (self.__currentMode == MODES.SHOOT):
		self.fnHandleShoot();
	return;

func fnCalcMouseInfo():
	var startPos : Vector2 = $RigidBody2D.global_position;
	var endPos : Vector2 = self.get_global_mouse_position();
	var distance = min(startPos.distance_to(endPos), self.__DIVE_MAX_DIST);
	var direction = startPos.direction_to(endPos);
	return {
		'distance': distance,
		'direction': direction
	};

func fnHandleDive() -> void:
	self.__canDive = ($RigidBody2D.linear_velocity == Vector2.ZERO) or ($RigidBody2D.sleeping);
	
	if ((self.__canDive == true) && Input.is_action_pressed("dive")):
		self.__willDiveOnRelease = true;
		
		var mouseInfo = fnCalcMouseInfo();
		self.__diveSpeed = self.__DIVE_DIST_FACTOR * mouseInfo.distance;
		self.__diveDirection = mouseInfo.direction.normalized();
		
	elif((self.__canDive == true) && (self.__willDiveOnRelease)):
		self.__willDiveOnRelease = false;
		self.fnDive(self.__diveDirection * self.__diveSpeed);
	return;

func fnHandleShoot() -> void:
	return;

func fnHandleToggleShoot() -> void:
	if (self.__toggleShootMode == TOGGLE_MODES.OFF):
		self.__previousMode = self.__currentMode;
		self.__currentMode = MODES.SHOOT;
		self.__toggleShootMode = TOGGLE_MODES.ON;
		$AnimationPlayer_Camera.play("toggle_to_shoot");
	else:
		self.__toggleShootMode = TOGGLE_MODES.OFF;
		self.__currentMode = self.__previousMode;
		$AnimationPlayer_Camera.play_backwards("toggle_to_shoot");
	return;

func fnDive (paramForce : Vector2) -> void:
	$RigidBody2D.apply_central_impulse(paramForce);
	return;
