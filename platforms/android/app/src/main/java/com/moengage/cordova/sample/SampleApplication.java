package com.moengage.cordova.sample;

import android.app.Application;
import com.moengage.core.Logger;
import com.moengage.core.MoEngage;
import com.moengage.core.MoEngage.DATA_REGION;



public class SampleApplication extends Application{
  public void onCreate(){
    super.onCreate();
    MoEngage moEngage = new MoEngage.Builder(this, "DAO6UGZ73D9RTK8B5W96TPYN")
        .setLogLevel(Logger.VERBOSE)
        .enableLocationServices()
        .setNotificationSmallIcon(R.drawable.icon)
        .setNotificationLargeIcon(R.drawable.icon)
        .setSenderId("615448685370")
        .setNotificationType(R.integer.notification_type_multiple)
        .redirectDataToRegion(DATA_REGION.REGION_DEFAULT)
        .build();
        MoEngage.initialise(moEngage);
  }
}
