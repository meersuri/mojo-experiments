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

    fn __copyinit__(borrowed other: List[T]) -> Self:
        let data = Pointer[T].alloc(other.capacity)
        memcpy(data, other.data, other.size)
        return Self {
            data: data,
            size: other.size,
            capacity: other.capacity,
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

    fn __getitem__(borrowed self, owned idx: Int) raises -> T:
        if idx < 0:
            idx += self.size
        if idx < 0 or idx >= self.size:
            raise Error("Index out of bounds")
        return self.data.load(idx)

    #TODO: figure out why destructor causes double free

@register_passable("trivial")
struct Pair:
    var x: Int
    var y: Int
    fn __init__(x: Int, y: Int) -> Self:
        return Self {
                x: x,
                y: y
                }

fn list_ints() raises:
    var ints = List[Int]()
    print(ints.size)
    for i in range(10):
        ints.append(i)
    print(ints.size)
    for i in range(ints.size):
        print(ints[i])

fn list_pairs() raises:
    var pairs = List[Pair]()
    print(pairs.size)
    for i in range(10):
        pairs.append(Pair(i, i + 1))
    print(pairs.size)
    for i in range(pairs.size):
        print(pairs[i].x, pairs[i].y)

fn main() raises:
    var strs = List[Str]()
    print(strs.size)
    let s = Str("hello")
    strs.append(s)
    print(strs.size)
    print(strs[0].to_str())
    strs.append(Str("world"))
    print(strs.size)
    print(strs[1].to_str())

    print(strs[-1].to_str())
    print(strs[-2].to_str())

    let strs2 = strs
    for i in range(strs2.size):
        print(strs2[i].to_str())

