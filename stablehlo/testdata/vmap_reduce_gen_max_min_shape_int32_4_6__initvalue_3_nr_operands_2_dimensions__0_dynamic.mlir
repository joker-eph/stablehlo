// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x4x6xi32> {mhlo.sharding = ""}, %arg2: tensor<?x4x6xi32> {mhlo.sharding = ""}) -> (tensor<?x6xi32>, tensor<?x6xi32>) {
    %0 = stablehlo.constant dense<3> : tensor<i32>
    %1 = stablehlo.constant dense<0> : tensor<i32>
    %2:2 = stablehlo.reduce(%arg1 init: %0), (%arg2 init: %1) across dimensions = [1] : (tensor<?x4x6xi32>, tensor<?x4x6xi32>, tensor<i32>, tensor<i32>) -> (tensor<?x6xi32>, tensor<?x6xi32>)
     reducer(%arg3: tensor<i32>, %arg5: tensor<i32>) (%arg4: tensor<i32>, %arg6: tensor<i32>)  {
      %3 = stablehlo.maximum %arg3, %arg5 : tensor<i32>
      %4 = stablehlo.minimum %arg4, %arg6 : tensor<i32>
      stablehlo.return %3, %4 : tensor<i32>, tensor<i32>
    }
    return %2#0, %2#1 : tensor<?x6xi32>, tensor<?x6xi32>
  }
}

