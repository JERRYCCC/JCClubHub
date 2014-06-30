//
//  JCEventDetailViewController.m
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventDetailViewController.h"
#import "JCEventDetailTableViewCell.h"

@interface JCEventDetailViewController ()

@end

@implementation JCEventDetailViewController

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
    
    
    
    _eventTitleModal = @[@"Name", @"Date", @"Time", @"Location", @"Description",];
    _eventDetailModal = @[_name, _date, _time, _location, _description];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_eventTitleModal count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"EventDetailCell";
    
    JCEventDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[JCEventDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = [_eventDetailModal objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = [_eventDetailModal objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [_eventTitleModal objectAtIndex:indexPath.row];
    
    cell.detailLabel.text = [_eventDetailModal objectAtIndex:indexPath.row];
    
    
    return cell;
}



@end
