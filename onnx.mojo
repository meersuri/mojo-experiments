from python import Python, PythonObject
from utils.vector import DynamicVector
from sys import argv

from mystr import Str

alias TensorShape = DynamicVector[Int] # yes I'm aware that TensorSpec exists

@register_passable
struct InputOutputSpec:
    var name: Str
    var shape: TensorShape
    fn __init__(inout self, name: Str, shape: TensorShape):
        self.name = name
        self.shape = shape

struct ModelInfo:
    var in_spec: DynamicVector[InputOutputSpec]
    var out_spec: DynamicVector[InputOutputSpec]
    var layer_count: Int
    var ops: DynamicVector[Str]
    fn __init__(inout self, input_spec: DynamicVector[InputOutputSpec], output_spec: DynamicVector[InputOutputSpec], layer_count: Int, operators: DynamicVector[Str]): 
        self.in_spec = input_spec
        self.out_spec = output_spec
        self.layer_count = layer_count
        self.ops = operators

fn parse_onnx_model(model: PythonObject) raises:
    let graph = model.graph
    let layer_count = graph.node.__len__()
    let input_count = graph.input.__len__()
    let output_count = graph.output.__len__()
    var in_spec = DynamicVector[InputOutputSpec]()
    print("INPUTS:")
    for i in range(input_count):
        let input_i = graph.input[i]
        var name = Str()
        name.from_string(input_i.name.to_string())
        print(i, name.to_str())
        var shape =  TensorShape()
        let type_info = input_i.type.tensor_type
        for di in range(type_info.shape.dim.__len__()):
            var shape_str = Str() 
            shape_str.from_string(type_info.shape.dim[di].to_string())
            if shape_str.startswith("dim_param"):
                print_no_newline("dynamic ")
            else:
                print_no_newline("static ")
            print(shape_str.to_str())
        #in_spec.push_back(InputOutputSpec(name, shape))

fn main() raises:
    let onnx = Python.import_module('onnx')
    print('ONNX version: ', onnx.__version__)
    let args = argv()
    if len(args) == 1:
        raise Error("Enter path to .onnx model")
    let model = onnx.load(args[1])
    parse_onnx_model(model)
    
