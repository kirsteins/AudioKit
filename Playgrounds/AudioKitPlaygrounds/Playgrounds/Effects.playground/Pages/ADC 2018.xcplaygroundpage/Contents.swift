//: # ADC 2018
import AudioKit
//: Components
let mic = engine.input
let reverb = CostelloReverb()
var reverbMixer = DryWetMixer()
//: Signal Chain
let delay = VariableDelay(mic)
let delayMixer = DryWetMixer(mic, delay)
let reverb = CostelloReverb(delayMixer)
reverbMixer = DryWetMixer(delayMixer, reverb)
var output = reverbMixer
//: Parameters
delay.time = 0.25
delay.feedback = 0.0
delayMixer.balance = 0.5
reverb.feedback = 0.4
reverbMixer.balance = 0.2
reverbMixer.balance = 0.5

// Copies for plotting
let micCopy1 = Fader(mic)
let micCopy2 = Fader(mic)
let micCopy3 = Fader(mic)

engine.output = StereoFieldLimiter(reverbMixer)
try engine.start()

//: User Interface
import AudioKitUI

class LiveView: AKLiveViewController {

    var trackedAmplitudeSlider: AKSlider!
    var trackedFrequencySlider: AKSlider!

    override func viewDidLoad() {

        addTitle("ADC 2018")

        addView(AKSlider(property: "Delay Time", value: delay.time) { sliderValue in
            delay.time = sliderValue
        })
        addView(AKSlider(property: "Delay Feedback", value: delay.feedback) { sliderValue in
            delay.feedback = sliderValue
        })

        let rollingPlot = AKNodeOutputPlot(micCopy2, frame: CGRect(x: 0, y: 0, width: 440, height: 200))
        rollingPlot.plotType = .rolling
        rollingPlot.shouldFill = true
        rollingPlot.shouldMirror = true
        rollingPlot.color = AKColor.red
        rollingPlot.gain = 2
        addView(rollingPlot)

        let plot = AKNodeOutputPlot(micCopy3, frame: CGRect(x: 0, y: 0, width: 440, height: 200))
        plot.plotType = .buffer
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = AKColor.blue
        plot.gain = 2
        addView(plot)

        let fftPlot = AKNodeFFTPlot(micCopy1, frame: CGRect(x: 0, y: 0, width: 500, height: 200))
        fftPlot.shouldFill = true
        fftPlot.shouldMirror = false
        fftPlot.shouldCenterYAxis = false
        fftPlot.color = AKColor.purple
        fftPlot.gain = 100
        addView(fftPlot)

    }
}

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = LiveView()
