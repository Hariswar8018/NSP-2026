const functions = require("firebase-functions");
const { GoogleAuth } = require("google-auth-library");

// ✅ Node 18+ / 20+ / 24 has native fetch
const fetch = global.fetch;

const auth = new GoogleAuth({
  scopes: ["https://www.googleapis.com/auth/cloud-platform"],
});

exports.transliterate = functions.https.onCall(async (data, context) => {
  try {
    const text = data?.text;

    console.log("RECEIVED DATA:", data);
    console.log("TEXT:", text);

    if (!text || text.trim().length === 0) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Text is required"
      );
    }

    // 🔐 OAuth
    const client = await auth.getClient();
    const accessToken = await client.getAccessToken();

    const url = `https://translation.googleapis.com/v3/projects/${process.env.GCLOUD_PROJECT}/locations/global:translateText`;

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${accessToken.token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        contents: [text],
        sourceLanguageCode: "hi",
        targetLanguageCode: "en",
        mimeType: "text/plain",
        transliterationConfig: {   // ✅ correct field
          enable: true
        }
      }),
    });

    const result = await response.json();

    console.log("GOOGLE RAW RESPONSE:", result);

    if (!response.ok) {
      throw new functions.https.HttpsError(
        "internal",
        JSON.stringify(result)
      );
    }

    return {
      input: text,
      output: result.translations[0].transliteratedText
    };

  } catch (err) {
    console.error("Function Error:", err);
    throw new functions.https.HttpsError("internal", err.toString());
  }
});
