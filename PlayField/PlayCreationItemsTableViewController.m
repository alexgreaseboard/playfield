//
//  PlayCreationItemViewController.m
//  GreaseBoard
//
//  Created by Jai Lebo on 2/9/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import "PlayCreationItemsTableViewController.h"
#import "PlayDrillItem.h"
#import "PlayDrillItemCell.h"
#import "AppDelegate.h"

@interface PlayCreationItemsTableViewController ()

@end

@implementation PlayCreationItemsTableViewController {
    NSMutableArray *_items;
}

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
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:) ];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    _items = [[NSMutableArray alloc] init];
    [_items addObject:[PlayDrillItem itemWithText:@"Offense" andWithImage:@"Smile.png"]];
    [_items addObject:[PlayDrillItem itemWithText:@"Defense" andWithImage:@"Sad.png"]];
    [_items addObject:[PlayDrillItem itemWithText:@"Cone" andWithImage:@"cone.jpeg"]];
    
    self.detailViewController = (CocosViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    PlayDrillItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    // find the to-do item for this index
    int index = [indexPath row];
    PlayDrillItem *item = _items[index];
    // set the text
    cell.itemName.text = item.text;
    [cell.image setImage:item.image];
    
    return cell;
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = _items.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

- (IBAction)addSprite:(UIButton *)sender {
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];

    int index = [hitIndex row];
    PlayDrillItem *item = _items[index];
    
    NSString *itemLabel = item.text;
    NSString *imageName;
    if([itemLabel isEqualToString:@"Offense"]) {
        imageName = @"Smile.png";
    } else if([itemLabel isEqualToString:@"Defense"]) {
        imageName = @"Sad.png";
    } else if([itemLabel isEqualToString:@"Cone"]) {
        imageName = @"cone.jpeg";
    }
    
    [self.detailViewController addItemSprite:imageName];
}

- (IBAction)returnToMenu:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToMenu];
}

@end
