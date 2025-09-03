class_name Move extends Resource

enum TargetType {SELF, ALLY, ENEMY, ALL_ALLY, ALL_ENEMY, ALL_FIELD, RANDOM}
enum Effect {DAMAGE, HEAL, BUFF, DEBUFF}
enum Type {FIRE, WATER, GRASS, NONE}
@export var name : String
@export var icon : Texture2D
@export var damage : int
@export var type : Type = Type.NONE
@export var target_type : TargetType = TargetType.ENEMY
