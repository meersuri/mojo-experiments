from utils.vector import DynamicVector

fn fib(n: Int) raises -> Int:
    if (n <= 0):
        raise Error("n must be positive")
    if (n == 1 or n == 2):
        return 1
    var a: Int = 1
    var b: Int = 1
    var c: Int = 0
    for i in range(3, n + 1):
        c = a + b
        a = b
        b = c
    return c

fn main() raises:
    var fib_seq = DynamicVector[Int]()
    for i in range(1, 10):
        let fi = fib(i)
        fib_seq.push_back(fi)
        print(fi)


