alias MyTrue = MyBool(__mlir_attr.`true`)

@register_passable("trivial")
struct MyBool:
    var value: __mlir_type.i1

    fn __init__() -> Self:
        return Self {
                value: __mlir_attr.`true`
                }

    fn __init__(value: __mlir_type.i1) -> Self:
        return Self {
                value: value
                }

#    fn __eq__(self, rhs: Self) -> Self:
#        let lhs_index = __mlir_op.`index.casts`[ _type: __mlir_type.index](self.value)
#        let rhs_index = __mlir_op.`index.casts`[ _type: __mlir_type.index](rhs.value)
#        return Self( 
#                __mlir_op.`index.cmp`[
#                    pred: __mlir_attr.`#index<cmp_predicate eq>`
#                    ](lhs_index, rhs_index)
#                )

    fn __eq__(self, rhs: Self) -> Self:
        return Self( 
                __mlir_op.`arith.cmpi`[
                    predicate: __mlir_attr.`#arith<cmp_predicate eq>`
                    ](self.value, rhs.value)
                )

    fn __mlir_i1__(self) -> __mlir_type.i1:
        return self.value

fn main():
    let a = MyBool()
    if a:
        print('default true')
    let b = MyTrue
    if b:
        print("hello")
    if a == b:
        print("equal")
