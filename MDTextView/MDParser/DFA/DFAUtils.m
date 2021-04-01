#import "DFAUtils.h"
#import "Node.h"
#import "Edge.h"
#import "Nfa.h"
#import "Dfa.h"
#import "DFATransfer.h"
#import "Token.h"

@implementation DFAUtils

+ (Dfa *)subsetConstruction:(Nfa *)nfa {
    NSMutableArray <DFATransfer *> *DFATransferTable = [NSMutableArray array];
    
    Node *start = nfa.start;
    NSMutableArray<NSMutableSet<Node *> *> *q = [NSMutableArray array];//最后DFA里的状态
    NSMutableArray<NSMutableSet<Node *> *> *worklist = [NSMutableArray array];
    NSMutableSet<Node *> *nodeClosure = [self epsClosure:start];
    [q addObject:nodeClosure];
    
    [worklist addObject:nodeClosure];
    
    while (worklist.count) {
        NSMutableSet<Node *> *states = [worklist firstObject];
        [worklist removeObjectAtIndex:0];
        
        for (NSString *ch in nfa.alphabet) {
            NSMutableSet<Node *> *newStates = [self delta:states ch:ch];//能够吸收ch的新节点集合
            NSMutableSet<Node *> *newQ = [NSMutableSet set];//newStates的epsClosure
            for (Node *n in newStates) {
                [newQ unionSet:[self epsClosure:n]];
            }
            
            if (newQ.count) {
            DFATransfer *transfer = [[DFATransfer alloc] initWithStart:states end:newQ ch:ch];
                [DFATransferTable addObject:transfer];
                
                if (newQ.count && ![self isContainSet:newQ inArray:q]) {
                    [q addObject:newQ];
                    [worklist addObject:newQ];
                }
            }
        }
    }
    
    return [self equivalentDFA:nfa q:q transfers:DFATransferTable];
}

+ (Dfa *)equivalentDFA:(Nfa *)nfa q:(NSMutableArray<NSMutableSet<Node *> *> *)q transfers:(NSMutableArray <DFATransfer *> *)transfers {
    NSMutableSet<Node *> *dfaStatesNodes = [NSMutableSet set];
    NSMutableSet<Node *> *dfaEndNodes = [NSMutableSet set];
    Node *dfaStart;
    
    //nfa中点的集合对应dfa中的单个点
    NSMutableDictionary<NSMutableSet<Node *> *, Node *> *nfaStatesToDfaNode = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < q.count; i++) {
        NSMutableSet<Node *> *nfaState = q[i];
        
        Node *tmpDfaNode = [Node new];
        [dfaStatesNodes addObject:tmpDfaNode];
        [nfaStatesToDfaNode setObject:tmpDfaNode forKey:nfaState];
        
        if ([self isTerminatorSet:nfaState endNode:nfa.end]) {
            [dfaEndNodes addObject:tmpDfaNode];
        }
        
        if (i == 0) {
            dfaStart = tmpDfaNode;
        }
    }
    
    for (DFATransfer *trans in transfers) {
        Node *dfaFrom = [nfaStatesToDfaNode objectForKey:trans.start];
        Node *dfaTo = [nfaStatesToDfaNode objectForKey:trans.end];
        Edge *e = [[Edge alloc] initWithEndNode:dfaTo];
        e.ch = trans.ch;
        [dfaFrom.edges addObject:e];
    }
    
    Dfa *dfa = [Dfa new];
    dfa.start = dfaStart;
    dfa.stateNodes = dfaStatesNodes;
    dfa.alphabet = nfa.alphabet;
    dfa.end = dfaEndNodes;
    
    return dfa;
}

+ (NSMutableSet<Node *> *)delta:(NSMutableSet<Node *> *)nodes ch:(NSString *)ch {
    NSMutableSet<Node *> *result = [NSMutableSet set];
    for (Node *n in nodes) {
        for (Edge *e in n.edges) {
            if ([e.ch isEqualToString:ch]) {
                [result addObject:e.endNode];
            }
        }
    }
    
    return result;
}

+ (NSMutableSet<Node *> *)epsClosure:(Node *)node {
    NSMutableSet<Node *> *states = [NSMutableSet set];
    [states addObject:node];
    
    [self epsCloure:node states:states];
    return states;
}

+ (void)epsCloure:(Node *)node states:(NSMutableSet<Node *> *)states {
    [states addObject:node];
    for (Edge *e in node.edges) {
        if ([e.ch isEqualToString:@"ε"] && ![states containsObject:e.endNode]) {
            [self epsCloure:e.endNode states:states];
        }
    }
}

