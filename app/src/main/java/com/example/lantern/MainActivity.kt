package com.example.lantern

import android.content.pm.PackageManager
import android.hardware.camera2.CameraManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class MainActivity : AppCompatActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {

        var cameraFlash =false
        var flashOn= false


        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val mySwitch= findViewById<Button>(R.id.switch2)

        cameraFlash= packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)

        mySwitch.setOnClickListener {
            if(cameraFlash) {   //check if device has camera flash
                if(flashOn) {
                    flashOn= false
                    this.flashLightOff()
                    mySwitch.text="OFF"
                }
                else {
                    flashOn = true
                    this.flashLightOn()
                    mySwitch.text="ON"
                }
        }
            else {

            }
    }
    }

    private fun flashLightOn() {
        val cameraManager: CameraManager= getSystemService(CAMERA_SERVICE) as CameraManager
        val cameraId : String

        try {
            cameraId= cameraManager.cameraIdList[0]
            cameraManager.setTorchMode(cameraId,true)

        }catch (e: Exception) {
            throw Exception("$e")
        }
    }

    private fun flashLightOff() {
        val cameraManager: CameraManager= getSystemService(CAMERA_SERVICE) as CameraManager
        val cameraId : String

        try {
            cameraId= cameraManager.cameraIdList[0]
            cameraManager.setTorchMode(cameraId,false)

        }catch (e: Exception) {}
    }

}