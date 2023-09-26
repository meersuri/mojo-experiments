from python import Python, PythonObject
from sys import argv

from mystr import Str
from mylist import List

alias TensorShape = List[Int] # yes I'm aware that TensorSpec exists, this is just for fun

fn print_shape(shape: TensorShape) raises:
    print_no_newline('[')
    for i in range(shape.size - 1):
        print_no_newline(shape[i])
        print_no_newline(', ')
    print_no_newline(shape[-1])
    print(']')

@register_passable
struct InOutSpec:
    var name: Str
    var shape: TensorShape
    fn __init__(name: Str, shape: TensorShape) -> Self:
        return Self {
                name: name,
                shape: shape
                }

    fn print(borrowed self) raises:
        print_no_newline(self.name.to_str(), '')
        print_shape(self.shape)

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

    fn print(borrowed self) raises:
        print("Model inputs:")
        for i in range(self.in_spec.size):
            self.in_spec[i].print()
        print("Model outputs:")
        for i in range(self.out_spec.size):
            self.out_spec[i].print()
        print("Layer count:", self.layer_count)

fn parse_onnx_model(model: PythonObject) raises -> ModelInfo:
    let graph = model.graph
    let layer_count = atol(graph.node.__len__().to_string())
    let in_spec = parse_onnx_model_inputs(graph)
    let out_spec = parse_onnx_model_outputs(graph)
    return ModelInfo(in_spec, out_spec, layer_count, List[Str]())

fn parse_onnx_model_inputs(graph: PythonObject) raises -> List[InOutSpec]:
    var in_spec = List[InOutSpec]()
    let input_count = graph.input.__len__()
    for i in range(input_count):
        let name = Str(graph.input[i].name.to_string())
        let type_info = graph.input[i].type.tensor_type
        let shape = parse_shape(type_info.shape)
        in_spec.append(InOutSpec(name, shape))

    return in_spec

fn parse_onnx_model_outputs(graph: PythonObject) raises -> List[InOutSpec]:
    var out_spec = List[InOutSpec]()
    let output_count = graph.output.__len__()
    for i in range(output_count):
        let name = Str(graph.output[i].name.to_string())
        let type_info = graph.output[i].type.tensor_type
        let shape = parse_shape(type_info.shape)
        out_spec.append(InOutSpec(name, shape))

    return out_spec

fn parse_shape(onnx_shape: PythonObject) raises -> TensorShape:
    var shape =  TensorShape()
    for di in range(onnx_shape.dim.__len__()):
        let shape_str = Str(onnx_shape.dim[di].to_string())
        if shape_str.startswith("dim_param"):
            shape.append(-1)
        else:
            let val_str = shape_str.substr(Str("dim_value: ").size).strip()
            shape.append(atol(val_str.to_str()))
    return shape

fn main() raises:
    let onnx = Python.import_module('onnx')
    print('ONNX version: ', onnx.__version__)
    let args = argv()
    if len(args) == 1:
        raise Error("Enter path to .onnx model")
    let model = onnx.load(args[1])
    let model_info = parse_onnx_model(model)
    model_info.print()

