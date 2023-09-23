from utils.vector import DynamicVector

fn f(x: Int, y: String):
    pass
#    var z: String = y*x
#    print(z)

fn vector():
    var items = DynamicVector[Int]()
    items.push_back(1)
    items.push_back(2)
    print(items.size, items.capacity)
    items.push_back(3)
    print(items.size, items.capacity)

fn vector1():
    var items = DynamicVector[Int]()
    for i in range(1):
        items.push_back(1)

fn main():
   vector()
    
