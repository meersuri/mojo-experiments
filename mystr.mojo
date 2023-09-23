from memory.unsafe import Pointer

struct Str:
    var data: Pointer[UInt8]
    var size: Int
    fn __init__(inout self, size: Int):
        self.data = Pointer[UInt8].alloc(size)
        self.size = size
        for i in range(size):
            self.data.store(i, 0)

    fn __init__(inout self, s: String):
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
    var y = Str(String("the quick brown fox jumps"))
    print(y.to_str())
