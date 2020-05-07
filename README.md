
# My Quotes
[![style: pedantic](https://img.shields.io/badge/style-pedantic-40c4ff.svg)](https://pub.dev/packages/pedantic)   

Simple mobile app for storing personal quotes.

Some ideas and libraries used:
- [Provider](https://github.com/rrousselGit/provider)
- [Get_it](https://github.com/fluttercommunity/get_it)
- Bloc + [RxDart](https://github.com/ReactiveX/rxdart)
- [Hive](https://pub.dev/packages/hive) for database
- custom [Toast](https://github.com/BaranMichal25/my_quotes/blob/master/lib/commons/widgets/toast.dart) implementation
- pedantic and custom [analysis rules](https://github.com/BaranMichal25/my_quotes/blob/master/analysis_options.yaml)

# Alternative architecture
This project was originally created using BLOC, [Sqflite](https://github.com/tekartik/sqflite) and without UseCases. 
If you're more interested in that, you can check out [bloc_sqflite](https://github.com/BaranMichal25/my_quotes/tree/bloc_sqflite) branch. 
Although it also has less features than master branch.

# Google Play
[![Get it on Google Play][Play Store Badge]][Play Store]

# Screenshots
<img src="screenshots/screenshot-1.png" width="280px" />   <img src="screenshots/screenshot-2.png" width="280px" />   <img src="screenshots/screenshot-3.png" width="280px" />

# License
```
   Copyright 2020 Michal Baran

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```

[Play Store]: https://play.google.com/store/apps/details?id=io.blacklagoonapps.quotes
[Play Store Badge]: https://play.google.com/intl/en_us/badges/images/badge_new.png
