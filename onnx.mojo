from python import Python, PythonObject
from utils.vector import DynamicVector

alias TensorShape = DynamicVector[Int]

struct InputOutputSpec:
    var name: String
    var shape: TensorShape
    fn __init__(inout self, name: String, shape: TensorShape):
        self.name = name
        self.shape = shape

struct ModelInfo:
    var in_spec: DynamicVector[InputOutputSpec]
    var out_spec: DynamicVector[InputOutputSpec]
    var layer_count: Int
    var ops: DynamicVector[String]
    fn __init__(inout self, input_spec: DynamicVector[InputOutputSpec], output_spec: DynamicVector[InputOutputSpec], layer_count: Int, operators: DynamicVector[String]): 
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
        let name: String = input_i.name.to_string()
        print(i, name)
        var shape =  TensorShape()
        let type_info = input_i.type.tensor_type
        for di in range(type_info.shape.dim.__len__()):
            let s = type_info.shape.dim[di].to_string()
            if startswith(s, "dim_param"):
                print_no_newline("dynamic ")
            else:
                print_no_newline("static ")
            print(s)
        #in_spec.push_back(InputOutputSpec(name, shape))

fn startswith(s: String, prefix: StringRef) -> Bool:
    let pref_len = len(prefix)
    if pref_len > len(s):
        return False
    for i in range(pref_len):
        if s[i] != prefix[i]:
            return False
    return True

#fn remove_prefix(s: String, prefix: StringRef) -> String:
#    if not startswith(s, prefix):
#        return String(s)
#    var out = String




fn main() raises:
    let onnx = Python.import_module('onnx')
    print(onnx.__version__)
    let model = onnx.load('mobilenetv2-10.onnx')
    parse_onnx_model(model)
    
