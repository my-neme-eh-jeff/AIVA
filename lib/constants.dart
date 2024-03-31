class Constants {
  double deviceWidth = 888.0;
  double deviceHeight = 406.6666666666667;

  String apiKey = 'AIzaSyBLfuL7Vztx2v3HCc73oYRa1oU5KEJyLcU';

  String ngrokurl =
      'https://d56b-2409-40c0-1048-fe65-597d-2429-50c1-3560.ngrok-free.app';
  String base_url = 'http://13.200.249.129:8080';

  String prompt = """
      [CONTEXT]
      You are an AI classification model that needs to classify if the user query pertains to Information Retrieval or not.
    
      [INSTRUCTIONS]
      You will be provided a user query, and you must indicate whether the query requires the extraction of information such as facts, summaries, news articles, etc.
      The query shall also be considered Information Retrieval if it asks to perform basic or complex calculations.
    
    
      [EXAMPLES]
      1. User query: "How's the weather today?"
        Type: Information Retrieval
    
      2. User query: "Set a reminder for tomorrow's meeting at 10 AM."
        Type: None
    
      3. User query: "What's your favorite movie?"
        Type: Information Retrieval
    
      4. User query: "Find the nearest coffee shop."
        Type: None
    
      5. User query: "What is 30% of 50?"
         Type: Information Retrieval
      
      The query is: """;

  List<String> TTSLocaleIDS = [
    'hr-HR',
    'ko-KR',
    'mr-IN',
    'ru-RU',
    'zh-TW',
    'hu-HU',
    'sw-KE',
    'th-TH',
    'ur-PK',
    'nb-NO',
    'da-DK',
    'tr-TR',
    'et-EE',
    'pt-PT',
    'vi-VN',
    'en-US',
    'sq-AL',
    'sv-SE',
    'ar',
    'su-ID',
    'bn-BD',
    'bs-BA',
    'gu-IN',
    'kn-IN',
    'el-GR',
    'hi-IN',
    'he-IL',
    'fi-FI',
    'bn-IN',
    'km-KH',
    'fr-FR',
    'uk-UA',
    'pa-IN',
    'en-AU',
    'nl-NL',
    'fr-CA',
    'lv-LV',
    'sr',
    'pt-BR',
    'de-DE',
    'ml-IN',
    'si-LK',
    'cs-CZ',
    'is-IS',
    'pl-PL',
    'ca-ES',
    'sk-SK',
    'it-IT',
    'fil-PH',
    'lt-LT',
    'ne-NP',
    'ms-MY',
    'en-NG',
    'nl-BE',
    'zh-CN',
    'es-ES',
    'ja-JP',
    'ta-IN',
    'bg-BG',
    'cy-GB',
    'yue-HK',
    'es-US',
    'en-IN',
    'jv-ID',
    'id-ID',
    'te-IN',
    'ro-RO',
    'en-GB'
  ];
  List<String> TTSDisplay = [
    'Croatian',
    'Korean',
    'Marathi',
    'Russian',
    'Chinese (Traditional, Taiwan)',
    'Hungarian',
    'Swahili',
    'Thai',
    'Urdu',
    'Norwegian Bokmål',
    'Danish',
    'Turkish',
    'Estonian',
    'Portuguese (Portugal)',
    'Vietnamese',
    'English (United States)',
    'Albanian',
    'Swedish',
    'Arabic',
    'Sundanese',
    'Bengali (Bangladesh)',
    'Bosnian',
    'Gujarati',
    'Kannada',
    'Greek',
    'Hindi',
    'Hebrew',
    'Finnish',
    'Bengali (India)',
    'Khmer',
    'French (France)',
    'Ukrainian',
    'Punjabi (India)',
    'English (Australia)',
    'Dutch',
    'French (Canada)',
    'Latvian',
    'Serbian',
    'Portuguese (Brazil)',
    'German',
    'Malayalam',
    'Sinhala',
    'Czech',
    'Icelandic',
    'Polish',
    'Catalan',
    'Slovak',
    'Italian',
    'Filipino (Philippines)',
    'Lithuanian',
    'Nepali',
    'Malay (Malaysia)',
    'English (Nigeria)',
    'Dutch (Belgium)',
    'Chinese (Simplified, China)',
    'Spanish (Spain)',
    'Japanese',
    'Tamil (India)',
    'Bulgarian',
    'Welsh',
    'Cantonese (Hong Kong)',
    'Spanish (United States)',
    'English (India)',
    'Javanese',
    'Indonesian',
    'Telugu (India)',
    'Romanian',
    'English (United Kingdom)'
  ];
}