+ (BOOL)isContainSet:(NSMutableSet<Node*> *)set inArray:(NSMutableArray<NSMutableSet<Node*> *> *)arr {
    for (NSMutableSet<Node*> *tmp in arr) {
        if ([set isEqualToSet:tmp]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isTerminatorSet:(NSMutableSet<Node*> *)set endNode:(Node *)endNode {
    NSMutableSet *tmp = [set mutableCopy];
    NSMutableSet *endNodeSet = [NSMutableSet setWithObject:endNode];
    [tmp intersectSet:endNodeSet];
    return tmp.count ? YES : NO;
}



/// 最小化算法 hopcroft
+ (Dfa *)hopcroft:(Dfa *)dfa {
    NSMutableSet<Node*> *terminatorSet = [dfa.end mutableCopy];
    NSMutableSet<Node*> *nonTerminatorSet = [dfa.stateNodes mutableCopy];
    [nonTerminatorSet minusSet:terminatorSet];
    
    NSMutableArray <NSMutableSet<Node*> *> *allSets = [NSMutableArray array];
    if (nonTerminatorSet.count) {
        [allSets addObject:nonTerminatorSet];
    }
    [allSets addObject:terminatorSet];
    
    while (allSets.count) {
        BOOL canSplit = NO;
        for (int i = 0; i < allSets.count; i++) {
            NSMutableSet<Node*> *curNodes = allSets[i];
            if (curNodes.count == 1) {
                continue;
            }
            
            NSArray *alphabet = [dfa.alphabet allObjects];
            for (int j = 0; j < alphabet.count;) {
                NSString *ch = alphabet[j];
                NSMutableSet<Node*> *curNodes = allSets[i];
                NSMutableArray <NSMutableSet<Node*> *> * tempArray = [self split:dfa curNodes:curNodes allSets:allSets ch:ch];
                [allSets removeObjectAtIndex:i];
                [allSets insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(i, tempArray.count)]];
                
                if (tempArray.count > 1) {
                    //说明分成了两个集合，重新再来分
                    canSplit = YES;
                    j = 0;
                } else {
                    j++;
                }
            }
        }
        
        if (!canSplit) {
            break;
        }
    }
    
    return [self minimizeDFA:dfa nodeSets:allSets];
}

+ (NSMutableArray <NSMutableSet<Node*> *> *)split:(Dfa *)dfa curNodes:(NSMutableSet<Node*> *)curNodes allSets:(NSMutableArray<NSMutableSet<Node*> *> *)allSets ch:(NSString *)ch {
    //对这个集群新划分后的集群
    NSMutableArray <NSMutableSet<Node*> *> *resultSets = [NSMutableArray array];
    
    if (curNodes.count == 1) {
        [resultSets addObject:curNodes];
        return resultSets;
    }
    
    NSMutableSet<Node*> *successorNodes = [NSMutableSet set];
    NSMutableSet<Node*> *noSuccessorNodes = [NSMutableSet set];
    //先分成两部分： 能接收ch 不能接收ch
    for (Node *n in curNodes) {
        if (n.edges.count) {
            BOOL hasSuccessor = NO;
            for (Edge *e in n.edges) {
                if ([e.ch isEqualToString:ch]) {
                    hasSuccessor = YES;
                    break;
                }
            }
            if (hasSuccessor) {
                [successorNodes addObject:n];
            } else {
                [noSuccessorNodes addObject:n];
            }
            
        } else {
            [noSuccessorNodes addObject:n];
        }
    }
    
    if (noSuccessorNodes.count) {
        [resultSets addObject:noSuccessorNodes];
    }
    
    if (successorNodes.count) {
        //key为集群 value为新划分的节点
        NSMutableDictionary<NSMutableSet<Node*> *, NSMutableSet<Node*> *> *newSetsDict = [NSMutableDictionary dictionary];
        
        for (Node *node in successorNodes) {
            //node的儿子节点所包含的集群
            NSMutableSet<Node*> *nodesSonsNodes = [self nodeSonInCurNodes:allSets node:node ch:ch];
            //新划分的节点
            NSMutableSet<Node*> *newNodeSet = [newSetsDict objectForKey:nodesSonsNodes];
            if (newNodeSet) {
                [newNodeSet addObject:node];
            } else {
                NSMutableSet<Node*> *createNewNodeSet = [NSMutableSet set];
                [createNewNodeSet addObject:node];
                [newSetsDict setObject:createNewNodeSet forKey:nodesSonsNodes];
            }
        }
        
        if (newSetsDict.count > 1) {
            //有分化
            [newSetsDict enumerateKeysAndObjectsUsingBlock:^(NSMutableSet<Node *> * _Nonnull key, NSMutableSet<Node *> * _Nonnull obj, BOOL * _Nonnull stop) {
                [resultSets addObject:obj];
            }];
        } else {
            //无分化
            [resultSets addObject:successorNodes];
        }
    }
    
    return resultSets;
}

+ (NSMutableSet<Node*> *)nodeSonInCurNodes:(NSMutableArray<NSMutableSet<Node *> *> *)allSets node:(Node *)node ch:(NSString *)ch {
    Node *sonNode;
    for (Edge *e in node.edges) {
        if ([e.ch isEqualToString:ch]) {
            sonNode = e.endNode;
            break;;
        }
    }
    
    
    for (NSMutableSet<Node *> * set in allSets) {
        if ([set containsObject:sonNode]) {
            return set;
        }
    }
    
    return nil;
}

+ (Dfa *)minimizeDFA:(Dfa *)dfa nodeSets:(NSMutableArray<NSMutableSet<Node*> *> *)nodeSets {
    //这里面后面再设计下数据结构优化吧吧，先遍历
    
    Dfa *resultDfa = [Dfa new];
    
    //多个node处理成最终的一个node
    NSMutableArray<Node *> *groupNodes = [NSMutableArray array];
    for (NSMutableSet<Node*> *sets in nodeSets) {
        Node *node = [Node new];
        [groupNodes addObject:node];
        [resultDfa.stateNodes addObject:node];
    }
    
    for (int groupIndex = 0; groupIndex < nodeSets.count; groupIndex++) {
        //遍历每个集群
        NSMutableSet<Node*> *sets = nodeSets[groupIndex];
        for (Node *startNode in sets) {
            if (startNode == dfa.start) {
                resultDfa.start = groupNodes[groupIndex];
            }
            if ([dfa.end containsObject:startNode]) {
                [resultDfa.end addObject:groupNodes[groupIndex]];
            }
            //找到集群里每个node的子节点对应的集群
            for (int nodeIndexInGroup = 0; nodeIndexInGroup < nodeSets.count; nodeIndexInGroup++) {
                //拿到startNode后，对每一条Edge再去集群里找子节点属于哪一个集群
                for (Edge *e in startNode.edges) {
                    if ([nodeSets[nodeIndexInGroup] containsObject:e.endNode]) {
                        //去重
                        __block BOOL isRepeatEdge = NO;
                        [groupNodes[groupIndex].edges enumerateObjectsUsingBlock:^(Edge * _Nonnull obj, BOOL * _Nonnull stop) {
                            if ([obj.ch isEqualToString:e.ch]) {
                                isRepeatEdge = YES;
                                *stop = YES;
                            }
                        }];
                        if (!isRepeatEdge) {
                            Edge *groupEdge = [[Edge alloc] initWithEndNode:groupNodes[nodeIndexInGroup]];
                            groupEdge.ch = e.ch;
                            [groupNodes[groupIndex].edges addObject:groupEdge];
                        }
                        
                    }
                }
            }
        }
    }
    
    resultDfa.alphabet = dfa.alphabet;
    
    return resultDfa;
}

+ (Token *)tokenizer:(NSMutableString *)str inDfa:(Dfa *)dfa dfa2Pattern:(NSDictionary<Dfa *, NSNumber *> *)dfa2Pattern {
    Node *curNode = dfa.start;
    NSRange range;
    NSUInteger stopIndex = 0;
    for(int i = 0; i < str.length; i += range.length){
        range = [str rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *ch = [str substringWithRange:range];
        BOOL isFind = NO;

        for (Edge *e in curNode.edges) {
            if ([e.ch isEqualToString:ch]) {
                curNode = e.endNode;
                isFind = YES;
                break;
            }
        }
        if (!isFind) {
            stopIndex = i;
            break;
        }
        if (i == str.length - 1) {
            stopIndex = i + 1;
            break;
        }
    }
    if ([dfa.end containsObject:curNode]) {
        NSString *value = [str substringWithRange:NSMakeRange(0, stopIndex)];
        return [[Token alloc] initWithType:dfa.type value:value];
    } else {
        return nil;
    }
}

@end
