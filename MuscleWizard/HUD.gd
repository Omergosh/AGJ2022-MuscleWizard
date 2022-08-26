extends CanvasLayer

var hp = 0
var pyro = false
var abjur = false
var arcane = true

var spellnumber = 1
var firespell = ', Fireball'
var protectspell = ', Ward'

var spellsknown = ['Arcane Blast', ' ', ' ']
var e = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Health.text = 'Health: ' + String(hp)
	$SpellsKnown.text = 'Spells known: ' + String(spellsknown[0]) + String(spellsknown[1]) + String(spellsknown[2])
	if pyro == true:
		spellsknown[1] = firespell
	if abjur == true:
		spellsknown[2] = protectspell
	if e == false:
		$Interact.hide()
	if e == true:
		$Interact.show()
	if abjur == true:
		$Container/Ward.show()
	if abjur == false:
		$Container/Ward.hide()
	if pyro == true:
		$Container/Fireball.show()
	if pyro == false:
		$Container/Fireball.hide()
	else:
		pass
# will have to figure out better way to do  spell lists later


