package types
import "base:intrinsics"
import "core:math"

Vec2 :: struct($T: typeid) where intrinsics.type_is_numeric(T) {
	x, y: T,
}

Normalise :: proc(vec: Vec2($T)) -> Vec2(T) {
	length := Length(vec)
	if length == 0 {
		return {0, 0}
	}
	return {vec.x / length, vec.y / length}
}

Length :: proc(vec: Vec2($T)) -> T {
	return math.sqrt(vec.x * vec.x + vec.y * vec.y)
}
