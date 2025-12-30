class_name LightSyncParameters
extends Resource

enum trigger_modes {
	## Lights will trigger in order.
	SEQUENCE,
	## Lights will be triggered randomly.
	RANDOM,
	## Lights will be triggered in order, and the order will be randomized once
	## the sequence is complete.
	ROUND_ROBIN}
enum sustain_modes {
	## The light will sustain for the sustain_duration provided.
	STATIC,
	## The light will stay on permanently.
	PERMANENT,
	## The light will stay on until a byType 128 midiEvent is received. When
	## the 128 is received, the light that has been on longest is turned off.
	MIDI}

@export_category("Triggering Logic")
## Wether the light sequence is shuffled on _ready().
@export var randomize_order := false
## How the next light to be triggered is chosen.
@export var trigger_mode: trigger_modes
## How many lights are triggered for each midiEvent
@export var trigger_count := 1
@export_category("Light Parameters")
## How long the light takes to ramp up to maximum energy.
@export var attack_duration := 0.1
## How long the light remains at full power. (Only used in Static sustain mode)
@export var sustain_duration := 0.2
## How long the light takes to ramp down to minimum energy.
@export var decay_duration := 0.5
## How to decide when to turn a light off.
@export var sustain_mode: sustain_modes
## Minimum brightness for each light.
@export var energy_min := 0.0
## Maximum brightness for each light.
@export var energy_max := 1.0
## When a light is triggered, it randomly becomes one of these colors.
@export var colors: Array[Color] = [Color(1.0, 1.0, 1.0)]
