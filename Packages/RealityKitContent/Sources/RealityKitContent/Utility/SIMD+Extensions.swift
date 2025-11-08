//
//  SIMD+Extensions.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//

import RealityKit

public extension SIMD4 {
    
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}

public extension simd_float4x4 {
    
    var right: SIMD3<Float> {
        return columns.0.xyz
    }
    
    var up: SIMD3<Float> {
        return columns.1.xyz
    }
    
    var forward: SIMD3<Float> {
        return columns.2.xyz
    }
}
