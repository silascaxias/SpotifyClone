//
//  String.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 17/08/21.
//

import UIKit

extension String {
    static func formattedDate(string: String) -> String{
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
