#import "NFAUtils.h"
#import "Nfa.h"
#import "Node.h"
#import "Edge.h"


@implementation NFAUtils

+ (Nfa *)char2nfa:(NSString *)ch {
    //初始状态
    Node *start = [Node new];
    //终止状态
    Node *end = [Node new];
    
    //字母表
    NSMutableSet<NSString *> *alphabet = [NSMutableSet set];
    [alphabet addObject:ch];
    
    //转移函数
    Edge *edge = [Edge new];
    edge.ch = ch;
    edge.endNode = end;
    start.edges = [NSMutableSet setWithObject:edge];
    
    //状态集
    NSMutableSet<Node *> *stateNodes = [NSMutableSet set];
    [stateNodes addObject:start];
    [stateNodes addObject:end];
    
    Nfa *nfa = [Nfa new];
    nfa.alphabet = alphabet;
    nfa.start = start;
//    nfa.convertEdges = edges;
    nfa.stateNodes = stateNodes;
    nfa.end = end;
    
    return nfa;
}

+ (Nfa *)join:(Nfa *)nfa1 and:(Nfa *)nfa2 {
    //增加ε边
    
    Edge *newEdge = [Edge new];
    newEdge.ch = @"ε";
    newEdge.endNode = nfa2.start;
    NSMutableSet<Edge *> *edges = [NSMutableSet set];
    [edges addObject:newEdge];
    nfa1.end.edges = edges;
    
    //字符集取并集
    [nfa1.alphabet unionSet:nfa2.alphabet];
    [nfa1.stateNodes unionSet:nfa2.stateNodes];
    nfa1.end = nfa2.end;
    
    return nfa1;
}

+ (Nfa *)or:(Nfa *)nfa1 and:(Nfa *)nfa2 {
    Node *newStart = [Node new];
    
    Edge *edge1 = [Edge new];
    edge1.ch = @"ε";
    edge1.endNode = nfa1.start;

    Edge *edge2 = [Edge new];
    edge2.ch = @"ε";
    edge2.endNode = nfa2.start;
    
    [newStart.edges addObject:edge1];
    [newStart.edges addObject:edge2];
    
    Node *newEnd = [Node new];
    Edge *edge3 = [Edge new];
    edge3.ch = @"ε";
    edge3.endNode = newEnd;

    Edge *edge4 = [Edge new];
    edge4.ch = @"ε";
    edge4.endNode = newEnd;
    
    nfa1.end.edges = [NSMutableSet setWithArray:@[edge3]];
    nfa2.end.edges = [NSMutableSet setWithArray:@[edge3]];
    
    Nfa *newNfa = [Nfa new];
    newNfa.start = newStart;
    newNfa.end = newEnd;
    [nfa1.alphabet unionSet:nfa2.alphabet];
    newNfa.alphabet = nfa1.alphabet;
    [nfa1.stateNodes unionSet:nfa2.stateNodes];
    [nfa1.stateNodes addObjectsFromArray:@[newStart, newEnd]];
    newNfa.stateNodes = nfa1.stateNodes ;
    
    return newNfa;
}



+ (Nfa *)closure:(Nfa *)nfa {
    Node *newStart = [Node new];
    Node *newEnd = [Node new];
    
    Edge *startEdge1 = [Edge new];
    startEdge1.ch = @"ε";
    startEdge1.endNode = nfa.start;
    
    Edge *startEdge2 = [Edge new];
    startEdge2.ch = @"ε";
    startEdge2.endNode = newEnd;
    
    newStart.edges = [NSMutableSet setWithArray:@[startEdge1, startEdge2]];
    
    Edge *endEdge = [Edge new];
    endEdge.ch = @"ε";
    endEdge.endNode = newEnd;
    
    Edge *midEdge = [Edge new];
    midEdge.ch = @"ε";
    midEdge.endNode = nfa.start;
    
    nfa.end.edges = [NSMutableSet setWithArray:@[endEdge, midEdge]];

    nfa.start = newStart;
    nfa.end = newEnd;
    [nfa.stateNodes addObjectsFromArray:@[newStart, newEnd]];
    
    return nfa;
}

@end
