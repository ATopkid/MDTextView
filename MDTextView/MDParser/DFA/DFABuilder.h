#import <Foundation/Foundation.h>
#import "Token.h"

@class Dfa;
@class Nfa;

@interface DFABuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary<Dfa *, NSNumber *> *dfa2Pattern;

- (Dfa *)convertNfa:(Nfa *)nfa tokenType:(TokenType)tokenType;

@end

