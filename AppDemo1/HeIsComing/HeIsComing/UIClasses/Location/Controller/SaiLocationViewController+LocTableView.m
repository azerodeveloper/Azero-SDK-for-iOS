//
//  SaiLocationViewController+LocTableView.m
//  HeIsComing
//
//  Created by mike on 2020/9/17.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiLocationViewController+LocTableView.h"
#if !TARGET_OS_IOS
#import <AppKit/AppKit.h>
#endif


@implementation SaiLocationViewController (LocTableView)
#pragma mark - UITableViewDataSource Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSCRATIO(68);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    SaiLoctationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SaiLoctationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSDictionary *dic = self.locArray[indexPath.row];
    NSString *wifiName = dic[@"name"];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];

    cell.namelLabel.text = wifiName;
    cell.detailLabel.text=dic[@"address"];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterSpellOutStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *spellOutStr = [formatter stringFromNumber:[NSNumber numberWithDouble:(indexPath.row+1)]];
    NSString *text = [NSString stringWithFormat:@"第%@个",spellOutStr];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:text];
}
@end
