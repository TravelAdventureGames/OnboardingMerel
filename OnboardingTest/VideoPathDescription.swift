//
//  VideoPathDescription.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation

// If a scene or proces is added which is going to be used in the LauncManager, it has to be added here.

enum CurrentProces {
    case onboardingProces
    case tappingWithMerelProces
}

enum Scene: String {
    case none
    case onboarding1 = "Onboarding1HS1"
    case onboarding2 = "Onboarding2COM1"
    case onboarding3 = "Onboarding3HS1"
    case probleemIntroductie = "ProbleemintroductieHS1"
    case probleemInvullen
    case scoresysteemUitleg = "ScoreuitlegCOM1"
    case scoreInvullen
    case opstartzin = "OpstartzinCOM1"
    case eersteTapsessie = "EerstetapsessieCOM1"
    case tweedeKeerScoreInvullen
    case opeensHogereScore = "opeensHogereScore"
    case tweedeTapsessie = "TweedetapsessieCOM1"
    case derdeTapsessie = "LaatsterestjetapsessieCOM1"
    case positiefEindFilmpje = "PositieveeindfilmHS1"
    case alsHetNietWerkt = "AlshetnietwerktHS1"
    
    
    var videoDescription: String {
        switch self {
        case .none:
            return ""
        case .onboarding1:
            return "Welkom bij de Tapp-app!"
        case .onboarding2:
            return "Wat is smarttapping?"
        case .onboarding3:
            return "Waarom helpt het?"
        case .probleemIntroductie:
            return "Welk probleem wil je onder de loep nemen?"
        case .probleemInvullen:
            return "Vul nu jouw probleem in"
        case .scoreInvullen:
            return "Vul nu je score in. Hoe erg voelt het probleem?"
        case .scoresysteemUitleg:
            return "Hoe erg ervaar je het probleem?"
        case .opstartzin:
            return "De opstartzin"
        case .eersteTapsessie:
            return "Aaan de slag, we gaan de eerste tapsessie doen!"
        case .tweedeKeerScoreInvullen:
            return "Vul nu opnieuw je score in. Voel je je al beter?"
        case .opeensHogereScore:
            return "Help, het wordt alleen maar erger!"
        case .tweedeTapsessie:
            return "Je tweede tapsessie!"
        case .derdeTapsessie:
            return "En we werken het laatste restje weg!"
        case .positiefEindFilmpje:
            return "Gefeliciteerd, je hebt je eerste tapping workout volbracht!"
        case .alsHetNietWerkt:
            return "Soms werkt het niet. Waar kan dat aan liggen?"
        }
    }
    // Some vid's have texts at specific times. This enum gives that times
    var videoTextBeginTimes: [Double] {
        switch self {
        case .none:
            return []
        case .onboarding1:
            return []
        case .onboarding2:
            return []
        case .onboarding3:
            return []
        case .probleemIntroductie:
            return []
        case .probleemInvullen:
            return []
        case .scoreInvullen:
            return []
        case .scoresysteemUitleg:
            return []
        case .opstartzin:
            return VideoTextBeginTimes.opstartZin
        case .eersteTapsessie:
            return VideoTextBeginTimes.eersteTapSessie
        case .tweedeKeerScoreInvullen:
            return []
        case .opeensHogereScore:
            return []
        case .tweedeTapsessie:
            return VideoTextBeginTimes.tweedeTapSessie
        case .derdeTapsessie:
            return VideoTextBeginTimes.laatsteRestje
        case .positiefEindFilmpje:
            return []
        case .alsHetNietWerkt:
            return []
        }
    }
    var videoTextEndTimes: [Double] {
        switch self {
        case .none:
            return []
        case .onboarding1:
            return []
        case .onboarding2:
            return []
        case .onboarding3:
            return []
        case .probleemIntroductie:
            return []
        case .probleemInvullen:
            return []
        case .scoreInvullen:
            return []
        case .scoresysteemUitleg:
            return []
        case .opstartzin:
            return VideoTextEndTimes.opstartZin
        case .eersteTapsessie:
            return VideoTextEndTimes.eersteTapSessie
        case .tweedeKeerScoreInvullen:
            return []
        case .opeensHogereScore:
            return []
        case .tweedeTapsessie:
            return VideoTextEndTimes.tweedeTapSessie
        case .derdeTapsessie:
            return VideoTextEndTimes.laatsteRestje
        case .positiefEindFilmpje:
            return []
        case .alsHetNietWerkt:
            return []
        }
    }
}

