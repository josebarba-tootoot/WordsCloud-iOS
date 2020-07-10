//
//  WordsCloud.swift
//  WordsCloudGenerator
//
//  Created by Jose Barba on 09/07/2020.
//  Copyright © 2020 Jose Barba. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WordsCloudDelegate {
    
    /// To catch what tag the user did tap
    /// - Parameters:
    ///   - word: the word assigned to the tag/button
    ///   - index: the index in the array of the  passed words
    func didTap(onWord word: String, index: Int)
}

class WordsCloud: UIView {
    
    
    // MARK: - Ivars
    private var wordsArray: [String] = ["Freedom", "God", "Happiness", "Imagination", "Intelligence", "Other", "Freedom", "God", "Happiness", "Imagination", "Intelligence", "Other", "Freedom", "God", "Happiness", "Imagination", "Intelligence", "Other", "Freedom", "God", "Happiness", "Imagination", "Intelligence", "Other"]
//    private var colorsArray: [UIColor]!
    private var colorsArray: [UIColor]! = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)]
    private var offset: CGFloat = 2

    public var sizes: [CGFloat]!
    public var delegate: WordsCloudDelegate!
    
    private var minimumFontSize: CGFloat = 10
    private var maximumFontSize: CGFloat = 35
    
    // MARK: - Public functions
    public func create(words: [String]?, frame: CGRect) {
        self.clipsToBounds = true
        if let words = words {
            wordsArray = words
        }
        generateButtons()
    }
    
    // MARK: - Actions
    @objc func didTapButton(_ sender: UIButton) {
        guard let word = sender.titleLabel?.text else { return }
        delegate?.didTap(onWord: word, index: sender.tag)
    }
    
    // MARK: - Private functions
    
    /// Will start the cloud generation
    fileprivate func generateButtons() {
        var arrayOfButtons: [UIButton] = []
        for (index, word) in wordsArray.enumerated() {
            // Default size and color
            var size: CGFloat = 17
            var color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            if let sizes = sizes {
                size = sizes[index]
            }
            else {
                size = CGFloat.random(in: minimumFontSize..<maximumFontSize)
            }
            
            if let colors = colorsArray {
                color = colors[Int.random(in: 0..<colors.count)]
            }
            
            let button = generateButton(fontSize: size, title: word, tag: index, color: color)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            arrayOfButtons.append(button)
        }
        generateCloud(arrayOfButtons)
    }
    
    
    /// To create the button will be used as a tag
    /// - Parameters:
    ///   - fontSize: the font size for the titleLabel
    ///   - title: the string for the title
    ///   - tag: the tag based on the index of the array of Strings passed to this class
    ///   - color: The color if want to use a different one than the black
    /// - Returns: A buttons with all the properties
    fileprivate func generateButton(fontSize: CGFloat = 17, title: String = "Example", tag: Int, color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) -> UIButton {
        // Prepare the attributes
        let fontName = fonts[Int.random(in: 0..<fonts.count)]
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = title.size(withAttributes: attributes)
        // Create the button
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .clear
        // Tweak the size
        let width = max(size.width, 15)
        let height = max(size.height, 20)
        button.frame = CGRect(x: 0.0, y: 0.0, width: width + offset, height: height + 5.0)
        //button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        // The tag will be used by the protocol to tell the delegate what button was tapped
        button.tag = tag
        return button
    }
    
    
    /// Will generate the cloud of words inside the view area
    /// - Parameter buttons: the array of buttons previouly generated
    fileprivate func generateCloud(_ buttons: [UIButton]) {
        var x = offset
        var y = offset
        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(x: x, y: y, width: button.frame.width, height: button.frame.height)
            x += button.frame.width + offset

            let nextTag = index <= buttons.count - 2 ? buttons[index + 1] : buttons[index]
            let nextTagWidth = nextTag.frame.width + offset
            
            // Next button wont fit in the row
            if x + nextTagWidth > frame.width {
                // Move y to a next row
                x = offset
                y += button.frame.height + offset
            }
            
            // Don't add buttons outside the view area
            if button.frame.origin.y + button.frame.height - offset > self.frame.size.height {
                tryAgain()
                return
            }
            
            addSubview(button)
        }
    }
    
    
    /// If all the buttons don't fit in the view area, reduce the maximum font size and try again
    /// maybe not the best approach, but simple and it works
    fileprivate func tryAgain() {
        // If the maximum font size reaches this value then don't reduce it more
        if maximumFontSize == 16 { return }
        // Remove all subviews
        subviews.forEach({$0.removeFromSuperview()})
        // Reduce font size
        maximumFontSize -= 1
        // Try again
        generateButtons()
    }
    
    
    /// Fonts constant
    fileprivate let fonts = [
    "AcademyEngravedLetPlain",
    "AlNile",
    "AlNile-Bold",
    "AmericanTypewriter",
    "AmericanTypewriter-Bold",
    "AmericanTypewriter-Condensed",
    "AmericanTypewriter-CondensedBold",
    "AmericanTypewriter-CondensedLight",
    "AmericanTypewriter-Light",
    "AppleColorEmoji",
    "AppleSDGothicNeo-Bold",
    "AppleSDGothicNeo-Light",
    "AppleSDGothicNeo-Medium",
    "AppleSDGothicNeo-Regular",
    "AppleSDGothicNeo-SemiBold",
    "AppleSDGothicNeo-Thin",
    "Arial",
    "Arial-BoldItalicMT",
    "Arial-BoldMT",
    "Arial-ItalicMT",
    "ArialMT",
    "ArialHebrew",
    "ArialHebrew-Bold",
    "ArialHebrew-Light",
    "ArialRoundedMTBold",
    "Avenir-Black",
    "Avenir-BlackOblique",
    "Avenir-Book",
    "Avenir-BookOblique",
    "Avenir-Heavy",
    "Avenir-HeavyOblique",
    "Avenir-Light",
    "Avenir-LightOblique",
    "Avenir-Medium",
    "Avenir-MediumOblique",
    "Avenir-Oblique",
    "Avenir-Roman",
    "AvenirNext-Bold",
    "AvenirNext-BoldItalic",
    "AvenirNext-DemiBold",
    "AvenirNext-DemiBoldItalic",
    "AvenirNext-Heavy",
    "AvenirNext-HeavyItalic",
    "AvenirNext-Italic",
    "AvenirNext-Medium",
    "AvenirNext-MediumItalic",
    "AvenirNext-Regular",
    "AvenirNext-UltraLight",
    "AvenirNext-UltraLightItalic",
    "AvenirNextCondensed-Bold",
    "AvenirNextCondensed-BoldItalic",
    "AvenirNextCondensed-DemiBold",
    "AvenirNextCondensed-DemiBoldItalic",
    "AvenirNextCondensed-Heavy",
    "AvenirNextCondensed-HeavyItalic",
    "AvenirNextCondensed-Italic",
    "AvenirNextCondensed-Medium",
    "AvenirNextCondensed-MediumItalic",
    "AvenirNextCondensed-Regular",
    "AvenirNextCondensed-UltraLight",
    "AvenirNextCondensed-UltraLightItalic",
    "BanglaSangamMN",
    "BanglaSangamMN-Bold",
    "Baskerville",
    "Baskerville-Bold",
    "Baskerville-BoldItalic",
    "Baskerville-Italic",
    "Baskerville-SemiBold",
    "Baskerville-SemiBoldItalic",
    "BodoniSvtyTwoITCTT-Bold",
    "BodoniSvtyTwoITCTT-Book",
    "BodoniSvtyTwoITCTT-BookIta",
    "BodoniSvtyTwoOSITCTT-Bold",
    "BodoniSvtyTwoOSITCTT-Book",
    "BodoniSvtyTwoOSITCTT-BookIt",
    "BodoniSvtyTwoSCITCTT-Book",
    "BradleyHandITCTT-Bold",
    "ChalkboardSE-Bold",
    "ChalkboardSE-Light",
    "ChalkboardSE-Regular",
    "Chalkduster",
    "Cochin",
    "Cochin-Bold",
    "Cochin-BoldItalic",
    "Cochin-Italic",
    "Copperplate",
    "Copperplate-Bold",
    "Copperplate-Light",
    "Courier",
    "Courier-Bold",
    "Courier-BoldOblique",
    "Courier-Oblique",
    "CourierNewPS-BoldItalicMT",
    "CourierNewPS-BoldMT",
    "CourierNewPS-ItalicMT",
    "CourierNewPSMT",
    "Damascus",
    "DamascusBold",
    "DamascusMedium",
    "DamascusSemiBold",
    "DevanagariSangamMN",
    "DevanagariSangamMN-Bold",
    "Didot",
    "Didot-Bold",
    "Didot-Italic",
    "DINAlternate-Bold",
    "DINCondensed-Bold",
    "EuphemiaUCAS",
    "EuphemiaUCAS-Bold",
    "EuphemiaUCAS-Italic",
    "Farah",
    "Futura-CondensedExtraBold",
    "Futura-CondensedMedium",
    "Futura-Medium",
    "Futura-MediumItalic",
    "GeezaPro",
    "GeezaPro-Bold",
    "GeezaPro-Light",
    "Georgia",
    "Georgia-Bold",
    "Georgia-BoldItalic",
    "Georgia-Italic",
    "GillSans",
    "GillSans-Bold",
    "GillSans-BoldItalic",
    "GillSans-Italic",
    "GillSans-Light",
    "GillSans-LightItalic",
    "GujaratiSangamMN",
    "GujaratiSangamMN-Bold",
    "GurmukhiMN",
    "GurmukhiMN-Bold",
    "STHeitiSC-Light",
    "STHeitiSC-Medium",
    "STHeitiTC-Light",
    "STHeitiTC-Medium",
    "Helvetica",
    "Helvetica-Bold",
    "Helvetica-BoldOblique",
    "Helvetica-Light",
    "Helvetica-LightOblique",
    "Helvetica-Oblique",
    "HelveticaNeue",
    "HelveticaNeue-Bold",
    "HelveticaNeue-BoldItalic",
    "HelveticaNeue-CondensedBlack",
    "HelveticaNeue-CondensedBold",
    "HelveticaNeue-Italic",
    "HelveticaNeue-Light",
    "HelveticaNeue-LightItalic",
    "HelveticaNeue-Medium",
    "HelveticaNeue-MediumItalic",
    "HelveticaNeue-Thin",
    "HelveticaNeue-Thin_Italic",
    "HelveticaNeue-UltraLight",
    "HelveticaNeue-UltraLightItalic",
    "HiraKakuProN-W3",
    "HiraKakuProN-W6",
    "HiraMinProN-W3",
    "HiraMinProN-W6",
    "HoeflerText-Black",
    "HoeflerText-BlackItalic",
    "HoeflerText-Italic",
    "HoeflerText-Regular",
    "IowanOldStyle-Bold",
    "IowanOldStyle-BoldItalic",
    "IowanOldStyle-Italic",
    "IowanOldStyle-Roman",
    "Kailasa",
    "Kailasa-Bold",
    "KannadaSangamMN",
    "KannadaSangamMN-Bold",
    "MalayalamSangamMN",
    "MalayalamSangamMN-Bold",
    "Marion-Bold",
    "Marion-Italic",
    "Marion-Regular",
    "MarkerFelt-Thin",
    "MarkerFelt-Wide",
    "Menlo-Bold",
    "Menlo-BoldItalic",
    "Menlo-Italic",
    "Menlo-Regular",
    "DiwanMishafi",
    "Noteworthy",
    "Noteworthy-Bold",
    "Noteworthy-Light",
    "Optima-Bold",
    "Optima-BoldItalic",
    "Optima-ExtraBlack",
    "Optima-Italic",
    "Optima-Regular",
    "OriyaSangamMN",
    "OriyaSangamMN-Bold",
    "Palatino-Bold",
    "Palatino-BoldItalic",
    "Palatino-Italic",
    "Palatino-Roman",
    "Papyrus",
    "Papyrus-Condensed",
    "PartyLetPlain",
    "SavoyeLetPlain",
    "SinhalaSangamMN",
    "SinhalaSangamMN-Bold",
    "SnellRoundhand",
    "SnellRoundhand-Black",
    "SnellRoundhand-Bold",
    "Superclarendon-Black",
    "Superclarendon-BlackItalic",
    "Superclarendon-Bold",
    "Superclarendon-BoldItalic",
    "Superclarendon-Italic",
    "Superclarendon-Light",
    "Superclarendon-LightItalic",
    "Superclarendon-Regular",
    "TamilSangamMN",
    "TamilSangamMN-Bold",
    "TeluguSangamMN",
    "TeluguSangamMN-Bold",
    "Thonburi",
    "Thonburi-Bold",
    "Thonburi-Light",
    "TimesNewRomanPS-BoldItalicMT",
    "TimesNewRomanPS-BoldMT",
    "TimesNewRomanPS-ItalicMT",
    "TimesNewRomanPSMT",
    "Trebuchet-BoldItalic",
    "TrebuchetMS",
    "TrebuchetMS-Bold",
    "TrebuchetMS-Italic",
    "Verdana",
    "Verdana-Bold",
    "Verdana-BoldItalic",
    "Verdana-Italic",
    "ZapfDingbatsITC]"]
}
