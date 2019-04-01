//
//  NSURLSession+PPSheep.m
//  Hook_NSURLSession
//
//  Created by ppsheep on 2018/3/6.
//  Copyright © 2018年 PPSHEEP. All rights reserved.
//

#import "NSURLSession+PPSheep.h"
#import <objc/runtime.h>

// MARK: - Hook Methods

// MARK: hook delegate 方法
static void Hook_Delegate_Method(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel, SEL noneSel) {
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method replaceMethod = class_getInstanceMethod(replaceClass, replaceSel);
    if (!originalMethod) {//没有实现delegate 方法
        Method noneMethod = class_getInstanceMethod(replaceClass, noneSel);
        BOOL didAddNoneMethod = class_addMethod(originalClass, originalSel, method_getImplementation(noneMethod), method_getTypeEncoding(noneMethod));
        if (didAddNoneMethod) {
            if ([NSURLSession isOpenDebugLog]) {
                NSLog(@"【NSURLSession Hook】--------没有实现的delegate方法添加成功");
            }
        }
        return;
    }
    BOOL didAddReplaceMethod = class_addMethod(originalClass, replaceSel, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    if (didAddReplaceMethod) {
        if ([NSURLSession isOpenDebugLog]) {
            NSLog(@"【NSURLSession Hook】--------hook方法添加成功");
        }
        Method newMethod = class_getInstanceMethod(originalClass, replaceSel);
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

// MARK: Hook 方法
static void Hook_Method(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel, BOOL isHookClassMethod) {
    Method originalMethod = NULL;
    Method replaceMethod = NULL;
    
    if (isHookClassMethod) {
        originalMethod = class_getClassMethod(originalClass, originalSel);
        replaceMethod = class_getClassMethod(replaceClass, replaceSel);
    } else {
        originalMethod = class_getInstanceMethod(originalClass, originalSel);
        replaceMethod = class_getInstanceMethod(replaceClass, replaceSel);
    }
    if (!originalMethod || !replaceMethod) {
        return;
    }
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP replaceIMP = method_getImplementation(replaceMethod);
    
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *replaceType = method_getTypeEncoding(replaceMethod);
    
    /*
     注意这里的class_replaceMethod方法，一定要先将替换方法的实现指向原实现，然后再将原实现指向替换方法，
     否则如果先替换原方法指向替换实现，那么如果在执行完这一句瞬间，原方法被调用，这时候，替换方法的实现还没有指向原实现，那么现在就造成了死循环
     */
    if (isHookClassMethod) {
        Class originalMetaClass = objc_getMetaClass(class_getName(originalClass));
        Class replaceMetaClass = objc_getMetaClass(class_getName(replaceClass));
        class_replaceMethod(replaceMetaClass,replaceSel,originalIMP,originalType);
        class_replaceMethod(originalMetaClass,originalSel,replaceIMP,replaceType);
    } else {
        class_replaceMethod(replaceClass,replaceSel,originalIMP,originalType);
        class_replaceMethod(originalClass,originalSel,replaceIMP,replaceType);
    }
}

// MARK: - NSURLSession+PPSheep

static void *varIsOpen = &varIsOpen;

@interface NSURLSession ()
@property (nonatomic, assign) BOOL isOpenLog;
@end

@implementation NSURLSession (PPSheep)

- (void)setIsOpenLog:(BOOL)isOpenLog {
    objc_setAssociatedObject(self, &varIsOpen, @(isOpenLog?1:0), OBJC_ASSOCIATION_COPY);
}

- (BOOL)isOpenLog {
    NSNumber *isOpen = objc_getAssociatedObject(self, &varIsOpen);
    return isOpen ? isOpen.boolValue : false;
}

+ (instancetype)dd_sharedInstance {
    static NSURLSession *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (BOOL)isOpenDebugLog {
    return [NSURLSession dd_sharedInstance].isOpenLog;
}

+ (void)setupSwizzleAndOpenLog:(BOOL)open {
    [NSURLSession dd_sharedInstance].isOpenLog = open;
    
    Class cls = [self class];
    Hook_Method(cls, @selector(sessionWithConfiguration:delegate:delegateQueue:), cls, @selector(hook_sessionWithConfiguration:delegate:delegateQueue:),YES);
    Hook_Method(cls, @selector(dataTaskWithRequest:completionHandler:), cls, @selector(hook_dataTaskWithRequest:completionHandler:),NO);
}

+ (NSURLSession *)hook_sessionWithConfiguration: (NSURLSessionConfiguration *)configuration delegate: (id<NSURLSessionDelegate>)delegate delegateQueue: (NSOperationQueue *)queue {
    if (delegate) {
        Hook_Delegate_Method([delegate class], @selector(URLSession:dataTask:didReceiveData:), [self class], @selector(hook_URLSession:dataTask:didReceiveData:), @selector(none_URLSession:dataTask:didReceiveData:));
    }
    
    return [self hook_sessionWithConfiguration: configuration delegate: delegate delegateQueue: queue];
}

- (NSURLSessionDataTask *)hook_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    
    void (^customBlock)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
        
        //请求完成的回调
        [NSURLSession httpResponseWith:request data:data];
    };
    
    //发起请求
    [NSURLSession httpRequestWith:request];
    
    if (completionHandler) {
        return [self hook_dataTaskWithRequest:request completionHandler:customBlock];
    } else {
        return [self hook_dataTaskWithRequest:request completionHandler:nil];
    }
}

- (void)hook_URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
         didReceiveData:(NSData *)data {
    
    [NSURLSession httpResponseWith:dataTask.originalRequest data:data];
    
    [self hook_URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)none_URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
         didReceiveData:(NSData *)data {
    NSLog(@"11");
}

// MARK: - DealWith Hook

// MARK: 处理发起请求
+ (void)httpRequestWith:(NSURLRequest *)request {
    NSDictionary *dict = @{@"method"    : request.HTTPMethod ? request.HTTPMethod : @"http_method_unknow",
                           @"url"       : request.URL.absoluteString ? request.URL.absoluteString : @"http_url_unknow",
                           @"headers"   : request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @{},
                           @"parameters": [NSURLSession requestParameterWith:request]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLSession_Hook_Request" object:nil userInfo:dict];
    if ([NSURLSession dd_sharedInstance].isOpenLog) {
        NSLog(@"【NSURLSession Hook】--------request: %@", dict);
    }
}

// MARK: 处理请求响应
+ (void)httpResponseWith:(NSURLRequest *)request data:(NSData *)data {
    NSError *error;
    NSDictionary *response;
    if (data != nil) {
        response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    else {
        NSLog(@"差点崩溃了。。。😂😂😂😂😂😂😂😂😂😂😂😂");
    }
    
    NSDictionary *dict = @{@"method"    : request.HTTPMethod ? request.HTTPMethod : @"http_method_unknow",
                           @"url"       : request.URL.absoluteString ? request.URL.absoluteString : @"http_url_unknow",
                           @"headers"   : request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @{},
                           @"parameters": [NSURLSession requestParameterWith:request],
                           @"response"  : response ? response : @{}};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLSession_Hook_Response" object:nil userInfo:dict];
    if ([NSURLSession dd_sharedInstance].isOpenLog) {
        NSLog(@"【NSURLSession Hook】--------response: %@", dict);
    }
}

// MARK: 获取请求参数
+ (NSDictionary *)requestParameterWith:(NSURLRequest *)request {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (request.HTTPBody) {
        NSString *aString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSArray *params = [aString componentsSeparatedByString:@"&"];
        for (NSString *subString in params) {
            NSArray *subParams = [subString componentsSeparatedByString:@"="];
            if (subParams.count == 2) {
                NSString *key = [NSString stringWithFormat:@"%@", subParams[0]];
                NSString *value = [NSString stringWithFormat:@"%@", subParams[1]];
                [paramsDict setValue:value forKey:key];
            }
        }
    }
    return paramsDict;
}

@end

