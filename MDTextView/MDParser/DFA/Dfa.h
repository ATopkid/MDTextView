#import <Foundation/Foundation.h>

@class Node;

@interface Dfa : NSObject<NSCopying>

@property (nonatomic, strong) NSMutableSet<NSString *> *alphabet;
@property (nonatomic, strong) Node *start;
@property (nonatomic, strong) NSMutableSet<Node *> *stateNodes;
@property (nonatomic, strong) NSMutableSet<Node *> *end;
@property (nonatomic, assign) NSUInteger type;
@end
