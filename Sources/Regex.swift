//
//  Regex.swift
//  SwiftLinkPreview
//
//  Created by Leonardo Cardoso on 09/06/2016.
//  Copyright © 2016 leocardz.com. All rights reserved.
//
import Foundation

// MARK: - Regular expressions
class Regex {
    
    static let imagePattern = "(.+?)\\.(gif|jpg|jpeg|png|bmp)$"
    static let imageTagPattern = "<img(.+?)src=\"([^\"]+)\"(.+?)[/]?>"
    static let titlePattern = "<title(.*?)>(.*?)</title>"
    static let metatagPattern = "<meta(.*?)>"
    static let metatagContentPattern = "content=(\"(.*?)\")|('(.*?)')"
    static let cannonicalUrlPattern = "([^\\+&#@%\\?=~_\\|!:,;]+)"
//    static let rawUrlPattern = "((http[s]?|ftp|file)://)?((([-a-zA-Z0-9]+\\.)|\\.)+[-a-zA-Z0-9]+)[-a-zA-Z0-9+&@#/%?=~_|!:,\\.;]*"

    static let rawUrlPattern =
        "^" +
            // protocol identifier
            "(?:(?:https?|ftp)://)?" +
            // user:pass authentication
            "(?:\\S+(?::\\S*)?@)?" +
            "(?:" +
            // IP address exclusion
            // private & local networks
            "(?!(?:10|127)(?:\\.\\d{1,3}){3})" +
            "(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})" +
            "(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})" +
            // IP address dotted notation octets
            // excludes loopback network 0.0.0.0
            // excludes reserved space >= 224.0.0.0
            // excludes network & broacast addresses
            // (first & last IP address of each class)
            "(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])" +
            "(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}" +
            "(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))" +
            "|" +
            // host name
            "(?:(?:[a-z\u{00a1}-\u{ffff}0-9]-*)*[a-z\u{00a1}-\u{ffff}0-9]+)" +
            // domain name
            "(?:\\.(?:[a-z\u{00a1}-\u{ffff}0-9]-*)*[a-z\u{00a1}-\u{ffff}0-9]+)*" +
            // TLD identifier
            "(?:\\.(?:[a-z\u{00a1}-\u{ffff}]{2,}))" +
            // TLD may end with dot
            "\\.?" +
            ")" +
            // port number
            "(?::\\d{2,5})?" +
            // resource path
            "(?:[/?#]\\S*)?" +
    "$"
    
    
    
    static let rawTagPattern = "<[^>]+>"
    static let inlineStylePattern = "<style(.*?)>(.*?)</style>"
    static let inlineScriptPattern = "<script(.*?)>(.*?)</script>"
    static let linkPattern = "<link(.*?)>"
    static let scriptPattern = "<script(.*?)>"
    static let commentPattern = "<!--(.*?)-->"
    
    // Test regular expression
    static func test(_ string: String!, regex: String!) -> Bool {
        
        return Regex.pregMatchFirst(string, regex: regex) != nil
        
    }
    
    // Match first occurrency
    static func pregMatchFirst(_ string: String!, regex: String!, index: Int = 0) -> String? {
        
        do{
            
            let rx = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            
            if let match = rx.firstMatch(in: string, options: [], range: NSMakeRange(0, string.characters.count)) {
                
                var result: [String] = Regex.stringMatches([match], text: string, index: index)
                return result.count == 0 ? nil : result[0]
                
            } else {
                
                return nil
                
            }
            
        } catch {
            
            return nil
            
        }
        
    }
    
    // Match all occurrencies
    static func pregMatchAll(_ string: String!, regex: String!, index: Int = 0) -> [String] {
        
        do{
            
            let rx = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            
            let matches: [NSTextCheckingResult] = rx.matches(in: string, options: [], range: NSMakeRange(0, string.characters.count))
            
            return !matches.isEmpty ? Regex.stringMatches(matches, text: string, index: index) : []
            
        } catch {
            
            return []
            
        }
        
    }
    
    // Extract matches from string
    static func stringMatches(_ results: [NSTextCheckingResult], text: String, index: Int = 0) -> [String] {
        
        return results.map {
            let range = $0.rangeAt(index)
            if text.characters.count > range.location + range.length {
                return (text as NSString).substring(with: range)
            }
            else {
                return ""
            }
        }
        
    }
    
    // Return tag pattern
    static func tagPattern(_ tag: String) -> String {
        
        return "<" + tag + "(.*?)>(.*?)</" + tag + ">"
        
    }
    
}
