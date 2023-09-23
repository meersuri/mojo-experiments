from memory.unsafe import Pointer

fn main() raises:

    var p = Pointer[Int8].alloc(2)
    for i in range(2):
        p.store(i, i)
    for i in range(2):
        print(p.load(i))

