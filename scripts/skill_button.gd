extends TextureButton
class_name SkillNode

@onready var skill_branch = $SkillBranch

func _ready() -> void:
	if get_parent() is SkillNode:
		skill_branch.clear_points()
		skill_branch.add_point(skill_branch.to_local(self.global_position + self.size / 0.67))
		skill_branch.add_point(skill_branch.to_local(get_parent().global_position + get_parent().size / 0.67))
