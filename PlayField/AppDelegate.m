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
    // Testflight
    // !!!: Use the next line only during beta
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    
    [TestFlight takeOff:@"e9a15330-1dd5-411e-b20d-b01f4cf7bcdd"];
    
    if(self.managedObjectContext){
        
    }
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloud access at %@", ubiq]];
        // TODO: Load document...
    } else {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"No iCloud access"]];
    }
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
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: coordinator];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeChangesFrom_iCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
        }];
        _managedObjectContext = moc;
    }
    
    return _managedObjectContext;
}

- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
    
	NSLog(@"Merging in changes from iCloud...");
    
    NSManagedObjectContext* moc = [self managedObjectContext];
    
    [moc performBlock:^{
        
        [moc mergeChangesFromContextDidSaveNotification:notification];
        
        NSNotification* refreshNotification = [NSNotification notificationWithName:@"Syncing with ICloud"
                                                                            object:self
                                                                          userInfo:[notification userInfo]];
        
        [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
    }];
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
    if((_persistentStoreCoordinator != nil)) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    NSPersistentStoreCoordinator *psc = _persistentStoreCoordinator;
    
    // Set up iCloud in another thread:
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *iCloudEnabledAppID = @"YCMRB44F3D.com.worldappenterprises.greaseboard";
        
        // ** Note: if you adapt this code for your own use, you should change this variable:
        NSString *dataFileName = @"GreaseBoard.sqlite";
        
        // ** Note: For basic usage you shouldn't need to change anything else
        
        NSString *iCloudDataDirectoryName = @"Data.nosync";
        NSString *iCloudLogsDirectoryName = @"Logs";
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *localStore = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataFileName];
        NSURL *iCloud = [fileManager URLForUbiquityContainerIdentifier:nil];
        
        if (iCloud) {
            
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloud is working"]];
            
            NSURL *iCloudLogsPath = [NSURL fileURLWithPath:[[iCloud path] stringByAppendingPathComponent:iCloudLogsDirectoryName]];
            
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloudEnabledAppID = %@",iCloudEnabledAppID]];
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"dataFileName = %@", dataFileName]];
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloudDataDirectoryName = %@", iCloudDataDirectoryName]];
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloudLogsDirectoryName = %@", iCloudLogsDirectoryName]];
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloud = %@", iCloud]];
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloudLogsPath = %@", iCloudLogsPath]];
            
            if([fileManager fileExistsAtPath:[[iCloud path] stringByAppendingPathComponent:iCloudDataDirectoryName]] == NO) {
                NSError *fileSystemError;
                [fileManager createDirectoryAtPath:[[iCloud path] stringByAppendingPathComponent:iCloudDataDirectoryName]
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:&fileSystemError];
                if(fileSystemError != nil) {
                    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"Error creating database directory %@", fileSystemError]];
                }
            }
            
            NSString *iCloudData = [[[iCloud path]
                                     stringByAppendingPathComponent:iCloudDataDirectoryName]
                                    stringByAppendingPathComponent:dataFileName];
            
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloudData = %@", iCloudData]];
            
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            [options setObject:iCloudEnabledAppID            forKey:NSPersistentStoreUbiquitousContentNameKey];
            [options setObject:iCloudLogsPath                forKey:NSPersistentStoreUbiquitousContentURLKey];
            
            [psc lock];
            
            [psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:[NSURL fileURLWithPath:iCloudData]
                                    options:options
                                      error:nil];
            
            [psc unlock];
        }
        else {
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"iCloud is NOT working - using a local store"]];
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            
            [psc lock];
            
            [psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:localStore
                                    options:options
                                      error:nil];
            [psc unlock];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:self userInfo:nil];
        });
    });
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
