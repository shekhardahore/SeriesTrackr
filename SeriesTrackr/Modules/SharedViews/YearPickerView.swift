//
//  YearPickerView.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 14/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class YearPickerView: UIPickerView {
    
    var years: [Int]!
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.firstIndex(of: year)!, inComponent: 0, animated: true)
        }
    }
    
    var onYearSelect: ((_ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupPickerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupPickerView()
    }
    
    func setupPickerView() {
        var years: [Int] = []
        if years.count == 0 {
            var dateComponent = DateComponents()
   
            dateComponent.year = -51
            
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())
            var year = Calendar(identifier: .gregorian).component(.year, from: futureDate!)
            
            for _ in 1...100 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        self.delegate = self
        self.dataSource = self
        
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        selectRow(years.firstIndex(of: currentYear)!, inComponent: 0, animated: false)
    }
}

extension YearPickerView: UIPickerViewDataSource {
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        default:
            return 0
        }
    }
}

extension YearPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = years[self.selectedRow(inComponent: 0)]
        if let block = onYearSelect {
            block( year)
        }
        self.year = year
    }
}
