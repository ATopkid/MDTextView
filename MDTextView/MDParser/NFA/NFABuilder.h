#import <Foundation/Foundation.h>
#import "Token.h"

@class Nfa;

@interface NFABuilder : NSObject

@property (nonatomic, strong) NSMutableArray<Nfa *> *nfas;//存后缀表达式操作数的栈
@property (nonatomic, strong) NSMutableDictionary<Nfa *, NSNumber *> *nfa2Pattern;

- (Nfa *)convertRe:(NSString *)re tokenType:(TokenType)tokenType;

@end
