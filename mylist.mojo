from memory.unsafe import Pointer

from mystr import Str

@register_passable
struct List[T: AnyType]:
    var data: Pointer[T]
    var size: Int
    var capacity: Int

    fn __init__() -> Self:
        return Self {
            size: 0,
            capacity: 1,
            data: Pointer[T].alloc(1)
        }

    fn append(inout self, owned obj: T):
        if self.size == self.capacity:
            let new_capacity = 2*self.capacity
            let new_data = Pointer[T].alloc(new_capacity)
            for i in range(self.size):
                new_data.store(i, self.data.load(i))
            self.data.free()
            self.capacity = new_capacity
            self.data = new_data
        self.data.store(self.size, obj)
        self.size += 1

    fn __getitem__(inout self, idx: Int) raises -> T:
        if idx >= 0 and idx > self.size:
            raise Error("Index out of bounds")
        return self.data.load(idx)
    
    fn __del__(owned self):
        self.data.free()
        self.size = 0
        self.capacity = 0

@register_passable("trivial")
struct Pair:
    var x: Int
    var y: Int
    fn __init__(x: Int, y: Int) -> Self:
        return Self {
                x: x,
                y: y
                }

fn main() raises:
    var ints = List[Int]()
    print(ints.size)
    for i in range(10):
        ints.append(i)
    print(ints.size)
    for i in range(ints.size):
        print(ints[i])

    var pairs = List[Pair]()
    print(pairs.size)
    for i in range(10):
        pairs.append(Pair(i, i + 1))
    print(pairs.size)
    for i in range(pairs.size):
        print(pairs[i].x, pairs[i].y)

    var strs = List[Str]()
    print(strs.size)
    var s = Str()
    s.from_string("hello")
    strs.append(s)
    print(strs.size)
    var inner = strs[0]
    inner.from_string(s)
    print(strs[0].to_str())
    s.from_string("world")
    strs.append(s)
    print(strs.size)
    strs[1].from_string(s)
    print(strs[1].to_str())

