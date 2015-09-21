//
//  MockingBirdRequestRec.m
//
//  Created by Giuseppe Bruno on 15/09/15.
//  Copyright (c) 2015 Vendini, Inc. All rights reserved.
//

#import "MockingBirdRequestRec.h"
#import <objc/runtime.h> // Needed for method swizzling

// An example of the possible elements contained on arrayConnectionData
// arrayConnectionData[0] = Connection_1
// arrayConnectionData[1] = ResponseHeader Of Connection_1
//
// arrayConnectionData[2] = Connection_2
// arrayConnectionData[3] = ResponseHeader Of Connection_2
// arrayConnectionData[4] = ResponseBody Of Connection_2
//
// arrayConnectionData[5] = Connection_3
// arrayConnectionData[6] = ResponseHeader Of Connection_3
// arrayConnectionData[7] = ResponseBody Of Connection_3
//
// arrayConnectionData[8] = Connection_4
// arrayConnectionData[9] = ResponseHeader Of Connection_4
//
// Note: to note that in same cases the responseBody can not be received
NSMutableArray *arrayConnectionData;

static const NSInteger CASE_1 = 1;
static const NSInteger CASE_2 = 2;
static const NSInteger CASE_3 = 3;

static NSString *pathFile = @"";
static Boolean stateRecord = NO;

@implementation MockingBirdRequestRec

+ (void)load {

    arrayConnectionData = [[NSMutableArray alloc] init];
    stateRecord = NO;
}

+ (void)setPathForRecording:(NSString *)path {
    pathFile = path;
}

+ (void)setRecordingOn:(BOOL)record{

    //If neither the first condition is verified nor the second condition is verified, means that the start record or the stop record are called two times consecutively
    if ((record && !stateRecord) || (!record && stateRecord)) {
        if (record) {
            NSAssert(![pathFile isEqualToString:@""], @"Path for record web response is nil");
        }

        stateRecord = record;

        int numClasses;
        Class *classes = NULL;
        numClasses = objc_getClassList(NULL, 0);

        if (numClasses > 0 )
        {
            classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            for (int i = 0; i < numClasses; i++) {
                if(class_conformsToProtocol(classes[i], @protocol(NSURLConnectionDataDelegate)) || class_conformsToProtocol(classes[i], @protocol(NSURLConnectionDelegate))) {

                    unsigned int methodCount = 0;
                    Method *methods = class_copyMethodList(classes[i], &methodCount);

                    BOOL isPresentConnectionDidReceiveResponse = NO;
                    BOOL isPresentConnectionDidReceiveData = NO;
                    BOOL isPresentConnectionDidFinishLoading = NO;

                    for (unsigned int i = 0; i < methodCount; i++) {
                        Method method = methods[i];

                        if (strcmp(sel_getName(method_getName(method)), "connection:didReceiveResponse:")) {
                            isPresentConnectionDidReceiveResponse = YES;
                        }
                        if (strcmp(sel_getName(method_getName(method)), "connection:didReceiveData:")) {
                            isPresentConnectionDidReceiveData = YES;
                        }
                        if (strcmp(sel_getName(method_getName(method)), "connectionDidFinishLoading:")) {
                            isPresentConnectionDidFinishLoading = YES;
                        }
                    }

                    if( isPresentConnectionDidReceiveResponse && isPresentConnectionDidReceiveData && isPresentConnectionDidFinishLoading) {
                        printf("\t%s can be swizzled \n", class_getName(classes[i]));

                        Class class =  classes[i];

                        //Added this method to improve the readibility of the code
                        SEL selectorReturnCaseNumberFromConnectionAndArray = @selector(returnCaseNumberFromConnection:andArray:);
                        Method methodReturnCaseNumberFromConnectionAndArray = class_getInstanceMethod([self class], selectorReturnCaseNumberFromConnectionAndArray);
                        class_addMethod(class,
                                        selectorReturnCaseNumberFromConnectionAndArray,
                                        method_getImplementation(methodReturnCaseNumberFromConnectionAndArray),
                                        method_getTypeEncoding(methodReturnCaseNumberFromConnectionAndArray));

                        //Swizzling connection:didReceiveResponse:
                        SEL originalSelectorReceiveResponse = @selector(connection:didReceiveResponse:);
                        SEL swizzledSelectorReceiveResponse = @selector(swizzled_connection:didReceiveResponse:);

                        Method originalMethodReceiveResponse = class_getInstanceMethod(class, originalSelectorReceiveResponse);
                        Method swizzledMethodReceiveResponse = class_getInstanceMethod([self class], swizzledSelectorReceiveResponse);

                        class_addMethod(class,
                                        swizzledSelectorReceiveResponse,
                                        method_getImplementation(swizzledMethodReceiveResponse),
                                        method_getTypeEncoding(swizzledMethodReceiveResponse));

                        originalMethodReceiveResponse = class_getInstanceMethod(class, originalSelectorReceiveResponse);
                        swizzledMethodReceiveResponse = class_getInstanceMethod(class, swizzledSelectorReceiveResponse);

                        method_exchangeImplementations(originalMethodReceiveResponse, swizzledMethodReceiveResponse);

                        //Swizzling connection:didReceiveData
                        SEL originalSelectorReceiveData = @selector(connection:didReceiveData:);
                        SEL swizzledSelectorReceiveData = @selector(swizzled_connection:didReceiveData:);

                        Method originalMethodReceiveData = class_getInstanceMethod(class, originalSelectorReceiveData);
                        Method swizzledMethodReceiveData = class_getInstanceMethod([self class], swizzledSelectorReceiveData);

                        class_addMethod(class,
                                        swizzledSelectorReceiveData,
                                        method_getImplementation(swizzledMethodReceiveData),
                                        method_getTypeEncoding(swizzledMethodReceiveData));

                        originalMethodReceiveData = class_getInstanceMethod(class, originalSelectorReceiveData);
                        swizzledMethodReceiveData = class_getInstanceMethod(class, swizzledSelectorReceiveData);

                        method_exchangeImplementations(originalMethodReceiveData, swizzledMethodReceiveData);

                        //Swizzling connectionDidFinishLoading:
                        SEL originalSelectorFinishLoading = @selector(connectionDidFinishLoading:);
                        SEL swizzledSelectorFinishLoading = @selector(swizzled_connectionDidFinishLoading:);

                        Method originalMethodFinishLoading = class_getInstanceMethod(class, originalSelectorFinishLoading);
                        Method swizzledMethodFinishLoading = class_getInstanceMethod([self class], swizzledSelectorFinishLoading);
                        
                        class_addMethod(class,
                                        swizzledSelectorFinishLoading,
                                        method_getImplementation(swizzledMethodFinishLoading),
                                        method_getTypeEncoding(swizzledMethodFinishLoading));
                        
                        originalMethodFinishLoading = class_getInstanceMethod(class, originalSelectorFinishLoading);
                        swizzledMethodFinishLoading = class_getInstanceMethod(class, swizzledSelectorFinishLoading);
                        
                        method_exchangeImplementations(originalMethodFinishLoading, swizzledMethodFinishLoading);
                    }
                }
            }
            free(classes);
        }
    }
}

