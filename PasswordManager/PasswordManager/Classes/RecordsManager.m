#import "RecordsManager.h"
#import "Record.h"

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize mutableRecords = mutableRecords_;

#pragma mark - Initialization

- (id)init
{
    NSLog(@"Please use -initWithURL: instead.");
    [self doesNotRecognizeSelector:_cmd];

    return nil;
}

- (instancetype)initWithURL:(NSURL *)url
{
    if ((self = [super init])) {
        url_ = url;
    }

    return self;
}

#pragma mark - Management of records

- (void)registerRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords addObject:record];
    }
}

- (void)removeRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords removeObject:record];
    }
}

- (void)replaceRecord:(NSDictionary *)record withNewRecord:(NSDictionary *)newRecord
{
    [self.mutableRecords removeObject:record];
    [self registerRecord:newRecord];
    [self synchronize];
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_) {
        mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
        if (!mutableRecords_) {
            mutableRecords_ = [NSMutableArray array];
        }
    }

    return mutableRecords_;
}

- (NSArray *)records
{
    return [self.mutableRecords copy];
}

#pragma mark - Synchronisation

- (BOOL)synchronize
{
    return [self.mutableRecords writeToURL:self.url atomically:YES];
}

@end
