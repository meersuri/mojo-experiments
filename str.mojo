from utils.vector import DynamicVector
from memory.unsafe import Pointer

fn main() raises:
    let s: String = "13"
    print(atol(s))
#    let ps = Pointer[String].alloc(1)
#    ps.store(String("hello"))
#    let strings = DynamicVector[String](3)
#    strings.push_back(String("hello"))
    var svec = DynamicVector[StringLiteral]()
    svec.push_back("hello")
    svec.push_back("world")
    for i in range(svec.size):
        print(svec[i])
#    let str_ref_from_string = StringLiteral(String("hello"))
    let v2 = ListLiteral[String](String("a"), String("b"))
    print(v2.__len__())
    print(v2.get[0,String]())

