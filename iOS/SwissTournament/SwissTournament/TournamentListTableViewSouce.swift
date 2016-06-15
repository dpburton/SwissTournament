//
//  TournamentListTableViewSouce.swift
//  SwissTournament
//
//  Created by Daniel Burton on 6/15/16.
//  Copyright © 2016 Daniel Burton. All rights reserved.
//

import UIKit

class TournamentListTableViewSouce: NSObject, UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "tournamentCell")!
    }

}
