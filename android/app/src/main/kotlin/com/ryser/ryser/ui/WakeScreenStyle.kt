package com.ryser.ryser.ui

import android.app.Activity
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.core.view.ViewCompat
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat

/** Native presentation only: cold-start alarm playback never waits for Flutter. */
class WakeScreenStyle(private val activity: Activity) {
    val green = Color.rgb(89, 255, 155)
    val text = Color.rgb(232, 255, 237)
    val muted = Color.rgb(168, 185, 175)

    fun dp(value: Int) = (value * activity.resources.displayMetrics.density).toInt()

    fun prepareWindow() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            activity.setShowWhenLocked(true)
            activity.setTurnScreenOn(true)
        } else {
            activity.window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        }
        activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        WindowCompat.setDecorFitsSystemWindows(activity.window, false)
    }

    fun label(value: String, size: Float = 16f, color: Int = text) = TextView(activity).apply {
        text = value
        textSize = size
        setTextColor(color)
        gravity = Gravity.CENTER
        typeface = Typeface.create("sans-serif", Typeface.NORMAL)
        setLineSpacing(dp(3).toFloat(), 1f)
    }

    fun space(height: Int) = View(activity).apply {
        layoutParams = LinearLayout.LayoutParams(1, dp(height))
    }

    fun frame() = GradientDrawable().apply {
        setColor(Color.rgb(7, 19, 12))
        cornerRadius = dp(20).toFloat()
        setStroke(dp(1), Color.rgb(37, 104, 64))
    }

    fun panel() = LinearLayout(activity).apply {
        orientation = LinearLayout.VERTICAL
        gravity = Gravity.CENTER
        setPadding(dp(20), dp(28), dp(20), dp(28))
        background = frame()
    }

    fun button(title: String, primary: Boolean) = Button(activity).apply {
        text = title
        isAllCaps = false
        textSize = 18f
        typeface = Typeface.create("sans-serif-medium", Typeface.NORMAL)
        setTextColor(if (primary) Color.BLACK else green)
        background = GradientDrawable().apply {
            setColor(if (primary) green else Color.rgb(9, 25, 16))
            cornerRadius = dp(16).toFloat()
            if (!primary) setStroke(dp(1), Color.rgb(37, 104, 64))
        }
        minHeight = dp(64)
        setPadding(dp(16), dp(16), dp(16), dp(16))
        layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT)
    }

    fun screen(status: String, populate: LinearLayout.() -> Unit): ScrollView {
        val content = LinearLayout(activity).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(dp(24), dp(24), dp(24), dp(24))
            val version = activity.packageManager.getPackageInfo(activity.packageName, 0).versionName.orEmpty()
            addView(label("RYSER · $version", 14f, green))
            addView(space(10))
            addView(label(status, 17f, muted))
            addView(space(24))
            populate()
        }
        return ScrollView(activity).apply {
            isFillViewport = true
            setBackgroundColor(Color.BLACK)
            addView(content, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT))
            ViewCompat.setOnApplyWindowInsetsListener(this) { view, insets ->
                val bars = insets.getInsets(WindowInsetsCompat.Type.systemBars() or
                    WindowInsetsCompat.Type.displayCutout())
                view.setPadding(bars.left, bars.top, bars.right, bars.bottom)
                insets
            }
        }
    }
}
