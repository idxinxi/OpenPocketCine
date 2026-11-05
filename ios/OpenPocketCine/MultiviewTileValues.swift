import MonitorUI
import OpenCineAppKit
import OpenCineCore
import OpenCineCameraControls
import OpenCineMedia
import OpenCineMulticam
import OpenPocketViewCore
import SwiftUI

/// Formats only received telemetry. The stage has no clock, polling or inferred
/// timecode; the session's existing status publication remains its cadence owner.
struct MultiviewTelemetryPresentation {
    let settings: CameraStatus
    private let power: PowerStatus
    let storageObservation: StorageStatus?

    init(settings: CameraStatus, power: PowerStatus, storageObservation: StorageStatus? = nil) {
        self.settings = settings; self.power = power; self.storageObservation = storageObservation
    }

    var iso: String { settings.iso > 0 ? "\(settings.iso)" : "—" }
    var shutter: String { settings.shutterDenom > 0 ? "1/\(settings.shutterDenom)" : "—" }
    var whiteBalance: String {
        settings.whiteBalance.map { $0.mode == .auto ? String(localized: "Auto") : "\($0.kelvin)K" } ?? "—"
    }
    var focus: String {
        switch settings.focusMode {
        case .single: String(localized: "AF-S")
        case .continuous: String(localized: "AF-C")
        case nil: "—"
        }
    }
    var battery: String {
        MonitorOperatorPowerReading.readoutLabel(power.batteryReading) ?? "\u{2014}"
    }
    var storage: String {
        let readout = storageObservation.map { $0.storageReadout } ?? settings.storageReadout
        return readout?.free ?? StorageReadout.unavailable
    }
    var format: String {
        let resolution = settings.videoResolution?.label ?? "—"
        let rate = settings.fps > 0 ? "\(settings.fps)p" : "—"
        return "\(resolution) \(rate) · \(settings.colorMode?.label ?? "—")"
    }
    static func letter(_ index: Int) -> String { MultiviewTile.letter(min(3, index)) }

    /// The stage's program readouts and Grid's in-tile row.
    var readouts: [MultiviewReadout] {
        [
            .init(title: String(localized: "ISO"), value: iso), .init(title: String(localized: "SHUTTER"), value: shutter),
            .init(title: String(localized: "WB"), value: whiteBalance), .init(title: String(localized: "FOCUS"), value: focus),
        ]
    }

    @MainActor static func recordingStatus(_ tile: MultiviewSession.Tile) -> String {
        MultiviewTally.text(
            recording: tile.recordingActive, seconds: tile.settings.recordElapsedSec,
            waiting: tile.recordingBusy, holding: tile.recovering,
            failed: tile.failureMessage != nil)
    }

    @MainActor static func sessionSummary(_ session: MultiviewSession) -> String {
        // The partial-confirmation note must keep showing after the operation
        // ends, so it is recognised by the word that only appears in that
        // note's copy in both catalog locales ("confirmed" / "已确认").
        if let note = session.groupRecordingNote,
            session.groupRecordingBusy || note.contains("confirmed") || note.contains("已确认")
        {
            return note
        }
        let assigned = session.tiles.filter { $0.camera != nil }
        guard !assigned.isEmpty else { return String(localized: "Ready for your first camera") }
        let recovering = assigned.filter { $0.recovering }.count
        let live = assigned.filter { $0.hasPicture && !$0.recovering }.count
        if recovering > 0 { return String(localized: "\(live) live · \(recovering) reconnecting") }
        if live != assigned.count { return String(localized: "\(live) live · \(assigned.count) cameras") }
        let recording = assigned.filter { $0.recordingActive == true }.count
        if recording > 0 { return String(localized: "\(recording) of \(assigned.count) recording") }
        return String(localized: "\(assigned.count) cameras connected")
    }
}

