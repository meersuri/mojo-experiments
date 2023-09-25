from python import Python, PythonObject
from sys import argv

from mystr import Str
from mylist import List

alias TensorShape = List[Int] # yes I'm aware that TensorSpec exists

@register_passable
struct InOutSpec:
    var name: Str
    var shape: TensorShape
    fn __init__(name: Str, shape: TensorShape) -> Self:
        return Self {
                name: name,
                shape: shape
                }

@register_passable
struct ModelInfo:
    var in_spec: List[InOutSpec]
    var out_spec: List[InOutSpec]
    var layer_count: Int
    var ops: List[Str]
    fn __init__(input_spec: List[InOutSpec], output_spec: List[InOutSpec], layer_count: Int, operators: List[Str])-> Self: 
        return Self {
            in_spec: input_spec,
            out_spec: output_spec,
            layer_count: layer_count,
            ops: operators
            }

fn parse_onnx_model(model: PythonObject) raises:
    let graph = model.graph
    let layer_count = graph.node.__len__()
    let input_count = graph.input.__len__()
    let output_count = graph.output.__len__()
    var in_spec = List[InOutSpec]()
    print("INPUTS:")
    for i in range(input_count):
        let input_i = graph.input[i]
        let name = Str(input_i.name.to_string())
        print(i, name.to_str())
        var shape =  TensorShape()
        let type_info = input_i.type.tensor_type
        for di in range(type_info.shape.dim.__len__()):
            var shape_str = Str(type_info.shape.dim[di].to_string()) 
            if shape_str.startswith("dim_param"):
                print_no_newline("dynamic ")
            else:
                print_no_newline("static ")
            print(shape_str.to_str())
        in_spec.append(InOutSpec(name, shape))

fn main() raises:
    let onnx = Python.import_module('onnx')
    print('ONNX version: ', onnx.__version__)
    let args = argv()
    if len(args) == 1:
        raise Error("Enter path to .onnx model")
    let model = onnx.load(args[1])
    parse_onnx_model(model)
    
