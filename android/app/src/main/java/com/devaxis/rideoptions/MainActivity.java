package com.devaxis.rideoptions;

import android.content.Intent;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.khurramdev";
    private MethodChannel.Result _result;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            _result = result;
                            final Map<String, String> arguments = call.arguments();
                            String Jazz_MerchantID = (String) arguments.get("Jazz_MerchantID");
                            String Jazz_Password = (String) arguments.get("Jazz_Password");
                            String Jazz_IntegritySalt = (String) arguments.get("Jazz_IntegritySalt");
                            String paymentReturnUrl = (String) arguments.get("paymentReturnUrl");
                            String price = (String) arguments.get("price");
                            if (call.method.equals("Print")) {
                                System.out.println(arguments);

                                Intent i = new Intent(MainActivity.this, PaymentActivity.class);

                                i.putExtra("price", price);
                                i.putExtra("paymentReturnUrl", paymentReturnUrl);
                                i.putExtra("Jazz_IntegritySalt", Jazz_IntegritySalt);
                                i.putExtra("Jazz_Password", Jazz_Password);
                                i.putExtra("Jazz_MerchantID", Jazz_MerchantID);


                                startActivityForResult(i, 0);
                            }
                        }
                );
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 0) {
            // Parse response data back as map
            String response = "";
            if (data != null) {
                response = data.getStringExtra("response");
            }

            _result.success(response);
        }
    }
}
