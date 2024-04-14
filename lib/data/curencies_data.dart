import 'package:expenses_tracker_app/models/currency.dart';

List<Currency> currencies = [
  Currency(name: 'Việt Nam Đồng', code: 'VNĐ', picked: true, locale: 'vi_VN'),
  Currency(name: 'Đô la Mỹ', code: 'USD', picked: false, locale: 'en_US'),
  Currency(name: 'Euro', code: 'EUR', picked: false, locale: 'fr_FR'),
  Currency(name: 'Bảng Anh', code: 'GBP', picked: false, locale: 'en_GB'),
  Currency(name: 'Yên Nhật', code: 'JPY', picked: false, locale: 'ja_JP'),
  Currency(name: 'Nhân dân tệ', code: 'CNY', picked: false, locale: 'zh_CN'),
  Currency(name: 'Đô la Úc', code: 'AUD', picked: false, locale: 'en_AU'),
  Currency(name: 'Won Hàn Quốc', code: 'KRW', picked: false, locale: 'ko_KR'),
  Currency(name: 'Baht Thái Lan', code: 'THB', picked: false, locale: 'th_TH'),
  Currency(name: 'Đô la Đài Loan', code: 'TWD', picked: false, locale: 'zh_TW'),
  Currency(name: 'Đô la Singapore', code: 'SGD', picked: false, locale: 'en_SG'),
  Currency(name: 'Đô la Hồng Kông', code: 'HKD', picked: false, locale: 'zh_HK'),
  Currency(name: 'Đô la Canada', code: 'CAD', picked: false, locale: 'en_CA'),
  Currency(name: 'Franc Thụy Sĩ', code: 'CHF', picked: false, locale: 'fr_CH'),
  Currency(name: 'Krona Thụy Điển', code: 'SEK', picked: false, locale: 'sv_SE'),
  Currency(name: 'Peso Mexico', code: 'MXN', picked: false, locale: 'es_MX'),
  Currency(name: 'Krone Na Uy', code: 'NOK', picked: false, locale: 'nb_NO'),
  Currency(name: 'Lia Thổ Nhĩ Kỳ', code: 'TRY', picked: false, locale: 'tr_TR'),
  Currency(name: 'Rupi Ấn Độ', code: 'INR', picked: false, locale: 'hi_IN'),
  Currency(name: 'Rúp Nga', code: 'RUB', picked: false, locale: 'ru_RU'),
  Currency(name: 'Real Braxin', code: 'BRL', picked: false, locale: 'pt_BR'),
  Currency(name: 'Rand Nam Phi', code: 'ZAR', picked: false, locale: 'en_ZA'),
  Currency(name: 'Riyal Saudi', code: 'SAR', picked: false, locale: 'ar_SA'),
  Currency(name: 'Dirham UAE', code: 'AED', picked: false, locale: 'ar_AE'),
  Currency(name: 'Rupi Indonesia', code: 'IDR', picked: false, locale: 'id_ID'),
  Currency(name: 'Krone Đan Mạch', code: 'DKK', picked: false, locale: 'da_DK'),
  Currency(name: 'Złoty Ba Lan', code: 'PLN', picked: false, locale: 'pl_PL'),
  Currency(name: 'New Shekel Israel', code: 'ILS', picked: false, locale: 'he_IL'),
  Currency(name: 'Peso Philippines', code: 'PHP', picked: false, locale: 'fil_PH'),
  Currency(name: 'Đô la Bahamas', code: 'BSD', picked: false, locale: 'en_BS'),
  Currency(name: 'Dinar Kuwait', code: 'KWD', picked: false, locale: 'ar_KW'),
  Currency(name: 'Đô la Barbados', code: 'BBD', picked: false, locale: 'en_BB'),
  Currency(name: 'Đô la Jamaica', code: 'JMD', picked: false, locale: 'en_JM'),
  Currency(name: 'Đô la Trinidad và Tobago', code: 'TTD', picked: false, locale: 'en_TT'),
  Currency(name: 'Đô la Brunei', code: 'BND', picked: false, locale: 'ms_BN'),
  Currency(name: 'Đô la Caribbean Đông', code: 'XCD', picked: false, locale: 'en_XC'),
  Currency(name: 'Đô la Fiji', code: 'FJD', picked: false, locale: 'en_FJ'),
];

List<String> currenciesCodeHasDecimal = ['USD','BND','FJD','EUR','GBP','CNY','AUD','THB','TWD','SGD','HKD','CAD','CHF','SEK','MXN','NOK','TRY','INR','RUB','BRL','ZAR','SAR','AED','IDR','DKK','PLN','ILS','PHP','BSD','KWD','BBD','JMD','XCD'];