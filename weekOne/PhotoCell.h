//
//  PhotoCell.h
//  weekOne
//
//  Created by WeiSheng Su on 1/26/15.
//  Copyright (c) 2015 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *photoCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *photoCellDescription;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
