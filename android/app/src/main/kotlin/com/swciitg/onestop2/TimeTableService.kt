package com.swciitg.onestop2
import android.content.Intent
import android.widget.RemoteViewsService

class TimeTableService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TimeTableRemoteViewsFactory(this.applicationContext, intent)
    }
}
