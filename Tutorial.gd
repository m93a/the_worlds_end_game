extends Node
onready var Game = $".."
onready var PlayerShip = $"../WorldView/Viewport/World/PlayerShip"
onready var Asteroid1 = $"../WorldView/Viewport/World/Asteroid1"

var step = 0
var ready = false

func _ready(): ready = true

func _process(delta):
	if not ready: return
	displayText()
	progress()

func displayText():
	var text = specialText()
	
	if text == "":
		text = currentText(step)
		$Timer.paused = false
	else:
		$Timer.paused = true
	
	$Label.text = text

func progress():
	while isCompleted(step):
		step += 1
		$Timer.start(5)

func specialText() -> String:
	if Game.shipExploded:
		return "[The black hole in your engine exploded.]"
	if Game.oxygen == 0:
		return "[You're suffocating.]"
	if Game.drillGlitching or Game.oxygenatorGlitching or Game.gassifierGlitching:
		return "You've overloaded your BHE. Turn off all the appliances."
	return ""

func currentText(step: int) -> String:
	match step:
		1: return "The last civilization has died out millenia ago."
		2: return "You yourself have witnessed all of your dear ones pass."
		3: return "One by one. Until only you remained."
		4: return "Alone in the universe, gathering the very last things it has to offer."
		5: return "Your ship is powered by the Black Hole Engine."
		6: return "It devours any kind of matter and spits out pure energy."
		7: return "You feed it asteroids, mostly."
		8: return "Look, there's one just here, in the bottom left corner of your screen!"
		9: return "Hover your cursor above it and quickly tap [space] to initiate a rotation."
		10: return "You can see that your cursor has changed to indicate that you aren't stationary."
		11: return "If you now hold space, your ship will reorient itself to face the asteroid."
		12: return "Just hover your cursor over the center of the asteroid and hold [space]."
		13: return "Press [W] to use your ion thruster to accelerate towards it."
		14: return "Press [S] to deaccelerate again. Beware, your forward-facing ion thrusters are weaker!"
		15: return "Once you're close to the asteroid, turn your stern (the back part of your ship) towards it."
		16: return "Try to get closer to the asteroid. Let the stern of your ship touch it."
		17: return "The mining equipment on your ship is energy-intensive, so before you turn on the drill..."
		18: return "First, increase the power generated by your BHE, found in the bottom centre of your ship."
		19: return "You can do this by a few clicks on the plus button on the BHE (bottom centre, right screen)."
		20: return "You've successfully set the target power. Now wait until the BHE meets it."
		21: return "Good! Now, you can turn on the drill in left wing of your ship."
		22: return "Click on the drill in the left part of the right screen."
		23: return "Let's drill that sweet sweet matter."
		24: return ""
		25: return "Now you can turn off the drill and go looking for other asteroids."
		26: return "You can also decrease the power of your BHE to save mass."
		27: return ""
		28: return "A curious feature of black holes is that they produce the more energy the smaller they are."
		29: return "A huge black hole would produce almost no energy, and would be useless as a power source."
		30: return "The black hole in your BHE is a much smaller one."
		31: return "And the smaller it is, the larger the power output."
		32: return "Therefore, to decrease the power of your BHE, you actually have to put more matter to it."
		33: return ""
		34: return "The amount of matter you have in your ship is indicated by the red meter (right screen, left bottom)."
		35: return "The matter needed to bring your BHE to minimum power is indicated by the dark part of the red meter."
		36: return ""
		37: return ""
		38: return "The other meters you have are (clockwise):"
		39: return "a blue oxygen & pressure meter,"
		40: return "a yellow power demand & supply meter,"
		41: return "and a green ship health indicator."
		42: return ""
		43: return ""
		44: return "There are two more machines on your ship."
		45: return "The big box in your ship's nose is the Oxygenator."
		46: return "It provides you with breathable air as long as it has a little power & pressure available."
		47: return ""
		48: return "The other machine is the Gassifier, an energy-intensive machine that turns lots of mass into a bit of pressure."
		49: return ""
		50: return ""
		51: return "If you're low on energy, you can use gas thrusters to maneuver your ship."
		52: return "Forward and backward gas thrusters can be activated using [E] and [D]."
		53: return "You also have sideways thrusters, activated by keys [A] and [F]."
		_: return ""

func isCompleted(step: int) -> bool:
	if step < 9 and isCompleted_special(9): return true
	if step < 12 and isCompleted_special(12): return true
	if step < 16 and isCompleted_special(16): return true
	if 16 < step and step < 19 and isCompleted_special(19): return true
	if 16 < step and step < 22 and isCompleted_special(22): return true
	if step < 23 and isCompleted_special(23): return true
	if 23 < step and isCompleted_special(50): return true
	
	return isCompleted_special(step)
	

func isCompleted_special(step: int) -> bool:
	match step:
		9: return PlayerShip.a != 0
		12: return (
			PlayerShip.a == 0 and
			abs(PlayerShip.angleDiff(
				PlayerShip.dir.angle(),
				PlayerShip.angleToBody(Asteroid1)
			)) < 0.2
		)
		13: return (
			PlayerShip.position.direction_to(Asteroid1.position).dot(PlayerShip.v) > 5
		)
		16: return PlayerShip.drillable
		19: return Game.powerSupplyTarget == 100
		20: return Game.powerSupply == 100
		22: return Game.drillActive
		23: return Game.matter > 90
		26: return Game.powerSupplyTarget < 100
		50: return Game.powerSupply < 40
		_: return $Timer.time_left == 0
