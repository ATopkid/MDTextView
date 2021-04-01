#import <Foundation/Foundation.h>

@class Node;

@interface DFATransfer : NSObject

@property (nonatomic, strong) NSMutableSet<Node *> *start;
@property (nonatomic, strong) NSMutableSet<Node *> *end;
@property (nonatomic, copy) NSString *ch;

- (instancetype)initWithStart:(NSMutableSet<Node *> *)start end:(NSMutableSet<Node *> *)end ch:(NSString *)ch;
@end
