//: Playground - noun: a place where people can play

import UIKit


struct Vector3{
    
    var x:Double = 0.0
    var y:Double = 0.0
    var z:Double = 0.0
    
    subscript(index:Int) -> Double?{
        
        get{
            switch index{
            case 0: return x
            case 1: return y
            case 2: return z
            default: return nil
            }
        }
        
        set{
            guard let newValue = newValue else{ return }
            
            switch index{
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default: return
            }
        }
    }
    
    subscript(axis:String) -> Double?{
        
        get{
            switch axis{
            case "x","X": return x
            case "y","Y": return y
            case "z","Z": return z
            default: return nil
            }
        }
        
        set{
            guard let newValue = newValue else{ return }
            
            switch axis{
            case "x","X": x = newValue
            case "y","Y": y = newValue
            case "z","Z": z = newValue
            default: return
            }
        }
    }
    
    func length() -> Double{
        return sqrt( x*x + y*y + z*z )
    }
}

func + (left: Vector3, right: Vector3) -> Vector3{
    return Vector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func - (left: Vector3, right: Vector3) -> Vector3{
    return Vector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

func * (left: Vector3, right: Vector3) -> Double{
    return left.x * right.x + left.y * right.y + left.z * right.z
}

func * (left: Vector3, a: Double) -> Vector3{
    return Vector3(x: left.x * a, y: left.y * a, z: left.z * a)
}

func += ( left: inout Vector3, right: Vector3){
    left = left + right
}

