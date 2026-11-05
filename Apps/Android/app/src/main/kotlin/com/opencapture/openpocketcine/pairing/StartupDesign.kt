package com.opencapture.openpocketcine.pairing

import androidx.compose.foundation.background
import androidx.compose.ui.Modifier
import com.opencapture.opencine.vocabulary.ConnectionPhase
import com.opencapture.openpocketcine.LiveDesign

/** The app backdrop behind the shell. */
fun Modifier.startupBackdrop(): Modifier = background(LiveDesign.background)

fun ConnectionPhase.isBusy(): Boolean =
    when (this) {
        ConnectionPhase.IDLE,
        ConnectionPhase.SCANNING,
        ConnectionPhase.FAILED,
        ConnectionPhase.LIVE,
        -> false
        else -> true
    }