extension MultiviewSession {
    /// The shared stage's values for one slot, `nil` while it is empty.
    func stageTile(_ index: Int) -> MultiviewTile? {
        let tile = tiles[index]
        guard let camera = tile.camera else { return nil }
        let power = tile.control.current.power
        let values = MultiviewTelemetryPresentation(
            settings: tile.settings, power: power, storageObservation: tile.control.current.storage)
        let preview = camera.hasMultiviewPreview
        let settled = !busy && !tile.connecting && !tile.recovering
        var actions = [
            MultiviewCameraAction(
                MultiviewCameraAction.liveView, String(localized: "Live View"),
                enabled: tile.controlHost != nil && !tile.recovering),
            MultiviewCameraAction(
                MultiviewTileAction.record,
                tile.recordingActive == true ? String(localized: "Stop recording") : String(localized: "Start recording"),
                kind: .record,
                enabled: tile.recordingAvailable && !tile.recordingBusy && !groupRecordingBusy
                    && !closing),
            MultiviewCameraAction(
                MultiviewTileAction.lut, tile.lutEnabled ? String(localized: "Disable Auto LUT") : String(localized: "Enable Auto LUT"),
                enabled: preview),
        ]
        if preview || tile.failureMessage != nil {
            actions.append(
                .init(MultiviewTileAction.reconnect, String(localized: "Reconnect"), enabled: settled, closes: true))
        }
        if tile.failureMessage != nil, !tile.experimentalNetwork, tile.identity == nil {
            actions.append(
                .init(
                    MultiviewTileAction.experimental, String(localized: "Try experimental shared Wi-Fi"),
                    enabled: settled, closes: true))
        }
        actions.append(
            .init(
                MultiviewTileAction.remove, String(localized: "Remove camera"), kind: .destructive,
                enabled: !(busy || tile.connecting || groupRecordingBusy || tile.recordingBusy
                    || closing)))
        let note = tile.recordingNote
        let showsStatus = !tile.hasPicture || tile.failureMessage != nil || tile.recovering
        return MultiviewTile(
            name: camera.name, model: camera.model.name, format: values.format,
            storage: values.storage,
            timecode: tile.timecodeReadout,
            tally: MultiviewTelemetryPresentation.recordingStatus(tile),
            recording: tile.recordingActive == true, lut: tile.lutEnabled, note: note,
            tileNote: note == String(localized: "Recording") || note == String(localized: "Recording stopped") ? nil : note,
            readouts: values.readouts,
            status: showsStatus
                ? MultiviewTileStatus(
                    text: tile.recovering
                        ? String(localized: "Restoring picture…")
                        : tile.failureMessage == nil ? tile.status : String(localized: "Connection failed · Options"),
                    detail: tile.failureMessage ?? tile.status,
                    inProgress: tile.recovering
                        || (tile.failureMessage == nil && !tile.networkVerified))
                : nil,
            detail: tile.status, failure: tile.failureMessage,
            footnote: tile.networkVerified && !preview
                ? String(localized: "Remove this camera to enable group recording for your other cameras.") : nil,
            actions: actions, accessibilityValue: tile.previewAccessibilityValue
        ).withPower(power)
    }

    /// The record plan for every camera (`nil`) or one slot, with what blocks it now.
    func recordContext(slot: Int?) -> MultiviewRecordContext {
        MultiviewRecordContext(session: self, tile: slot.map { tiles[$0] })
    }
}

/// Pocket's camera option ids beside the shared Live View id.
enum MultiviewTileAction {
    static let record = "record"
    static let lut = "lut"
    static let reconnect = "reconnect"
    static let experimental = "experimental"
    static let remove = "remove"
}

extension MultiviewRecordContext {
    @MainActor init(session: MultiviewSession, tile: MultiviewSession.Tile? = nil) {
        self.init(
            plan: session.recordPlan(for: tile), busy: session.busy || session.groupRecordingBusy,
            closing: session.closing)
    }
}
