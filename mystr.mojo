from memory.unsafe import Pointer
from utils.vector import DynamicVector

@register_passable
struct Str:
    alias PtrToData = Pointer[UInt8]
    var data: Pointer[UInt8]
    var size: Int
    fn __init__() -> Self:
        return Self {
                data: Pointer[UInt8].get_null(),
                size: 0
                }

    fn __copyinit__(borrowed other) -> Self:
        return Self {
                data: Pointer[UInt8].alloc(other.size),
                size: other.size
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

    fn to_str(borrowed self) -> String:
        var s = String()
        for i in range(self.size):
            let c = chr(self.data.load(i).to_int())
            s += c[0]
        return s

    fn startswith(borrowed self, prefix: String) -> Bool:
        let pref_len = len(prefix)
        if pref_len > self.size:
            return False
        for i in range(pref_len):
            if self.data.load(i) != ord(prefix[i]):
                return False
        return True

    fn __del__(owned self):
        self.data.free()
        self.size = 0

fn main():
    var s = Str()
    s.from_string("the quick brown fox jumps")
    print(s.to_str())
    var s2 = Str()
    s2.from_string("finally a vector of string")
    print(s2.to_str())
    print(s2.startswith("finally"))
    print(s2.startswith("finalle"))
