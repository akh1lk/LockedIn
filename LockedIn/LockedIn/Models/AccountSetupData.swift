//
//  AccountSetupData.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

// TODO: Make StatsView create and update an AccountSetupData object to store the data. 

/// The basic data of a user when they are setting up their account
struct AccountSetupData {
    var careerGoals: [IconTextView]?
    var interests: [IconTextView]?
    var internship: Internship?
    var project: Project?
}

/// The company, position and date of an internship.
struct Internship {
    var company: String
    var position: String
    var date: String
}

/// The name, role and description of a project.
struct Project {
    var name: String
    var role: String
    var description: String
}
