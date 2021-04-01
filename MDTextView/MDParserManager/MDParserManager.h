#import <Foundation/Foundation.h>

@class Dfa;

@interface MDParserManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<Dfa *> *allDfas;
@property (nonatomic, strong) NSMutableDictionary<Dfa *, NSNumber *> *dfa2Pattern;

+ (instancetype)sharedInstance;

@end
