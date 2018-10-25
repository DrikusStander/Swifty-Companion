//
//  ScrollViewController.swift
//  Swifty Companion
//
//  Created by Hendrik STANDER on 2018/10/22.
//  Copyright © 2018 Hendrik STANDER. All rights reserved.
//

import UIKit
import JSONParserSwift
import Charts

class ScrollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate{
  
    var data = Data.projects
    var responseText : String = ""

    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var barChart: HorizontalBarChartView!
    @IBOutlet weak var tableView: UITableView!
    var tempCount : Int = -1
    
    var dataentry : [BarChartDataEntry] = []
    var descriptions : [String] = []

    @IBAction func temp(_ sender: Any) {
        let queue1 = DispatchQueue(label: "squeue.hoffman.jon")
        let delayInSeconds1 = 2.0
        let pTime1 = DispatchTime.now() + Double(Int64(delayInSeconds1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue1.asyncAfter(deadline: pTime1) {
             self.loginLbl.text = String(self.tempCount)
        }
       
        let queue2 = DispatchQueue(label: "squeue.hoffman.jon")
        let delayInSeconds = 2.0
        let pTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue2.asyncAfter(deadline: pTime) {
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tempCount = data.count
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
        cell.project = data[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.reloadData()
        barChart.delegate = self
        barChartUpdate()
        
        barChart.chartDescription?.enabled = false
        barChart.drawGridBackgroundEnabled = false
        
        let xAxis = barChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.granularityEnabled = true
        xAxis.labelTextColor = .black
        xAxis.wordWrapEnabled = true
        xAxis.labelCount = 17
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        
        let leftAxis = barChart.leftAxis
        leftAxis.axisMaximum = 24
        
        let righttAxis = barChart.rightAxis
        righttAxis.axisMaximum = 24
    
        let l = barChart.legend
        l.enabled = false

        do {
            let baseResponse: BaseResponse = try JSONParserSwift.parse(string: responseText)
            // Use base response object here
            
            var imageurl = baseResponse.image_url
            var index = (imageurl?.lastIndex(of: "/"))!
            index = (imageurl?.index(after: index))!
            imageurl?.insert(contentsOf: "medium_", at: index)
            self.appendChartData(skills: baseResponse.cursus_users![0].skills!)
            self.loginLbl.text = baseResponse.login
            self.firstNameLbl.text = baseResponse.first_name
            self.lastNameLbl.text = baseResponse.last_name
            self.emailLbl.text = baseResponse.email
            
            self.barChartUpdate()
            
            URLSession.shared.dataTask(with: URL(string: imageurl!)!, completionHandler: {
                (data, response, error) in
                if error != nil{
                    print(error)
                }
                DispatchQueue.main.async {
                    self.profileImg.image = UIImage(data: data!)
                }
            }).resume()
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewController
        
        vc.responseText = ""
    }
    
    func barChartUpdate(){
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.descriptions)
        barChart.xAxis.granularity = 1.0
        let dataset = BarChartDataSet(values: self.dataentry, label: "Skills")
        dataset.setColor(UIColor(red: 0.2, green: 0.7, blue: 0.7, alpha: 0.9 ))
        let data = BarChartData(dataSets: [dataset])
        barChart.data = data
        barChart.notifyDataSetChanged()
    }
    
    func appendChartData(skills: [Skills])
    {
        var i = 0
        for skill in skills {
            self.dataentry.append(BarChartDataEntry(x: Double(i), y: Double(skill.level!)))
            self.descriptions.append(skill.name!)
            i += 1
        }
    }
    
}
