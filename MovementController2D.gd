# Licensed under CC BY-SA 4.0
# License -> http://creativecommons.org/licenses/by-sa/4.0/
# Originally by GgDionne

# Godot v4.2.1


extends CharacterBody2D


# Controller settings

const gravity = 1000  # Gravity

const speedground = 100  # Top speed when grounded true
const speedair = 60  # Top speed when grounded false

# If acceleration > speed, jitters will occur
const accelground = 1500  # Acceleration when grounded true
const accelair = 500  # Acceleration when grounded false

const frictionground = 500  # Friction when grounded true
const frictionair = 50  # Friction when grounded false (air resistance)

const jumpinitial = 400  # Jump takeoff speed
const jumpboostqty = 5000  # Total boost in air after jump
const jumpboostaccel = 500  # Jump boost accelleration


# Input action mappings

const keyleft = "ui_left"
const keyright = "ui_right"
const keyjump = "ui_up"


# Things you shouldn't have to touch

# Used to calculate if the player is still holding keyjump in the air after jumping
var hasjumped = false

var boostremaining = jumpboostqty  # Used to calculate how much boost the player has left


# Main loop

func _physics_process(delta):
	
	
	# X Movement
	
	# Ground logic
	if is_on_floor() == true:  # If player is grounded
		
		# Friction ground
		velocity.x = move_toward(velocity.x, 0, frictionground * delta)
		
		# Movement ground
		if abs(velocity.x) < speedground:  # if speed is in acceptable range
			if Input.is_action_pressed(keyleft):  # if keyleft is pressed
				velocity.x -= accelground * delta  # Apply acceleration left
			elif Input.is_action_pressed(keyright):  # elif keyright is pressed
				velocity.x += accelground * delta
	
	# Air logic
	else:  # if is_on_floor() != true
		
		# Friction air
		velocity.x = move_toward(velocity.x, 0, frictionair * delta)
		
		# Movement air
		if abs(velocity.x) < speedair:  # if speed is in acceptable range
			if Input.is_action_pressed(keyleft):  # if keyleft is pressed
				velocity.x -= accelair * delta  # Apply acceleration left
			elif Input.is_action_pressed(keyright):  # elif keyright is pressed
				velocity.x += accelair * delta  # Apply acceleration right
	
	
	# Y Movement
	
	# Jump initial
	if is_on_floor() == true:  # if player is grounded
		hasjumped = false  # Reset logic variable
		boostremaining = jumpboostqty # Reset boost remaining
		if Input.is_action_just_pressed(keyjump):  # If jumping initially
			velocity.y -= jumpinitial  # Accelerate upward by initial amount
			hasjumped = true  # Update logic variable
	
	# Jump boost
	# elif the player has jumped hbut asn't let go of keyjump, and still has boost
	elif hasjumped == true && Input.is_action_pressed(keyjump) && boostremaining >= jumpboostaccel:
		velocity.y -= jumpboostaccel * delta  # Boost the jump by boost acceleration
		boostremaining -= jumpboostaccel * delta  # Decrease the remaining boost quantity
	
	# Jump boost closing logic
	else:  # The player has let go of keyjump in the air, or has run out of boost
		hasjumped = false  # Reset logic variable
	
	# Gravity
	velocity.y += gravity * delta  # Apply gravity
	
	
	# Update velocity
	move_and_slide()
	
	
	pass
