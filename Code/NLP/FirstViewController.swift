//
//  FirstViewController.swift
//  NLP
//
//  Created by Klaus Rodewig on 06.05.18.
//  Copyright © 2018 Appnö UG. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(determineTextLanguage(inText: "NSLinguisticTagger provides text processing APIs."))
//        print(determineTextLanguage(inText: "Er trank Kölsch sehr gerne und schon vor Vier."))
//        print(determineTextLanguage(inText: "Je ne fume pas!"))
//        print(determineTextLanguage(inText: "La enseñanza y la formación empresarial no están reconocidas como asignatura independiente en la enseñanza secundaria"))
//        print(determineTextLanguage(inText: "🤩"))

//        let sampleOne = "Er trank Kölsch sehr gerne und schon vor Vier."
//        let sampleTwo = "Wir würden gerne in Kreisen laufen und Löcher an Wände nageln, während Franz mit einer Taxi-App in ein abgrundtiefes Funkloch fällt und den Minster anrufen möchte."
//        let sampleThree = "Herr von und zu Guttenberg findet seine Disketten nicht mehr."
//        let sampleFour = "Herr Otto Mohl fährt mit seinem Opel zu Horst von der Acme Ltd."
//        tokenizeText(inText: sampleOne)
//        lemmatization(inText: sampleOne)
//        lemmatization(inText: sampleTwo)
//        findNames(inText: sampleThree)
//        findNames(inText: sampleFour)

        let newsText = "Am 6. Mai jährt sich die Ankündigung des allerersten iMac durch Steve Jobs in Cupertino zum zwanzigsten Mal. Die Maschine führte Apple aus seiner schwersten Krise und machte Computer weniger grau."

//        findNames(inText: newsText)
        determineTextLanguageWithTagSchemes(inText: newsText)
        findNames(inText: newsText)
    }

    func determineTextLanguage(inText : String) -> String {
        let theTagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        theTagger.string = inText
        guard theTagger.dominantLanguage != nil else {
            return "No language determined"
        }
        return theTagger.dominantLanguage!
    }

    func determineTextLanguageWithTagSchemes(inText : String) {
        let theTagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        theTagger.string = inText
        guard theTagger.dominantLanguage != nil else {
            print("No language determined")
            return
        }

        let theTagSchemes = NSLinguisticTagger.availableTagSchemes(forLanguage: theTagger.dominantLanguage!)
        for item in theTagSchemes {
            print(item)
        }

    }

    func tokenizeText(inText : String) {
        let theTagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
        theTagger.string = inText

        let theRange = NSRange(location: 0, length: inText.utf16.count)
        let theOptions: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]

        theTagger.enumerateTags(in: theRange, unit: .word, scheme: .tokenType, options: theOptions) { tag, tokenRange, stop in

            let token = (inText as NSString).substring(with: tokenRange)
            print(token)
        }
    }

    func lemmatization(inText : String){
        let theTagger = NSLinguisticTagger(tagSchemes:[.lemma], options: 0)
        theTagger.string = inText

        let range = NSRange(location:0, length: inText.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]

        theTagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in

            if (tag?.rawValue) != nil {
                print(tag ?? "")
            }
        }
    }

    func findNames(inText : String) {
        let theTagger = NSLinguisticTagger(tagSchemes: [.nameType, .tokenType], options: 0)
        theTagger.string = inText

        let theRange = NSRange(location:0, length: inText.utf16.count)
        let theOptions: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let theTags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]

        theTagger.enumerateTags(in: theRange, unit: .word, scheme: .nameType, options: theOptions) { tag, tokenRange, stop in
            if let tag = tag, theTags.contains(tag) {
                let name = (inText as NSString).substring(with: tokenRange)
                print(tag)
                print(name)
            }
        }
        theTagger.enumerateTags(in: theRange, unit: .word, scheme: .tokenType, options: theOptions) { tag, tokenRange, stop in

            let token = (inText as NSString).substring(with: tokenRange)
//            print(token)
        }
    }
}