#pragma mark - Methods Swizzling

- (void)swizzled_connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    [self swizzled_connection:connection didReceiveResponse:response];

    // At first time it has to add the connection and the response header on arrayConnectionData
    if (![arrayConnectionData containsObject:connection]) {
        [arrayConnectionData addObject:connection];
        [arrayConnectionData addObject:[(NSHTTPURLResponse *)response allHeaderFields]];
    }
}

- (void)swizzled_connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    [self swizzled_connection:connection didReceiveData:data];

    NSInteger caseNumberOfThisConnection = [self returnCaseNumberFromConnection:connection andArray:arrayConnectionData];

    // Add the data response received now in the last position
    if (caseNumberOfThisConnection == CASE_1) {
        [arrayConnectionData addObject:data];
    }

    // Append the data response received now on the data response already received
    if (caseNumberOfThisConnection == CASE_2) {
        NSMutableData *dataToAppend = [arrayConnectionData objectAtIndex:[arrayConnectionData indexOfObject:connection] + 2];
        [dataToAppend appendData:data];
        arrayConnectionData[[arrayConnectionData indexOfObject:connection] + 2] = dataToAppend;
    }

    // Add the data response received now in the correct position, and it shifts the next elements correctly
    if (caseNumberOfThisConnection == CASE_3) {
        [arrayConnectionData insertObject:data atIndex:[arrayConnectionData indexOfObject:connection] + 2];
    }
}

