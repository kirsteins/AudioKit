// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation
import CAudioKit

/// Stereo StereoFieldLimiter
///
public class StereoFieldLimiter: AKNode, AKToggleable, AKComponent {

    public static let ComponentDescription = AudioComponentDescription(effect: "sflm")

    public typealias AKAudioUnitType = InternalAU

    public private(set) var internalAU: AKAudioUnitType?

    // MARK: - Properties

    public static let amountDef = AKNodeParameterDef(
        identifier: "amount",
        name: "Limiting amount",
        address: akGetParameterAddress("StereoFieldLimiterAmount"),
        range: 0.0...1.0,
        unit: .generic,
        flags: .default)

    /// Limiting Factor
    @Parameter public var amount: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [AKNodeParameterDef] {
            [StereoFieldLimiter.amountDef]
        }

        public override func createDSP() -> AKDSPRef {
            akCreateDSP("StereoFieldLimiterDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this stereo field limiter node
    ///
    /// - Parameters:
    ///   - input: AKNode whose output will be amplified
    ///   - amount: limit factor (Default: 1, Minimum: 0)
    ///
    public init(_ input: AKNode, amount: AUValue = 1) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit
            self.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType

            self.amount = amount
        }
        connections.append(input)
    }
}
