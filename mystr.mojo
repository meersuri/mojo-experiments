from memory.unsafe import Pointer
from memory.memory import memcpy

@register_passable("trivial")
struct Str:
    var data: Pointer[Int8]
    var size: Int
    fn __init__(size: Int) -> Self:
        return Self {
                data: Pointer[Int8].alloc(size),
                size: size
                }
    fn copy(inout self, s: String):
        self.data.free()
        self.data = Pointer[Int8].alloc(len(s))
        for i in range(len(s)):
            self.data.store(ord(s[i]))

    fn to_str(inout self) -> String:
        var s = String()
        for i in range(self.size):
            let c = chr(self.data.load(i).to_int())
            print(c)
            s += c
        return s


fn main():
    var x = Str(10)
    x.copy(String("hello there"))
    print(x.to_str())
