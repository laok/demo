//
//  KKCoreDataTestController.m
//  UseCoreData
//
//  Created by zhaokai on 14-7-9.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKCoreDataTestController.h"
#import "KKModelManager.h"
#import "NSManagedObject+KKModelManager.h"
#import "Entity.h"

@interface KKCoreDataTestController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView* inputView;
@property(nonatomic,strong)UITextField* inputTitleField;
@property(nonatomic,strong)UIButton* addButton;

@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation KKCoreDataTestController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithCapacity:20];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTodoAction)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backAction)];
    
    //table view
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.tableView];
    
    //input view
    self.inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 200)];
    self.inputView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.inputView];
    self.inputView.hidden = YES;
}

#pragma mark - action
-(void)backAction
{
    if (self.navigationController && [self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)addTodoAction
{
    
//    [UIView animateWithDuration:0.13 animations:^{
//        self.inputView.hidden = !self.inputView.hidden;
//    }];
    [self getAllTodos];
}

-(void)getAllTodos
{
    [Entity async:^id(NSManagedObjectContext *ctx, NSString *className) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"task_id" ascending:YES]]];
        NSError *error;
        NSArray *dataArray = [ctx executeFetchRequest:request error:&error];
        if (error) {
            return error;
        }else{
            return dataArray;
        }
        
    } result:^(NSArray *result, NSError *error) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:result];
        
        [_tableView reloadData];
    }];
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,%d",((Entity*)_dataArray[indexPath.row]).title,[((Entity*)_dataArray[indexPath.row]).task_id integerValue]];
    return cell;
}
@end
