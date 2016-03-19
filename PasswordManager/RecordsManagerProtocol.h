
@protocol RecordsManagerProtocol <NSObject>

/**
 *  Registers the specified record.
 */
- (void)registerRecord:(NSDictionary *)record;

- (void)updateRecord:(NSDictionary *)record;

- (void)removeRecord:(NSDictionary *)record;


/**
 *  Returns the records the receiver manages.
 */
- (NSArray *)records;

@end
