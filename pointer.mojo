from memory.unsafe import Pointer
from sys import argv

fn make_int_array(n: Int) raises:
    print(n)
    var x = Pointer[Int].alloc(n)
    for i in range(n):
        x.store(i, i)
    for i in range(n):
        print(x.load(i))

fn main() raises:
    if argv().__len__() == 1:
        raise Error("Please enter number")
    var n: Int = 0
    try:
        n = 2*atol(argv()[1])
    except:
        n = 10
        print("Defaulting n to 10")
    make_int_array(n)
