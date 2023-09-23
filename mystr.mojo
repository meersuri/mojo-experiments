from memory.unsafe import Pointer
from utils.vector import DynamicVector

@register_passable("trivial")
struct Str:
    var data: Pointer[UInt8]
    var size: Int
    fn __init__() -> Self:
        return Self {
                data: Pointer[UInt8].get_null(),
                size: 0
                }
    fn make_empty(inout self, size: Int):
        self.data = Pointer[UInt8].alloc(size)
        self.size = size
        for i in range(size):
            self.data.store(i, 0)

    fn from_string(inout self, s: String):
        self.size = len(s)
        self.data = Pointer[UInt8].alloc(self.size)
        for i in range(self.size):
            self.data.store(i, UInt8(ord(s[i])))

    fn to_str(inout self) -> String:
        var s = String()
        for i in range(self.size):
            let c = chr(self.data.load(i).to_int())
            s += c[0]
        return s

fn main():
    var s = Str()
    s.from_string(String("the quick brown fox jumps"))
    print(s.to_str())
    var vec = DynamicVector[Str]()
    vec.push_back(s)
    print(vec[0].to_str())
    var s2 = Str()
    s2.from_string("finally a vector of string")
    vec.push_back(s2)
    print(vec[1].to_str())
