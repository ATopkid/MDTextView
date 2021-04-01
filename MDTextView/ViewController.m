#import "ViewController.h"
#import "MDParserManager.h"
#import "MDParser.h"
#import <CoreText/CoreText.h>
#import "MDView.h"
#import "MDCtFrameBuilder.h"
#import "MDViewFrameRef.h"
#import "MDCtFrameTokenHyperlinks.h"
#import "CTFrameParserConfig.h"
#import "ASTTokenUtils.h"

@interface ViewController ()<MDViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDParser *p = [MDParser new];
    ASTNode *root = [p startParser];
    
    
    CGRect frame = CGRectMake(100, 100, 200, 100);
    
    MDCtFrameTokenHyperlinks *token = [ASTTokenUtils frameTokenWithNode:root];
    CTFrameParserConfig *config = [CTFrameParserConfig new];
    config.width = frame.size.width;
    config.height = frame.size.height;
    config.edgeInsets = UIEdgeInsetsMake(-10, 10, 0, 0);
    
    
    MDViewFrameRef *frameRef = [MDCtFrameBuilder parseContent:token.allContent config:config tokens:@[token]];;
    
    MDView *mdView = [[MDView alloc] initWithFrame:frame];
    mdView.delegate = self;
    mdView.frameRef = frameRef;
    [self.view addSubview:mdView];
    mdView.backgroundColor = [UIColor yellowColor];
}

- (void)mdView:(MDView *)view didClickHyperlinks:(NSString *)url {
    NSLog(@"did click url = %@", url);
}

@end
