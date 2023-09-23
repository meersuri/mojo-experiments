from memory.unsafe import Pointer

@register_passable("trivial")
struct MyList[T: AnyType]:
    var data: Pointer[T]
    var size: Int
    var capacity: Int

    fn __init__() -> Self:
        return Self {
            size: 0,
            capacity: 1,
            data: Pointer[T].alloc(1)
        }

#    fn __del__(owned self):
#        self.data.free()
#        self.capacity = 0
#        self.size = 0

    fn append(inout self, obj: T):
        if self.size == self.capacity:
            let new_capacity = 2*self.capacity
            let new_data = Pointer[T].alloc(new_capacity)
            for i in range(self.size):
                new_data.store(i, self.data.load(i))
            self.data.free()
            self.capacity = new_capacity
        self.data.store(self.size, obj)
        self.size += 1


fn main():
    var items = MyList[String]()
    print(items.size)
    items.append(String("hello"))
    print(items.size)

