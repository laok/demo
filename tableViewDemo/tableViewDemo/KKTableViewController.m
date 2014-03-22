//
//  KKTableViewController.m
//  tableViewDemo
//
//  Created by kk on 14-3-21.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKTableViewController.h"
#import "KKTableViewCell.h"

    static NSString *messageCellIndetifer = @"KKTableViewCell";

@interface KKTableViewController ()
@property (nonatomic,strong)NSArray* dataArray;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@end

@implementation KKTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.offscreenCells = [NSMutableDictionary dictionary];
    
    _dataArray = @[
                   @{@"name": @"测试者1",@"text":@"Whoops! This line is unnecessary when using prototype cells in storyboards. The storyboard automatically configures this for me. SwitchTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier forIndexPath:indexPath]; works just fine without calling registerClass:: explicitly."},
                   @{@"name": @"测试者2",@"text":@"Reveal是一个很强大的UI分析工具，与其他几个功能相近的工具（比如PonyDebugger）相比，其最大的特点就是非常直观，用来查看app的UI布局非常方便。其常规用法是将framework集成至Xcode工程中，可参见Reveal的官网Reveal App，但我们这次讲述的却是非常规用法。"},
                   @{@"name": @"测试者3",@"text":@"注意，此时是可以指定多个BundleID的，也就是说，你可以同时监控任意多的app；再扩大一步说，如果你愿意，不上传这个libReveal.plist，你可以监控所有app，只要你不觉得机器很慢。。。"},
                   @{@"name": @"测试者412",@"text":@"4祝sdf贺你"},
                   @{@"name": @"测试者112",@"text":@"1祝f贺你"},
                   @{@"name": @"测试者212",@"text":@"2祝sdfd贺你"},
                   @{@"name": @"测试者321",@"text":@"写作这本书的时候，所有目标都是集中在进攻方向上，而没有太多考虑防守。因为从逆向工程的角度，确实是非常不好守的：微信、QQ那样的聊天工具，聊天记录可以截取；支付宝、网银那样的支付工具，用户信息和密码可以截取；至于其它更多app，放到逆向工程的面前感觉就是一个在裸奔的小孩，哦不，一群裸奔的小孩。"},
                   @{@"name": @"测试者412",@"text":@"4祝贺rte你"},
                   @{@"name": @"测试者121",@"text":@"1祝贺ret你"},
                   @{@"name": @"测试者223s",@"text":@"这种“高级技巧”从来没有被Reveal官方提起过，而是我们接触到Reveal之后逐步发现的。一开始的方法比较粗暴，是直接hook想看的app，把libReveal.dylib插进去；后来经过@卢明华 的进一步探索，才总结出这个更简单粗暴的方法"},
                   @{@"name": @"测试者3f",@"text":@"3祝贺er你"},
                   @{@"name": @"测试者4sa",@"text":@"现在绝大部分的app都已经是联网程序了，经典模式就是http+json，客户端一解析，再做的漂亮一点就齐活。然而只要架上Charles或是tcpdump，完整的url request+response就看的清清楚楚。有了这些url，你的网络数据就无密可保，尤其是一些资源型的服务，直接通过getList的模式就能把所有的数据抓回来。这种情况下，即使是https也没用，Charles轻松就能搞定，可以看相关的文章。而且即使不用Charles或tcpdump，直接用代码hook网络接口，一样能把数据拿到"},
                   @{@"name": @"测试者1fa",@"text":@"1祝贺dsf你"},
                   @{@"name": @"测试者2fdf",@"text":@"欢迎转发，普及知识；版权所有，盗版必骂"},
                   @{@"name": @"测试者3dfs",@"text":@"虽然Reveal是最直观的一个工具，但是在iOS逆向这个领域，它占的比重连1/10都不到，真正的大块头都有点难啃，相信各位都是理解的"},
                   @{@"name": @"测试者4sdf",@"text":@"4祝erwfg贺你"},
                   ];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.tableView registerClass:[KKTableViewCell class] forCellReuseIdentifier:messageCellIndetifer];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    KKTableViewCell *cell = (KKTableViewCell *)[tableView dequeueReusableCellWithIdentifier:messageCellIndetifer forIndexPath:indexPath];
    KKTableViewCell *cell = (KKTableViewCell *)[tableView dequeueReusableCellWithIdentifier:messageCellIndetifer ];
    NSLog(@"cellForRowAt %d, %p",indexPath.row,cell);
    
    // Configure the cell...
    NSDictionary* userInfo=[_dataArray objectAtIndex:indexPath.row];
    
//    cell.textLabel.text=[userInfo objectForKey:@"text"];
    cell.timeLineLabel.text=[userInfo objectForKey:@"text"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 50;
    NSString* reuseIdentifier = messageCellIndetifer ;
    KKTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSLog(@"heightForRowAt %d, %p",indexPath.row,cell);
    NSDictionary* info=[_dataArray objectAtIndex:indexPath.row];
    cell.timeLineLabel.text=[info objectForKey:@"text"];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
