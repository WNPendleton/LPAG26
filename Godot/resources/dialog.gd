class_name Dialog
extends Resource

## Item that is required for this dialog to be chosen. Leave blank for no requirement
@export var key_name := ""
## Dialog event id to be initiated. Must be present in res://data/dialog.csv
@export var dialog_ids: Array[String]
## Trigger to be triggered after the dialog is finished.
@export var trigger: Trigger
