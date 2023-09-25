from memory.unsafe import Pointer
from memory.memory import memcpy, memset_zero
from utils.vector import DynamicVector

@register_passable
struct Str:
    var data: Pointer[UInt8]
    var size: Int

    fn __init__() -> Self:
        return Self {
                data: Pointer[UInt8].get_null(),
                size: 0
                }

    fn __init__(size: Int) -> Self:
        let data = Pointer[UInt8].alloc(size)
        memset_zero(data, size)
        return Self {
                data: data,
                size: size
                }

    fn __init__(s: String) -> Self:
        #        print('init from:', s)
        let size = len(s)
        let data = Pointer[UInt8].alloc(size)
        for i in range(size):
            data.store(i, UInt8(ord(s[i])))
        return Self {
                data: data,
                size: size
                }

    fn __copyinit__(borrowed other: Str) -> Self:
        #        print('copied', other.to_str())
        let data = Pointer[UInt8].alloc(other.size)
        memcpy(data, other.data, other.size)
        return Self {
                data: data,
                size: other.size
                }

    fn __getitem__(borrowed self, owned idx: Int) raises -> Self:
        if idx < 0:
            idx += self.size
        if idx < 0 or idx >= self.size:
            raise Error("Index out of bounds")
        return chr(self.data.load(idx).to_int())[0]

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

fn main() raises:
    let s = Str("the quick brown fox jumps")
    print(s.to_str())
    let s2 = Str("yet another string")
    print(s2.to_str())
    let s3 = s2;
    print(s3.to_str())
    print(s2.startswith("yet"))
    print(s2.startswith("yeti"))
    for i in range(s2.size):
        print_no_newline(s2[i].to_str())
    print()
