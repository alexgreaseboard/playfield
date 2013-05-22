//
//  AppDelegate.m
//  GreaseBoard
//
//  Created by Jai Lebo on 1/28/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "RosterMasterViewController.h"
#import "PlayCell.h"
#import "PlayDrillItemCell.h"
#import "PlayerCell.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)customizeAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:39/255.0 green:21/255.0 blue:57/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
                                                           UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                           nil]];
    
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRed:24/255.0 green:48/255.0 blue:33/255.0 alpha:1.0]];
    [[UITableView appearance] setSeparatorColor:[UIColor colorWithRed:34/255.0 green:54/255.0 blue:41/255.0 alpha:1.0]];
    [[UITableView appearance] setSeparatorColor:[UIColor grayColor]];
    
    //[[UILabel appearance] setColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[PlayCell class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[PlayDrillItemCell class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[PlayerCell class], nil] setTextColor:[UIColor whiteColor]];
    
    [[UITableViewCell appearance] setBackgroundColor:[UIColor colorWithRed:24/255.0 green:48/255.0 blue:33/255.0 alpha:1.0]];
    //[[UITableViewCell appearance] setColor:[UIColor colorWithRed:24/255.0 green:48/255.0 blue:33/255.0 alpha:1.0]];
    
    //[[UITextField appearance] setColor:[UIColor whiteColor]];
    //[[UITextField appearance] setBackgroundColor:[UIColor colorWithRed:24/255.0 green:48/255.0 blue:33/255.0 alpha:1.0]];
    
    //[[UIView appearance] setBackgroundColor:[UIColor colorWithRed:24/255.0 green:48/255.0 blue:33/255.0 alpha:1.0]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    // For Roster
    //UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    //UINavigationController *masterNavigationController = [splitViewController.viewControllers objectAtIndex:0];
    //RosterMasterViewController *masterController = (RosterMasterViewController *)masterNavigationController.viewControllers[0];
    //masterController.managedObjectContext = self.managedObjectContext;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

#pragma mark - Menu Methods

- (void) switchToMenu
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UIViewController *controller = (UIViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MenuStoryboard"];
    self.window.rootViewController = controller;
}

- (void) switchToRoster
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UIViewController *controller = (UIViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"RosterStoryboard"];
    self.window.rootViewController = controller;
}

- (void) switchToPlaysDrills
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UIViewController *controller = (UIViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PlayDrillStoryboard"];
    self.window.rootViewController = controller;
}

- (void) switchToPlaybook
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UIViewController *controller = (UIViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PlayBookStoryboard"];
    self.window.rootViewController = controller;
}

- (void) switchToPractices
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UIViewController *controller = (UIViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PracticesStoryboard"];
    self.window.rootViewController = controller;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GreaseBoard" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GreaseBoard.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
