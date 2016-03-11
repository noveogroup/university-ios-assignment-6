#import "RecordsManager.h"
#import "Record.h"
#import "DatabaseManager.h"
#import "Preferences.h"

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSMutableArray *mutableRecordsDB;
@property (copy, nonatomic) NSMutableArray *temp;
@property (nonatomic, strong) NSURL *url;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize mutableRecords = mutableRecords_;
@synthesize mutableRecordsDB = mutableRecordsDB_;

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
        if ([[Preferences standardPreferences] saveMode] == SaveInFile) {
            [self.mutableRecords addObject:record];
        } else {
            [[DatabaseManager sharedManager] addRecord:record];
            [self.mutableRecordsDB addObject:record];
        }
    }
}

- (void)removeRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        
        if ([[Preferences standardPreferences] saveMode] == SaveInFile) {
            [self.mutableRecords removeObject:record];
        } else {
            [[DatabaseManager sharedManager] deleteRecord:record];
            [self.mutableRecordsDB removeObject:record];
        }
        
        

    }
}

- (void)replaceRecord:(NSDictionary *)record withNewRecord:(NSDictionary *)newRecord
{
    if ([[Preferences standardPreferences] saveMode] == SaveInFile) {
        [self.mutableRecords removeObject:record];
        [self.mutableRecords addObject:newRecord];
        [self synchronize];
    } else {
        [[DatabaseManager sharedManager] updateRecord:record fromNewRecord:newRecord];
        [self.mutableRecordsDB removeObject:record];
        [self.mutableRecordsDB addObject:newRecord];
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

- (NSMutableArray *)mutableRecordsDB
{
    if (!mutableRecordsDB_) {
        
        mutableRecordsDB_ = self.temp = [[[DatabaseManager sharedManager] getRecords] mutableCopy];
        if (!mutableRecordsDB_) {
            mutableRecordsDB_ = [NSMutableArray array];
        }
    }
    
    return mutableRecordsDB_;
}



- (NSArray *)records
{
    return [self.mutableRecords copy];
}

- (NSArray *)recordsDB
{
    return [self.mutableRecordsDB copy];
}



#pragma mark - Synchronisation

- (BOOL)synchronize
{
    if ([[Preferences standardPreferences] saveMode] == SaveInFile) {
        return [self.mutableRecords writeToURL:self.url atomically:YES];
    } else {
        return NO;
    }
}

@end
