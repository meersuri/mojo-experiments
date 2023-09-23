from memory.unsafe import Pointer

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

    fn append(inout self, obj: T):
        if self.size == self.capacity:
            let new_capacity = 2*self.capacity
            let new_data = Pointer[T].alloc(new_capacity)
            for i in range(self.size):
                new_data.store(i, self.data.load(i))
            self.data.free()
            self.capacity = new_capacity
            self.data = new_data
        var obj_copy = obj # an owned copy?
        self.data.store(self.size, obj_copy)
        self.size += 1

    fn __getitem__(inout self, idx: Int) raises -> T:
        if idx >= 0 and idx > self.size:
            raise Error("Index out of bounds")
        return self.data.load(idx)
    
    fn __del__(owned self):
        self.data.free()
        self.size = 0
        self.capacity = 0

fn main() raises:
    var items = List[Int]()
    print(items.size)
    for i in range(10):
        items.append(i)
    print(items.size)
    for i in range(items.size):
        print(items[i])

