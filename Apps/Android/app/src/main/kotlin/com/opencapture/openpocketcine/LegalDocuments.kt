package com.opencapture.openpocketcine

import com.opencapture.opencine.cameracontrols.MonitorLegalDocument
import com.opencapture.opencine.cameracontrols.MonitorLegalDocuments
import com.opencapture.opencine.cameracontrols.MonitorPlatformLegalNotices
import com.opencapture.opencine.cameracontrols.MonitorSettingsCopy

/**
 * The in-app privacy text. The shared reliability paragraph
 * (`MonitorSettingsCopy.reliabilityReportsPrivacy`) is injected as a format
 * argument: it lives in the shared layer, so this repo localizes only its own
 * paragraphs around it.
 */
internal fun privacyBody(format: FormatResolver = englishFormatResolver()): String =
    format(R.string.legal_privacy_body, arrayOf(MonitorSettingsCopy.reliabilityReportsPrivacy))

/**
 * Pocket's legal set: privacy ships with the app and the terms are the web page. Licenses and
 * NOTICE are the repository's LICENSE, THIRD-PARTY-NOTICES.md and NOTICE, staged as resources at
 * build time, with the platform notices; a build missing one shows the unavailable page.
 */
internal fun pocketLegalDocuments(format: FormatResolver = englishFormatResolver()) = MonitorLegalDocuments(
    wordmark = "OPENPOCKETCINE",
    privacy = MonitorLegalDocument.Text(privacyBody(format)),
    terms = MonitorLegalDocument.Link(OpenPocketCineLinks.TERMS),
    licenses = MonitorLegalDocument.bundledText(listOf(
        MonitorLegalDocument.resource("openpocketcine/legal/LICENSE"),
        MonitorLegalDocument.resource("openpocketcine/legal/THIRD-PARTY-NOTICES.md"),
        MonitorPlatformLegalNotices.text,
    )),
    notice = MonitorLegalDocument.bundledText(listOf(MonitorLegalDocument.resource("openpocketcine/legal/NOTICE"))),
)
