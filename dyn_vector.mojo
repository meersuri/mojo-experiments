from utils.vector import DynamicVector

fn main():
    var vec = DynamicVector[Int]()
    let i = Int(10)
    vec.push_back(i)
    var vec2 = DynamicVector[StringRef]()
    let s = "hello"
    vec2.push_back(StringRef(s))
    print(vec2[0])
