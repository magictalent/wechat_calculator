import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // ⚠️ IMPORTANT: UPDATE THIS WITH YOUR OWN FIREBASE PROJECT CREDENTIALS ⚠️
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded
        // Replace the entire JSON below with your own project's service account JSON

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "calculator-chat-ad906",
          "private_key_id": "ff78a11a7238600e8c6695de920415cd32b227d4",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCiUX2UsV8Jg2my\n2D6kDuDa+c83xuHk9BoN6HUamXZqV5HuKRyB2cJaHt7l6inj7O2csSSocNWZgyRt\nsx1fZaIpYI2mID4HzYjSEioZlTEmJOzHEsROIr/vD48PGIcytIMTqBwhwqy9CeD9\n0HCxrpBd30B5k1FL9PcEmxgz6FGcOLsRS5Haueg00R8jnIuNNT6dk9FpxgLi45G/\nalJTx8evprvY2EsFOGeesC9ZYa/emBVJrQjXQgjE7IuX2ueFAQaLLLBdrdenxEVi\nWoVXkqT+jL0OCtaxZfmSiozDdhOVv4nNAm0pceI5OtJOIdTI131uTDSgw2Hff/5H\nYgPtBC2NAgMBAAECggEAEQzu3GL6aPkrLfx9rgWbFJ2HqSQE4CRNJVddD799myOa\nQnKCmlhJzGYwQ2YC4vylJB/OijwaD+9g8P4O8JGwRFjuYDxET9UFEY4Tao8Ls+ZO\nkgXUZaHMWBwiCrOopgikuTigReKZex0Ry4+s+tkrtJSqROsW79vqY8s38mHtyrNX\nDVld+Ync8BudkucnpqTCPmjYasPFRwjtYFyrOXXJRZTLF7MzWpi3V5QrloI3rpQk\nfYSflx6W1dQJ19XLRAB2WtRh0WMyDAaXAr+jluLEe1PZHpWpanZ9yOuAQZ3fUi1q\nIxmolinS/prch8iRdNQCBuXq1D1QyTyubggxsa3diQKBgQDNbU0x9kqP5+OQ+Jr5\nS/UHEkvi4kslj17CGDza1MZ79TMW3tLIRU7fiYM3H++GogYDwaEWo1CjIdtg6TOq\nspiHYacyuvkn80ys+FoRPbYje7I+dbZLjlwBDd3YCUiP3z4fmtX+HSb+Hyr3eSZ6\nYAmh43PoKBjLf+bru29+P6UHyQKBgQDKR1Zt1ziiqjn5zZqqWY4zbcBwxS8FfqW3\nDYWh4jyEBikimgOcu1qzfv+KUqWcTthK1GBt7m9eDdVuCAjpvJSkaXuAMP+xkLnc\nLG8pyuIGEU1T735ssfo0L+ERKwiU3P5xMh24OmEHlIf6790oglo7aYctdh99sGVP\n6i6k4ZthpQKBgQDJ6Pep9tkcjqCW2jOAes7wT2R1MVUJKtzJS4ds0xvvtHatsP9e\nRvkaL4/f+6yzGMduo7+Qf57/aIS2wR++VGIlFq9+5lWElde0XzovngdK4waz64Ds\nzJTTmGyHLcC7YIIwEEDqzn6H4dyaduKB/6kYDHbdJaQRSLqQ0p7oaOftOQKBgFP8\neLNUmCxZ94ZzytMOKg/Kcwufo51pb07o62JCuBOtJyk5v2Q1GjzK7zk0hZS32/B9\n66fZRx5LKiHsbh72cNUvAts//Ppx9+ml/WXh2iTgzDWci+Z/oz5F3vIs5vxAIdlI\nELTscFsgXbFgJHhsXyCp+Tl0ATFDq10aA9Hr5oMNAoGAdj6/qeEkOKHG3JtL+/8J\nvTNoKE1/iIbHlMVDXZ7iBe7q6Yx8UU+SkYGgijYfI1XzMl/Ou+DOdl5eJWn0Q40c\n+uZYft3NDM7TvpapsNvFThT8XNBW5eldy4mRlo/sYqeWbK+j7hFRPDiDSCxZKNoT\ndzhq75paBKA4tJHKvPK1FgY=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@calculator-chat-ad906.iam.gserviceaccount.com",
          "client_id": "105495868549956477800",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40calculator-chat-ad906.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
