# Android localization

Android UI copy owned by this repo is localized for Simplified Chinese
(`zh-rCN`). English stays the default.

## Resources

- `Apps/Android/app/src/main/res/values/strings.xml` — English (default).
  Every string the code references must exist here, or the build fails.
- `Apps/Android/app/src/main/res/values-zh-rCN/strings.xml` — Simplified
  Chinese. Same 111 names as the default file (108 inventoried strings plus
  `app_name`, `startup_wordmark`, and `camera_name_fallback`).
- `Apps/Android/app/src/main/kotlin/com/opencapture/openpocketcine/AppStrings.kt`
  — the same English copy as a `when` map (`englishText`), plus
  `englishFormat` for format strings. This is the fallback resolver for code
  that builds copy outside composition and outside any `Context`, and for
  the plain-JVM unit tests, which have no Android resources. Do not hand-edit
  entries: regenerate it together with the XML files when copy changes.

## How each site resolves copy

- Composables use `stringResource(R.string.…)` (with format args where the
  string has `%1$s` / `%1$d`). Callbacks that run outside composition
  (for example the network-setup `connect` callback) resolve through a
  captured `Context` instead — `stringResource` is composition-only.
- Code outside composition resolves through `AppModel.localized()` /
  `MultiviewSession.localized()` (and the `…Format` variants), which read
  the application context, so the device locale wins.
- Pure functions that unit tests call directly (`pairingWizard`,
  `multiviewTileReadouts`, `multiviewExposureReadouts`,
  `multiviewStageReadouts`, `appLutPickerCopy`, `appAssistHost`,
  `pocketLegalDocuments`) take a resolver parameter defaulting to the
  English map (`::englishText` / `englishFormatResolver()`). Production
  passes a `Context`-backed resolver; tests keep asserting the English
  behaviour unchanged. `AppModel.nearbyCard` keeps English default arguments
  for the same reason.
- `SettingsColorDot` carries a `@StringRes nameRes` instead of a literal
  name; `appAssistHost` resolves it with the passed resolver.

## Strings with arguments

- `multiview_picker_footer` — `%1$s` is the SSID being joined.
- `multiview_camera_tab` — `%1$s` is the tile letter (A, B, …), `%2$s` the
  camera name.
- `multiview_settings_preview_description` — `%1$s` is the camera name, or
  `camera_name_fallback` ("Camera" / "相机") when there is none.
- `pairing_blocker_allow_permission` — `%1$s` is the permission display
  name from the shared layer (still English; see below).
- `multiview_status_finding_on_wifi` — `%1$d` is the attempt number.
- `multiview_tally_recording` — `%1$s` is the `mm:ss` elapsed time.
- `legal_privacy_body` — `%1$s` is the shared reliability paragraph
  (`MonitorSettingsCopy.reliabilityReportsPrivacy`), injected at runtime.
- `pairing_still_looking` holds only this repo's second sentence. The
  vendor-app tip prefix comes from the shared layer at runtime
  (`DjiFailures.DJI_APPS_TIP`) and is still English.

## What is NOT localized here

Anything rendered by the shared OpenCine layer lives in the sibling
OpenCine checkout, not this repo: `MonitorSettingsCopy.*` help text,
`Monitor*` screen copy, connection-phase labels, `DjiFailures` messages,
permission display names, and `CameraStatus`-derived labels such as
`focusLabel` / `colorLabel`. Those stay English until the shared layer is
localized. Brand words (`OpenPocketCine`, `OPENPOCKETCINE`, `DJI`, `WB`,
`ISO`, tally codes) are intentionally identical in both files.

## Adding a string

1. Add the English text to `values/strings.xml` and the Chinese text to
   `values-zh-rCN/strings.xml`, same name, lowercase snake_case.
2. If the string is built outside composition, add the English entry to
   `AppStrings.kt`'s `englishText` map as well.
3. Escape apostrophes as `\'`, double quotes as `\"`, newlines as `\n`,
   and a literal `%` as `%%` in the XML files. Format arguments use
   `%1$s` (string) or `%1$d` (integer).
4. Keep both files' name sets identical, or lint's `MissingTranslation`
   check will flag the gap.

## Verification limits

This change was verified by script, not by a build: XML well-formedness,
identical name sets across both files, placeholder parity between
languages, no unescaped apostrophes, every `R.string.*` reference
resolving, and no leftover hardcoded inventory literals in main source
(the two English default arguments in `nearbyCard` are intentional, for
the JVM tests). There is no Android SDK on the machine that produced it,
so run `just android-check` on a machine with the SDK (or CI) before
merging. Instrumented tests assume the default locale for their English
assertions.
