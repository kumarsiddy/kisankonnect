package com.example.kisankonnect

import android.annotation.SuppressLint
import android.app.Activity
import android.content.IntentSender
import android.location.Location
import android.os.Looper
import android.widget.Toast
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.*
import com.google.android.gms.tasks.OnCompleteListener


object LocationService {
    public const val REQUEST_LOCATION_SETTINGS = 1334;
    private lateinit var mFusedLocationClient: FusedLocationProviderClient


    fun getLocation(activity: Activity, onLocationFetch: (location: Location) -> Unit) {
        val locationRequest = LocationRequest();
        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY;

        val builder = LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest);

        val result =
                LocationServices.getSettingsClient(activity).checkLocationSettings(builder.build())

        result.addOnCompleteListener(OnCompleteListener {
            try {
                val response: LocationSettingsResponse? = it.getResult(ApiException::class.java)
                requestLocation(activity, onLocationFetch)
            } catch (exception: ApiException) {
                when (exception.statusCode) {
                    LocationSettingsStatusCodes.RESOLUTION_REQUIRED ->
                        try {
                            val resolvable = exception as ResolvableApiException
                            resolvable.startResolutionForResult(
                                    activity,
                                    REQUEST_LOCATION_SETTINGS
                            );
                        } catch (e: IntentSender.SendIntentException) {
                            // Ignore the error.
                        } catch (e: ClassCastException) {
                            // Ignore, should be an impossible error.
                        }
                    LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE ->
                        Toast.makeText(
                                activity,
                                "GPS not available",
                                Toast.LENGTH_LONG
                        ).show();
                }
            }
        })
    }

    @SuppressLint("MissingPermission")
    private fun requestLocation(activity: Activity, onLocationFetch: (location: Location) -> Unit) {
        val locationRequest = LocationRequest()
        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        locationRequest.interval = 0
        locationRequest.fastestInterval = 0
        locationRequest.numUpdates = 1

        val mLocationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                val mLastLocation: Location = locationResult.lastLocation
                onLocationFetch(mLastLocation)
            }
        }

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(activity)
        mFusedLocationClient.requestLocationUpdates(
                locationRequest,
                mLocationCallback,
                Looper.myLooper()
        )
    }

}