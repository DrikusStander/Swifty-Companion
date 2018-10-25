//
//  JsonModels.swift
//  Swifty Companion
//
//  Created by Hendrik STANDER on 2018/10/22.
//  Copyright © 2018 Hendrik STANDER. All rights reserved.
//

import UIKit
import JSONParserSwift

class BaseResponse: ParsableModel{
    var id: NSNumber?
    var email: String?
    var login: String?
    var first_name: String?
    var last_name: String?
    var url: String?
    var phone: String?
    var displayname: String?
    var image_url: String?
    var staff: Bool = false
    var correction_point: NSNumber?
    var pool_month: String?
    var pool_year: String?
    var location: String?
    var wallet: NSNumber?
    var groups: [GroupResponse]?
    var cursus_users: [CursesUsesrs]?
    var projects_users: [ProjectsUsers]?
    var languages_users: [LanguageUsers]?
    var achievements: [Acievenments]?
    var titles: [Titles]?
    var titles_users: [TitlesUsers]?
    var partnerships: [Partnerships]?
    var patroned: [Patroned]?
    var patroning: [Patroning]?
    var expertises_users: [ExpertisesUsers]?
    var campus: [Campus]?
    var campus_users: [CampusUser]?
}

class GroupResponse: ParsableModel {
    
}

class CursesUsesrs: ParsableModel {
    var grade: String?
    var level: NSNumber?
    var skills: [Skills]?
    var id: NSNumber?
    var begin_at: String?
    var end_at: String?
    var cursus_id: NSNumber?
    var has_coalition: Bool = false
    var user: User?
    var cursus: Curses?
}

class Skills: ParsableModel {
    var id: NSNumber?
    var name: String?
    var level: NSNumber?
}

class User: ParsableModel {
    var id: NSNumber?
    var login: String?
    var url: String?
}

class Curses: ParsableModel {
    var id: NSNumber?
    var created_at: String?
    var name: String?
    var slug: String?
}

class ProjectsUsers: ParsableModel {
    var id: NSNumber?
    var occurrence: NSNumber?
    var final_mark: NSNumber?
    var status: String?
    var validated: Bool = false
    var current_team_id: NSNumber?
    var project: Project?
    var cursus_ids: [NSNumber]?
    var marked_at: String?
    var marked: Bool = false
}

class Project: ParsableModel {
    var id: NSNumber?
    var name: String?
    var slug: String?
    var parent_id: NSNumber?
}

class LanguageUsers: ParsableModel {
    var id: NSNumber?
    var language_id: NSNumber?
    var user_id: NSNumber?
    var position: NSNumber?
    var created_at: String?
    
}

class Acievenments: ParsableModel {
    
}

class Titles: ParsableModel {
    
}

class TitlesUsers: ParsableModel {
    
}

class Partnerships: ParsableModel {
    
}

class Patroned: ParsableModel {
    
}

class Patroning: ParsableModel {
    
}

class ExpertisesUsers: ParsableModel {
    
}

class Campus: ParsableModel {
    var id: NSNumber?
    var name: String?
    var time_zone: String?
    var language: Language?
    var users_count: NSNumber?
    var vogsphere_id: NSNumber?
    var country: String?
    var address: String?
    var zip: String?
    var city: String?
    var website: String?
    var facebook: String?
    var twitter: String?
    
}

class CampusUser: ParsableModel {
    var id: NSNumber?
    var user_id: NSNumber?
    var campus_id: NSNumber?
    var is_primary: Bool = false
}

class Language: ParsableModel {
    var id: NSNumber?
    var name: String?
    var identifier: String?
    var created_at: String?
    var updated_at: String?
}
