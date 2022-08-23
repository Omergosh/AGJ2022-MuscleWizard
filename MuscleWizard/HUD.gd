extends CanvasLayer

var hp = 0
var pyro = false
var abjur = false
var arcane = true

var spellnumber = 1


var spellsknown = ['Arcane Blast', ', Fireball', ', Ward']
var e = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Health.text = 'Health: ' + String(hp)
	if arcane == true and pyro == false:
		 $SpellsKnown.text = String(spellsknown[0])
	if arcane == true and pyro == true:
		$SpellsKnown.text = String(spellsknown[0]) + String(spellsknown[1])
	else:
		pass
	if e == false:
		$Interact.hide()
	if e == true:
		$Interact.show()

# will have to figure out better way to do  spell lists later


