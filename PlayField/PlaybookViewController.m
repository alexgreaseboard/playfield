//
//  PlaybookDetailsViewController.m
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookViewController.h"
#import "AppDelegate.h"
#import "PlaybookCell.h"
#import "PlaybookDetailViewController.h"
#import "Playbook.h"

@interface PlaybookViewController () <UITextFieldDelegate>
@end

@implementation PlaybookViewController

Playbook *selectedPlaybook;

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

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    // data
    self.playBookDS = [[PlaybookDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.playsDS = [[PlaysDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    // set the datasources/delegates
    self.playbooksCollection.dataSource = self.playBookDS;
    self.playbooksCollection.delegate = self.playBookDS;
    
    
    // gestures - pinch
    self.pinchOutGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handlePinchOutGesture:)];
    self.pinchOutGestureRecognizer.delegate = self;
    [self.playbooksCollection addGestureRecognizer:self.pinchOutGestureRecognizer];
    
    [self.playbooksCollection registerClass:[PlaybookCell class] forCellWithReuseIdentifier:@"PlaybookCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPlaybook:(id)sender {
    Playbook *newPlaybook = [NSEntityDescription insertNewObjectForEntityForName:@"Playbook" inManagedObjectContext:self.managedObjectContext];
    newPlaybook.name = @"New Playbook";

    self.playBookDS.fetchedResultsController = nil;
    [self.playbooksCollection reloadData];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPlaybook = [self.playBookDS.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"playbookDetailSegue" sender:selectedPlaybook];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playbookDetailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PlaybookDetailViewController *detailController = (PlaybookDetailViewController *) navigationController.topViewController;
        detailController.playbook = selectedPlaybook;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.playBookDS collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [self.playBookDS collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}

@end
