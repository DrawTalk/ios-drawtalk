//
//  Localization.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/14/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

func DWTLocalizedStringWithDefaultValue(key: String, #tableName: String, #bundle: NSBundle, #value: String, #comment: String) -> String {
  return NSLocalizedString(key,
    tableName: tableName,
    bundle: bundle,
    value: value,
    comment: comment)
}