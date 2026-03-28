import Foundation

final class SettingsManager {
  static let shared = SettingsManager()

  private let defaults = UserDefaults.standard

  private enum Key: String {
    case geminiAPIKey
    case openClawHost
    case openClawPort
    case openClawHookToken
    case openClawGatewayToken
    case geminiSystemPrompt
    case webrtcSignalingURL
    case speakerOutputEnabled
    case videoStreamingEnabled
    case proactiveNotificationsEnabled
    // Phantom
    case phantomAutonomousEnabled
    case phantomAnalysisInterval
    case phantomConfidenceThreshold
    case phantomUserPreferences
  }

  private init() {}

  // MARK: - Gemini

  var geminiAPIKey: String {
    get { defaults.string(forKey: Key.geminiAPIKey.rawValue) ?? Secrets.geminiAPIKey }
    set { defaults.set(newValue, forKey: Key.geminiAPIKey.rawValue) }
  }

  var geminiSystemPrompt: String {
    get { defaults.string(forKey: Key.geminiSystemPrompt.rawValue) ?? GeminiConfig.defaultSystemInstruction }
    set { defaults.set(newValue, forKey: Key.geminiSystemPrompt.rawValue) }
  }

  // MARK: - OpenClaw

  var openClawHost: String {
    get { defaults.string(forKey: Key.openClawHost.rawValue) ?? Secrets.openClawHost }
    set { defaults.set(newValue, forKey: Key.openClawHost.rawValue) }
  }

  var openClawPort: Int {
    get {
      let stored = defaults.integer(forKey: Key.openClawPort.rawValue)
      return stored != 0 ? stored : Secrets.openClawPort
    }
    set { defaults.set(newValue, forKey: Key.openClawPort.rawValue) }
  }

  var openClawHookToken: String {
    get { defaults.string(forKey: Key.openClawHookToken.rawValue) ?? Secrets.openClawHookToken }
    set { defaults.set(newValue, forKey: Key.openClawHookToken.rawValue) }
  }

  var openClawGatewayToken: String {
    get { defaults.string(forKey: Key.openClawGatewayToken.rawValue) ?? Secrets.openClawGatewayToken }
    set { defaults.set(newValue, forKey: Key.openClawGatewayToken.rawValue) }
  }

  // MARK: - WebRTC

  var webrtcSignalingURL: String {
    get { defaults.string(forKey: Key.webrtcSignalingURL.rawValue) ?? Secrets.webrtcSignalingURL }
    set { defaults.set(newValue, forKey: Key.webrtcSignalingURL.rawValue) }
  }

  // MARK: - Audio

  var speakerOutputEnabled: Bool {
    get { defaults.bool(forKey: Key.speakerOutputEnabled.rawValue) }
    set { defaults.set(newValue, forKey: Key.speakerOutputEnabled.rawValue) }
  }

  // MARK: - Video

  var videoStreamingEnabled: Bool {
    get { defaults.object(forKey: Key.videoStreamingEnabled.rawValue) as? Bool ?? true }
    set { defaults.set(newValue, forKey: Key.videoStreamingEnabled.rawValue) }
  }

  // MARK: - Notifications

  var proactiveNotificationsEnabled: Bool {
    get { defaults.object(forKey: Key.proactiveNotificationsEnabled.rawValue) as? Bool ?? true }
    set { defaults.set(newValue, forKey: Key.proactiveNotificationsEnabled.rawValue) }
  }

  // MARK: - Phantom

  var phantomAutonomousEnabled: Bool {
    get { defaults.object(forKey: Key.phantomAutonomousEnabled.rawValue) as? Bool ?? true }
    set { defaults.set(newValue, forKey: Key.phantomAutonomousEnabled.rawValue) }
  }

  /// Interval in seconds between autonomous scene analyses (5-60)
  var phantomAnalysisInterval: Double {
    get {
      let stored = defaults.double(forKey: Key.phantomAnalysisInterval.rawValue)
      return stored > 0 ? stored : 10.0
    }
    set { defaults.set(newValue, forKey: Key.phantomAnalysisInterval.rawValue) }
  }

  /// Confidence threshold: 0 = act on everything, 1 = high confidence only, 2 = ask for everything
  var phantomConfidenceThreshold: Int {
    get { defaults.integer(forKey: Key.phantomConfidenceThreshold.rawValue) }
    set { defaults.set(newValue, forKey: Key.phantomConfidenceThreshold.rawValue) }
  }

  /// User preferences learned over time, newline-separated
  var phantomUserPreferences: String {
    get { defaults.string(forKey: Key.phantomUserPreferences.rawValue) ?? "" }
    set { defaults.set(newValue, forKey: Key.phantomUserPreferences.rawValue) }
  }

  func addUserPreference(_ preference: String) {
    let current = phantomUserPreferences
    if current.isEmpty {
      phantomUserPreferences = preference
    } else {
      phantomUserPreferences = current + "\n" + preference
    }
  }

  // MARK: - Reset

  func resetAll() {
    for key in [Key.geminiAPIKey, .geminiSystemPrompt, .openClawHost, .openClawPort,
                .openClawHookToken, .openClawGatewayToken, .webrtcSignalingURL,
                .speakerOutputEnabled, .videoStreamingEnabled,
                .proactiveNotificationsEnabled,
                .phantomAutonomousEnabled, .phantomAnalysisInterval,
                .phantomConfidenceThreshold, .phantomUserPreferences] {
      defaults.removeObject(forKey: key.rawValue)
    }
  }
}
