# iOS localization (Simplified Chinese)

App-layer copy in `ios/OpenPocketCine/` is localized for Simplified Chinese
(`zh-Hans`). The catalog is `ios/OpenPocketCine/Localizable.xcstrings`
(221 keys) plus `ios/OpenPocketCine/InfoPlist.xcstrings` (6 permission
descriptions). The full inventory behind the catalog is
`ios-inventory.json` in the localization work area (229 strings: 17 A, 206 B,
6 C); the inventory also records what this repo cannot localize.

## Mechanism

- **A (16 + 1):** SwiftUI literals (`Text` / `Button` / `.alert` /
  `.navigationTitle` / `ProgressView` titles). No code change; the catalog
  alone localizes them through `LocalizedStringKey`. One exception is
  `MultiviewCameraSettings.swift:157/160`, where a ternary inside `Text`
  resolves to the `String` overload, so each branch is wrapped in
  `String(localized:)` instead.
- **B (206):** copy passed around as `String` (static copy, `controlNote`,
  `errorDescription`, titles/help/messages passed to shared components).
  Each literal is wrapped at its creation site in `String(localized:)`.
  Interpolated literals become `%@` keys in the catalog (e.g. `"Zoom \(to)"`
  -> `"Zoom %@"`).
- **C (6):** system permission descriptions from `ios/project.yml`, covered
  by `InfoPlist.xcstrings`. No code change.

## Strings that deliberately stay English in code

- `StartupConnectionCopy` matching keys (`bluetoothDenied`,
  `bluetoothOff`, `bluetoothNotReady`, `localNetworkDenied` in
  `StartupChrome.swift`) stay English: the Bluetooth link matches on them
  (`bluetoothProblems`, `opensSettings`, `reason`). They are translated at
  the last step before display, in `StartupConnectionCopy.friendly()`'s
  display mapping. Every other `StartupConnectionCopy` constant is wrapped.
- `Fail.errorDescription` (`CameraSession.swift`) is wrapped, but its text
  flows back into `friendly()` as `why`, whose keyword matching runs on
  English. Four specific messages (pairing/command timeout, disconnect)
  therefore surface as-is in Chinese instead of mapping to the generic
  `bluetoothTimedOut` / `bluetoothEnded` copy. The specific copy is equally
  actionable, so this is accepted, not a bug.
- `AppRoot.swift:985`: the `.confirmationDialog` title ternary is left
  unwrapped. That title takes a `LocalizedStringKey`, so the ternary
  auto-localizes; wrapping it would hand a `String` to a
  `LocalizedStringKey`-only parameter. The `Stop` / `Start` buttons on the
  same dialog are wrapped (a `Button` ternary resolves to `String`).
- Comparisons are wrapped on both sides so they keep working in any locale:
  `controlNote == "not live"` / `== "Frame Too Small"`
  (`CameraSession.swift`), `tile.status != "Live · Video mode"`
  (`MultiviewSession.swift`), and the `tileNote` check against `"Recording"`
  / `"Recording stopped"` (`MultiviewTileValues.swift`).
- `MultiviewTileValues.sessionSummary` keeps showing the partial-confirmation
  note after the operation ends by checking
  `note.contains("confirmed") || note.contains("已确认")` — the word that
  only appears in that note's copy in both catalog locales.
- Persisted identifiers are never localized: `MultiviewLayout` raw values
  (`"2 × 2 grid"`, `"Center stage"` — only `displayName` is wrapped),
  `fireCamera` command names, `MonitorSettingsCopy` inputs that are codes
  (`"settings.source"`, `"camera.unknown"`), brand names (`"DJI"`,
  `"Frame.io"`, `"OpenPocketCine"`), and the `label` values `"AF-S"` /
  `"AF-C"` matched by `CaptureFocusAdmission.commonValue`.
- `control.commit(..., label:)` (`"FOCUS \(label)"`, `"Zoom \(ratio)"`) is
  wrapped on the assumption that the label is a human-readable annotation,
  not a machine key (the machine key is the `SettingValue`). If shared code
  ever matches on the label, this must be revisited.

## What is still English

- **Shared layer (OpenCine):** almost all `MonitorSettingsCopy.*` copy,
  settings section titles, capture-sheet field labels, `session.phase.label`,
  `MonitorSettingsCopy.reliabilityReportsPrivacy` (interpolated into the
  privacy text as `%@`), and the `PairingWizard` / `MultiviewStage` /
  `MonitorLegalDocumentScreen` chrome. Localizing those needs work in the
  OpenCine repo, not here. The privacy/terms texts themselves are translated
  here, but they are legal texts: get them professionally proofread before
  release.
- **Pipeline copy:** connection progress text from the shared transport
  (`setupProgress`, e.g. `"Finding..."` prefixes it matches on), live
  telemetry labels, and `tile.failureMessage` when it comes straight from
  `djiConnectionFailureDescription` for the local-network case (the main
  failure-card path goes through `friendly()` and is translated).
- **Settings tab titles:** `MultiviewCameraSettings.title(_:)` localizes
  `.wb` (`"WB"`) and `.resolution` (`"Format"`); every other category falls
  back to `category.rawValue.capitalized` in English.
- **Tests/review:** `MultiviewUIReview` / `MonitorUIReview` copy and
  simulator-only strings are untouched by design.

## Verification limits

This was wired and checked by script only (residual-literal scan, catalog
key coverage, `String(localized:)` count reconciliation: 229 added). The
machine has no Xcode/SDK, so nothing here has been compiled. Before merging,
build on a Mac (`xcodegen` + build) and run the iOS unit tests — they assert
on `StartupConnectionCopy` strings and must still pass (they run in the
English locale, where `String(localized:)` returns English). Then switch a
device to Simplified Chinese and walk: pairing wizard, a Bluetooth-denied
failure, the live chrome notes, settings, multiview tiles and error states,
and the privacy/terms pages.
