// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<7x3x4xf32>, tensor<7x4xf32>)
    %1 = call @expected() : () -> tensor<7x3xf32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2], rhs_contracting_dimensions = [1]>, precision_config = [#stablehlo<precision HIGH>, #stablehlo<precision HIGH>]} : (tensor<7x3x4xf32>, tensor<7x4xf32>) -> tensor<7x3xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<7x3xf32>, tensor<7x3xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<7x3x4xf32>, tensor<7x4xf32>) {
    %0 = stablehlo.constant dense<[[[-0.861273109, -0.927416443, 2.32744551, 1.01382327], [-1.48241365, 0.0152922533, 1.26526964, -2.97614121], [-1.46110249, 7.97533083, -3.63552499, 1.84457839]], [[2.70225811, 2.91806388, 0.758554935, 1.52800226], [1.15366614, 5.1582756, -0.221454948, 1.35351086], [1.17853248, -3.59188437, -0.723322212, -0.950476825]], [[-0.769597053, 2.71158886, 2.72135115, -5.51932383], [3.77560019, -1.63311791, 1.07212794, -3.49380875], [-7.13428592, 5.91989756, -1.44987071, 2.60052943]], [[-3.48048377, -6.794250e-01, 0.153022796, 1.73599458], [2.37025404, -1.12960434, 4.4952116, -2.43578768], [1.57419598, -2.69915938, -1.18586767, 4.72123861]], [[-4.41875601, -0.0591290183, 0.135081321, -2.111238], [2.95526934, -3.83894515, 4.529730e+00, 5.33372641], [4.19227028, 2.83393908, -0.865940868, -1.99223137]], [[2.5249052, 5.23220253, -4.17004061, -1.4402467], [-1.26621139, -4.08804893, 4.47118473, 5.570990e-01], [-2.34240031, -5.116430e-01, -1.27985525, 1.26461029]], [[7.32419395, -4.74166727, 0.748232901, -5.51570415], [3.25505733, -2.29070377, 3.5836587, 3.23820543], [-1.24842155, -2.85214615, 0.00422582868, 0.517248809]]]> : tensor<7x3x4xf32>
    %1 = stablehlo.constant dense<[[-5.1924243, -0.928009927, -0.437548935, 9.28280925], [1.85321128, -1.48467863, -1.07594383, -2.40664816], [-1.17404652, 2.502666, 0.518370926, 1.27496457], [-1.63811266, -5.46082735, -2.40953398, 2.54860377], [-2.35750461, -3.69663882, 5.45242882, -5.31360769], [-3.10886621, 0.598701417, -5.08749866, -2.363120e+00], [-3.76133776, -1.52654517, -1.66174567, 5.503200e+00]]> : tensor<7x4xf32>
    return %0, %1 : tensor<7x3x4xf32>, tensor<7x4xf32>
  }
  func.func private @expected() -> tensor<7x3xf32> {
    %0 = stablehlo.constant dense<[[13.7255039, -20.4974384, 18.8990669], [-3.81805801, -8.53954601, 10.5825815], [2.06347108, -12.418602, 25.7555199], [13.4672956, -14.7533922, 27.0508881], [22.5906277, 3.58083344, -14.4948921], [19.9014874, -22.5746765, 10.498723], [-51.907795, 3.118855, 11.8891659]]> : tensor<7x3xf32>
    return %0 : tensor<7x3xf32>
  }
}
