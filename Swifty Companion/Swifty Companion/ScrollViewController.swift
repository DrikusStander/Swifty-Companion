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
  
    var data : [(String, String, Int)] = []
    var responseText : String = ""

    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var barChart: HorizontalBarChartView!
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrolContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var levelBar: UIProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    var tempCount : Int = -1
    
    var dataentry : [BarChartDataEntry] = []
    var descriptions : [String] = []
    

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
//        print("=======>", responseText, "<=======")
        if self.responseText == "{}"{
            performSegue(withIdentifier: "unwindToMain", sender: self)
        }
        else
        {
            self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "wtc-bg")!)
            
            mytableView.delegate = self
            mytableView.dataSource = self
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
                let levelInt = Int(truncating: baseResponse.cursus_users![0].level!)
                let level = Float(truncating: baseResponse.cursus_users![0].level!)
                let progress = level - Float(levelInt)
                progressLbl.text = "Level " + String(level) + " %"
                levelBar.progress = progress
                
                
                self.updateData(projects: baseResponse.projects_users!)
                self.barChartUpdate()
                
                URLSession.shared.dataTask(with: URL(string: imageurl!)!, completionHandler: {
                    (data, response, error) in
                    if error != nil{
                        print(error!)
                    }
                    DispatchQueue.main.async {
                        self.profileImg.image = UIImage(data: data!)
                    }
                }).resume()
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        
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
            self.dataentry.append(BarChartDataEntry(x: Double(i), y: Double(truncating: skill.level!)))
            self.descriptions.append(skill.name!)
            i += 1
        }
    }
    
    func updateData(projects: [ProjectsUsers]){
        for project in projects{
            let projectName = (project.project?.slug)!
            let status = project.status!
            let grade : Int = Int(truncating: project.final_mark ?? 0)
            self.data.append((projectName, status, grade ))
        }
        self.mytableView.reloadData()
    }
}
