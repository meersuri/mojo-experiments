@register_passable
struct Pair[T: AnyType]:
    var x: T
    var y: T

#    fn __init__(inout self):
#        self.x = T(0)
#        self.y = T(0)

    fn __init__(x: T, y: T) -> Pair[T]:
        return Self {x: x, y: y}

fn main():
    let p = Pair[Int](Int(1), Int(2))
    print(p.x, p.y)


