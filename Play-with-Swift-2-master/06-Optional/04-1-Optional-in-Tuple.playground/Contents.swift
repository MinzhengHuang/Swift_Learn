//: Playground - noun: a place where people can play

import UIKit


var error1:(errorCode: Int, errorMessage: String?) = ( 404 , "Not Found")
error1.errorMessage = nil
error1
//error1 = nil


var error2:(errorCode: Int, errorMessage: String)? = ( 404 , "Not Found")
//error2?.errorMessage = nil
error2 = nil
error2



var error3:(errorCode: Int, errorMessage: String?)? = ( 404 , "Not Found")
error3 = nil

