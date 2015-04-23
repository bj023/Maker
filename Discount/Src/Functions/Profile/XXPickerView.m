//
//  XXPickerView.m
//  Discount
//
//  Created by fengfeng on 15/3/29.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "XXPickerView.h"


@interface XXPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation XXPickerView

- (IBAction)dismiss:(id)sender {
    
    [self removeFromSuperview];
}
- (IBAction)cancel:(id)sender {
    
    [self removeFromSuperview];
}
- (IBAction)finish:(id)sender {
    
    [self removeFromSuperview];
    
    if (self.complete) {
        
        NSMutableArray *selectedIndexs = [NSMutableArray arrayWithCapacity:4];
        
        for (int i = 0; i < [self numberOfComponents:self.dataSource]; i++) {
            [selectedIndexs addObject:@([self.pickerView selectedRowInComponent:i])];
        }
        
        self.complete(selectedIndexs);
    }
}

#pragma mark - UIPickerViewDelegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self numberOfComponents:self.dataSource];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self dataSourceInComponent:component].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    NSLog(@"title[%ld][%ld] = [%@]", (long)component, (long)row,  [self titleInComponet:[self dataSourceInComponent:component] row:row]);
    
    return [self titleInComponet:[self dataSourceInComponent:component] row:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"didSelectRow component = [%d] row = [%d]", component,row);
    
    for (NSInteger i = component + 1; i < [self numberOfComponents:self.dataSource]; i++) {
        [pickerView reloadComponent:i];
        [pickerView selectRow:0 inComponent:i animated:NO];
    }
}

#pragma mark - private

- (NSInteger)numberOfComponents:(NSArray *)dataSource
{
    if (dataSource.count) {
        if ([dataSource[0] isKindOfClass:[NSDictionary class]]) {
            return [self numberOfComponents:[dataSource[0] allValues]] + 1;
        }else{
            return 1;
        }
    }
    
    return 0;
}

- (NSArray *)dataSourceInComponent:(NSInteger)component
{
    NSArray *dataSource = self.dataSource;
    
    for (int i = 0; i < component; i++) {
        dataSource = [[dataSource objectAtIndex:[self.pickerView selectedRowInComponent:component - 1]] allValues][0];
    }
    return dataSource;
}

- (NSString *)titleInComponet:(NSArray *)Componet row:(NSInteger)row
{
    if (row >= Componet.count) {
        return @"";
    }
    
    id title = Componet[row];
    if ([title isKindOfClass:[NSDictionary class]]) {
        return [title allKeys][0];
    }
    
    return title;
}

@end
