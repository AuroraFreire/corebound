extends TextureButton
class_name SkillNode

@onready var skill_branch = $SkillBranch

func _ready() -> void:
	if get_parent() is SkillNode:
		skill_branch.add_point(self.global_position + self.size / 2)
		skill_branch.add_point(get_parent().global_position + get_parent().size / 2)
