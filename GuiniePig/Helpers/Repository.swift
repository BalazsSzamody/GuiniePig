//
//  Repository.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 18/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import Foundation
import Combine

class Repository {
    var items = CurrentValueSubject<[TestItem], Error>([
        TestItem(),
        TestItem(title: "Snatch", text: """
                Do you know what "nemesis" means? A righteous infliction of retribution manifested by an appropriate agent. Personified in this case by an 'orrible cunt... me.
                """,
                 author: "Brick Top", color: .orange),
        TestItem(title: "Snatch", text: "Have you ever crossed the road, and looked the wrong way? A car's nearly on you? So what do you do? Something very silly. You freeze. Your life doesn't flash before you, 'cause you're too fuckin' scared to think - you just freeze and pull a stupid face. But the pikey didn't. Why? Because he had plans of running the car over.", author: "Turkish", color: .red),
    ])
}
