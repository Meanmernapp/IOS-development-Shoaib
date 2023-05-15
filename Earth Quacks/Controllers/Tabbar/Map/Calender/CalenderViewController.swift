//
//  CalenderViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import UIKit
import HorizonCalendar

var selectedDate = Date()

class CalenderViewController: CalenderBaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var weekCollection: UICollectionView!
    @IBOutlet weak var parentCalenderView: UIView!
    @IBOutlet weak var selectDataBtn: UIButton!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var monthString: UILabel!
    @IBOutlet weak var weekView: UIView!
    
    //MARK: - Variables
    
    var callback : ((String,String) -> Void)?
    var totalSquares = [Date]()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setCellsView()
        setWeekView()
    }
    
    //MARK: - IBAction
    
    @IBAction func selectAction(_ sender: Any) {
        if let selectedDayRange {
            callback?(selectedDayRange.lowerBound.description,selectedDayRange.upperBound.description)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func clearAction(_ sender: Any) {
        self.selectedDayRange = nil
        setupUI()
    }
    
    @IBAction func segementAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            self.daysView.isHidden = false
//            self.weekView.isHidden = true
            self.selectDataBtn.setTitle("Select Dates", for: .normal)
            selectDataBtn.alpha = 0.5
            selectDataBtn.isEnabled = false
        }
        else if sender.selectedSegmentIndex == 1 {
//            self.daysView.isHidden = true
//            self.weekView.isHidden = false
            self.selectDataBtn.setTitle("Select Dates", for: .normal)
//            self.selectDataBtn.setTitle("Select Week", for: .normal)
            selectDataBtn.alpha = 0.5
            selectDataBtn.isEnabled = false
        }
        else {
            self.selectDataBtn.setTitle("Select Dates", for: .normal)
//            self.selectDataBtn.setTitle("Select Months", for: .normal)
//            self.daysView.isHidden = true
//            self.weekView.isHidden = true
            selectDataBtn.alpha = 0.5
            selectDataBtn.isEnabled = false
        }
    }
    
    //MARK: - Week Calender
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
    }
    
    
    //MARK: -  UIFunction
    func setCellsView()
    {
        let width = weekCollection.frame.size.width / 4
        let height = 50.0
        
        let flowLayout = weekCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setWeekView()
    {
        totalSquares.removeAll()
        
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        
        while (current < nextSunday)
        {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        
        monthString.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        weekCollection.reloadData()
    }
    
    func setupUI() {
        segmentView.setDividerImage(nil, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentView.setDividerImage(nil, forLeftSegmentState: .selected, rightSegmentState: .selected, barMetrics: .default)
        segmentView.setTitleColor(.white,.black)
        selectDataBtn.alpha = 0.5
        selectDataBtn.isEnabled = false
        self.calendarView.frame = CGRect(x: 0, y: 0, width: parentCalenderView.bounds.width, height: parentCalenderView.bounds.height)
        self.calendarView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.parentCalenderView.addSubview(calendarView)
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }
            let calendar = Calendar.current
            let todayDate = Date()
            let selectedDate = calendar.date(from: DateComponents(year: day.month.year, month: day.month.month, day: day.day))!
            if selectedDate > todayDate {
                AppUtility.showInfoMessage(message: "You can't select date from future".localized)
                return
            }
            
            DayRangeSelectionHelper.updateDayRange(
                afterTapSelectionOf: day,
                existingDayRange: &self.selectedDayRange)
            
            self.calendarView.setContent(self.makeContent())
            if self.selectedDayRange?.upperBound == self.selectedDayRange?.lowerBound {
                self.selectDataBtn.alpha = 0.5
                self.selectDataBtn.isEnabled = false
            }
            else {
                self.selectDataBtn.alpha = 1
                self.selectDataBtn.isEnabled = true
            }
            print(self.selectedDayRange ?? "")
        }
    }
    
}

extension CalenderViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.register(WeeklyCollectionViewCell.self, indexPath: indexPath)
        let date = totalSquares[indexPath.item]
        cell.contentView.backgroundColor = .black
        cell.dayOfMonth.textColor = .white
        cell.contentView.cornerRadius = 10
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
        return cell
    }
    
    
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        self.register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: T.self))
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
}

extension UICollectionView {
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }
        
        return nil
    }
}
