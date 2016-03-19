
#import "RecordsPlistStorageManager.h"

@interface RecordsPlistStorageManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;

@end

@implementation RecordsPlistStorageManager

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


- (void)updateRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        NSInteger index = 0;
        for (int i = 0; i < [self.mutableRecords count]; i++) {
            NSDictionary* dict = [self.mutableRecords objectAtIndex:i];
            if ([dict[@"id"] isEqualToString:record[@"id"]]) {
                index = i;
                break;
            }
        }
        [self.mutableRecords replaceObjectAtIndex:index withObject:record];
    }
}

- (void)removeRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords removeObject:record];
    }
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
