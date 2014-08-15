#import "AFHTTPSessionManager.h"


@interface FakeAFHTTPSessionManager : AFHTTPSessionManager

@property (copy, nonatomic) NSString *postURLString;
@property (strong, nonatomic) id parameters;
@property (copy, nonatomic) void (^success)(NSURLSessionDataTask *task, id responseObject);
@property (copy, nonatomic) void (^failure)(NSURLSessionDataTask *task, NSError *error);

@end