- (void)swizzled_connectionDidFinishLoading:(NSURLConnection *)connection {

    [self swizzled_connectionDidFinishLoading:connection];

    if ([arrayConnectionData containsObject:connection]) {
        NSError  *error = nil;

        NSString *stringJSON;
        NSInteger caseNumberOfThisConnection = [self returnCaseNumberFromConnection:connection andArray:arrayConnectionData];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:[pathFile stringByReplacingOccurrencesOfString:[pathFile lastPathComponent] withString:@""] withIntermediateDirectories:YES attributes:nil error:&error];

        // There is only a response header to sent
        if (caseNumberOfThisConnection == CASE_1 || caseNumberOfThisConnection == CASE_3) {
            stringJSON = @"";
        }

        // It values stringJSON with the correct response body to sent
        if (caseNumberOfThisConnection == CASE_2) {
            NSMutableData *data = [arrayConnectionData objectAtIndex:[arrayConnectionData indexOfObject:connection] + 2];
            stringJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }

        // It values the response header to sent
        NSData *dataResponseHeader = [NSJSONSerialization dataWithJSONObject:[arrayConnectionData objectAtIndex:[arrayConnectionData indexOfObject:connection] + 1] options:0 error:&error];
        NSString *responseHeader = [[NSString alloc] initWithData:dataResponseHeader encoding:NSUTF8StringEncoding];

        [arrayConnectionData removeObjectAtIndex:[arrayConnectionData indexOfObject:connection]];

        NSString *responseBody = stringJSON;
        NSString *url = [connection.originalRequest.URL.host stringByAppendingString:connection.originalRequest.URL.path];
        NSString *method = connection.originalRequest.HTTPMethod;
        NSString *params = connection.originalRequest.HTTPBody ? [[NSString alloc] initWithData:connection.originalRequest.HTTPBody encoding:NSUTF8StringEncoding] : @"";

        // Put a token of the start and the stop to identifier where the mac address is into the params string
        //NSString *currentMacAddress = [[[UIDevice currentDevice] macaddress] stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        //params = [params stringByReplacingOccurrencesOfString:currentMacAddress withString:[NSString stringWithFormat:@"<START-MACADDRESS>%@<END-MACADDRESS>", currentMacAddress]];

        // It checks out that the params are structured like JSON format, and if it is so, then it replace " with \",
        // otherwise it can occur that the params will not read correctly
        NSData *dataToCheck = [params dataUsingEncoding:NSUTF8StringEncoding];
        if ([NSJSONSerialization isValidJSONObject:[NSJSONSerialization JSONObjectWithData:dataToCheck options:0 error:&error]]) {
            params = [params stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        };

        // TODO: in the next release implement also the pairing with the header
        NSString *newPairing = [NSString stringWithFormat:@"{\n"
                                @"      \"responseHeader\": [%@] ,\n"
                                @"      \"responseBody\": [%@] ,\n"
                                @"      \"url\": \"%@\" ,\n"
                                @"      \"method\": \"%@\" ,\n"
                                @"      \"params\": \"%@\" \n"
                                @"},\n"
                                @"] }"
                                , ![responseHeader isEqualToString:@""] ? responseHeader : @"{\"NoHeaderKey\":\"NoHeaderValue\"}", ![responseBody isEqualToString:@""] ? responseBody : @"{\"NoBodyKey\":\"NoBodyValue\"}", url, method, params];

        NSString *contents = [NSString stringWithContentsOfFile:pathFile encoding:NSDataReadingMapped error:&error];
        NSLog(@"Read returned error: %@", [error localizedDescription]);

        // Removes the closure character
        contents = [[contents substringToIndex:contents.length - 3] stringByAppendingString:newPairing];

        // If the file "pair_%@.json" not exists, initialize the file with newPairing, else newPairing is appended at the end of the file
        [contents ? contents : [NSString stringWithFormat:@"{\"requestStubs\": [\n%@", newPairing] writeToFile:pathFile atomically:YES encoding:NSDataWritingAtomic error:&error];
    }
}

- (NSInteger)returnCaseNumberFromConnection:(NSURLConnection *)connection andArray:(NSMutableArray *)array
{
    if (array.count - 2  == [array indexOfObject:connection]) {

        // Return CASE_1 when the connection received is the last connection added
        // on array and it never received any data response
        return CASE_1;
    }

    id dataOrConnectionObject = [array objectAtIndex:[array indexOfObject:connection] + 2];
    if ([dataOrConnectionObject isKindOfClass:[NSData class]]) {

        // Return CASE_2 when the connection received has already received some data response
        return CASE_2;
    }
    
    // Return CASE_3 when the connection received isn't the last connection added,
    // and it never received any data response again
    return CASE_3;
}

@end
