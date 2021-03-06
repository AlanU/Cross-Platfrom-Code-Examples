/*
Copyright 2021 Alan Uthoff

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation

func simulatedAsyncWork( workTimeInMsec:  UInt, withData dataToProcess: UInt, dispatchSemaphore sNotify: DispatchSemaphore, onComplete completionHandler: @escaping (UInt) -> Void ) {
    let que = DispatchQueue.global(qos: .userInitiated)
    que.async {
        print("Doing Async Work For \(workTimeInMsec) ms on data \(dataToProcess) ")
        Thread.sleep(forTimeInterval:TimeInterval(workTimeInMsec/1000))
        print("Async Work Done")
        completionHandler(dataToProcess+1)
        sNotify.signal()
    }
}
    
func  processData( data: UInt) {
    let sema  = DispatchSemaphore(value: 0)
    var processedData: UInt = 0
    simulatedAsyncWork(workTimeInMsec: 1000, withData: data, dispatchSemaphore: sema, onComplete: { (value: UInt )-> Void in
        processedData = value
    })
    sema.wait()
    print("Data Value After Work \(processedData) ")
       
}

processData(data: 3)

