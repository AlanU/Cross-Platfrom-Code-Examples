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
#import <Foundation/Foundation.h>

@interface AsyncClass : NSObject
-(void) simulatedAsyncWork: (NSUInteger) workTimeInMsec withData:(NSUInteger) dataToProcess dispatchSemaphore:(dispatch_semaphore_t) sNotify onComplete:(void(^)(NSUInteger)) completionHandler;
-(void) processData: (NSUInteger)  data ;

@end
@implementation AsyncClass

-(void) simulatedAsyncWork: (NSUInteger) workTimeInMsec withData:(NSUInteger)dataToProcess dispatchSemaphore:(dispatch_semaphore_t) sNotify onComplete:(void(^)(NSUInteger)) completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Doing Async Work For %lu ms on data %lu",workTimeInMsec,dataToProcess);
        [NSThread sleepForTimeInterval:workTimeInMsec/1000];
        NSLog(@"Async Work Done");
        completionHandler(dataToProcess+1);
        dispatch_semaphore_signal(sNotify);
    });
}

-(void) processData: (NSUInteger)  data {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block NSUInteger processedData = 0;
    [self simulatedAsyncWork:1000 withData:data dispatchSemaphore:sema onComplete:(^(NSUInteger value){
        processedData = value;
    }) ];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"Data Value After Work %lu ",processedData);
    
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AsyncClass * obj = [[AsyncClass alloc] init];
        [obj processData:3];
        
    }
    return 0;
}
