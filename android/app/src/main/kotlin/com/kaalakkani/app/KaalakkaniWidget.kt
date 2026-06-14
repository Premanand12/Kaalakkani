package com.kaalakkani.app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import com.kaalakkani.kaalakkani.R

class KaalakkaniWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val widgetData = HomeWidgetPlugin.getData(context)

            val nallaStart   = widgetData.getString("nalla_start", "--:--") ?: "--:--"
            val nallaEnd     = widgetData.getString("nalla_end",   "--:--") ?: "--:--"
            val rahuStart    = widgetData.getString("rahu_start",  "--:--") ?: "--:--"
            val rahuEnd      = widgetData.getString("rahu_end",    "--:--") ?: "--:--"
            val tamilDate    = widgetData.getString("tamil_date",  "ஆனி 29") ?: "ஆனி 29"
            val tamilYear    = widgetData.getString("tamil_year",  "பராபவ")  ?: "பராபவ"
            val thithi       = widgetData.getString("thithi",      "--")     ?: "--"
            val nakshatra    = widgetData.getString("nakshatra",   "--")     ?: "--"

            val views = RemoteViews(context.packageName, R.layout.kaalakkani_widget)

            views.setTextViewText(R.id.widget_tamil_date, tamilDate)
            views.setTextViewText(R.id.widget_tamil_year, tamilYear)
            views.setTextViewText(R.id.widget_thithi, thithi)
            views.setTextViewText(R.id.widget_nakshatra, nakshatra)
            views.setTextViewText(R.id.widget_nalla_neram, "நல்ல நேரம்: $nallaStart–$nallaEnd")
            views.setTextViewText(R.id.widget_rahukaalam, "ராகு: $rahuStart–$rahuEnd")

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
