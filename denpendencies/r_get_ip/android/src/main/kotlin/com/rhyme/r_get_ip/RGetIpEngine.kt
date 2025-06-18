package com.rhyme.r_get_ip

import android.content.Context
import android.content.ContextWrapper
import android.net.ConnectivityManager
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.lang.Exception
import java.lang.StringBuilder
import java.net.Inet4Address
import java.net.NetworkInterface
import java.net.URL
import java.net.URLConnection
import java.util.*
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLSocketFactory

class RGetIpEngine(private val context: Context) : ContextWrapper(context) {
    val serverUrl = "https://api.ipify.org?format=json"

    fun getInternalIP(): String? {
        try {
            val interfaces = Collections.list(NetworkInterface.getNetworkInterfaces())
            for (item in interfaces) {
                val addresses = item.inetAddresses
                for (address in addresses) {
                    val host = address.hostAddress
                    if (!address.isLoopbackAddress && address is Inet4Address) {
                        if (host != null) {
                            val isIpv4 = host.indexOf(":") < 0
                            return if (isIpv4) {
                                host
                            } else {
                                val percentIndex = host.indexOf("%")
                                if (percentIndex < 0) host.toUpperCase(Locale.getDefault()) else host.substring(
                                    0,
                                    percentIndex
                                ).toUpperCase(Locale.getDefault())
                            }
                        }
                    }

                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

    fun getExternalIP(): String? {
        try {
            val url = URL(serverUrl)
            val connect = url.openConnection() as HttpsURLConnection
            connect.requestMethod = "GET"
            connect.readTimeout = 6 * 10000
            connect.connectTimeout = 6 * 10000
            connect.sslSocketFactory = SSLSocketFactory.getDefault() as SSLSocketFactory?
            connect.doInput = true
            val code = connect.responseCode
            if (code == 200) {
                connect.connect()
                val inputStream = connect.inputStream
                val reader = BufferedReader(InputStreamReader(inputStream, "utf-8"))
                val sb = StringBuilder()
                var strRead: String? = reader.readLine()
                while (strRead != null) {
                    sb.append(strRead)
                    sb.append("\r\n")
                    strRead = reader.readLine()
                }
                reader.close()
                inputStream.close()
                val json = JSONObject(sb.toString())
                return json.getString("ip")
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

    fun getNetworkType(): String {
        val connectMsg = getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
        val networkInfo = connectMsg.activeNetworkInfo ?: return "none"
        if (networkInfo.type == ConnectivityManager.TYPE_MOBILE) {
            return "cellular"
        } else if (networkInfo.type == ConnectivityManager.TYPE_WIFI) {
            return "wifi"
        } else {
            return "other"
        }

    }
}