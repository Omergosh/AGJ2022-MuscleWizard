extends CanvasLayer

var hp = 0
var pyro = false
var abjur = false
var arcane = true

var spellsknown = ['Arcane Blast', ', Fireball', ', Ward']
var e = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Health.text = 'Health: ' + String(hp)
	$SpellsKnown.text = 'Spells known: Arcane Blast'
	if e == false:
		$Interact.hide()
	if e == true:
		$Interact.show()
