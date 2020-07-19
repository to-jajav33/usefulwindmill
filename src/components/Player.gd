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
var __isStill = true;
var __currentMode : int = MODES.DIVE;
var __previousMode : int = MODES.DIVE;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.fnHandleGunRotate();
	if (not $AnimationPlayer_Camera.is_playing()):
		self.__isStill = ($RigidBody2D.linear_velocity == Vector2.ZERO) or ($RigidBody2D.sleeping);
	
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
	var angle = endPos.angle_to_point(startPos);
	return {
		'distance': distance,
		'direction': direction,
		'angle': angle
	};

func fnHandleDive() -> void:
	if ($AnimationPlayer_Camera.is_playing()):
		return;
	
	if ((self.__isStill == true) && Input.is_action_pressed("dive")):
		self.__willDiveOnRelease = true;
		
		var mouseInfo = fnCalcMouseInfo();
		self.__diveSpeed = self.__DIVE_DIST_FACTOR * mouseInfo.distance;
		self.__diveDirection = mouseInfo.direction.normalized();
		
	elif((self.__isStill == true) && (self.__willDiveOnRelease)):
		self.__willDiveOnRelease = false;
		self.fnDive(self.__diveDirection * self.__diveSpeed);
		self.fnGoToShootMode();
	return;

func fnHandleGunRotate():
	var mouseInfo = self.fnCalcMouseInfo();
	$RigidBody2D/gun_pivot.rotation = mouseInfo.angle;
	return;

func fnHandleShoot() -> void:
	if(self.__isStill):
		self.fnGoToDiveMode();
		return;
	
	if (Input.is_action_just_pressed("dive")):
		var mouseInfo = self.fnCalcMouseInfo();
		var bullInst = load("res://components/Bullet.tscn").instance();
		self.add_child(bullInst);
		bullInst.global_position = $RigidBody2D/gun_pivot/gun.global_position;
	
		bullInst.shoot(mouseInfo.direction.normalized() * 1000.0);
	return;

func fnGoToShootMode():
	self.__currentMode = MODES.SHOOT;
	self.__toggleShootMode = TOGGLE_MODES.ON;
	$AnimationPlayer_Camera.play("toggle_to_shoot");
	return;

func fnGoToDiveMode() -> void:
	self.__toggleShootMode = TOGGLE_MODES.OFF;
	self.__currentMode = MODES.DIVE;
	$AnimationPlayer_Camera.play_backwards("toggle_to_shoot");
	return;

func fnDive (paramForce : Vector2) -> void:
	self.__isStill = false;
	$RigidBody2D.apply_central_impulse(paramForce);
	return;
