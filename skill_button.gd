extends TextureButton
class_name SkillNode

@onready var skill_branch = $SkillBranch

func _ready() -> void:
	if get_parent() is SkillNode:
		var start = skill_branch.to_local(self.global_positon + size / 2)
		var end = skill_branch.to_local(get_parent().global_position + get_parent().size / 2)
		skill_branch.clear_points()
		skill_branch.add_point(start)
		skill_branch.add_point(end)
