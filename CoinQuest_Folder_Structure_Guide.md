# CoinQuest — Folder & File Purpose Guide

இந்த doc-ல `lib/` folder-ல இருக்குற **ஒவ்வொரு folder-உம், ஒவ்வொரு file-உம்** என்ன வேலைக்கு use ஆகும்-ன்னு explain பண்ணி இருக்கேன். Architecture: **Clean Architecture + BLoC** (feature-first).

---

## 🧠 மொத்த Architecture Idea (முதல்ல இதை புரிஞ்சிக்கோங்க)

ஒவ்வொரு feature-உம் 3 layers-ஆ பிரிக்கப்பட்டிருக்கு:

```
data          → Internet/Database-ல இருந்து raw data எடுக்கிறது
domain        → Business logic, rules (UI அல்லது data source-ஐ சாராதது)
presentation  → UI + State management (BLoC)
```

**Data flow (எப்படி வேலை பண்ணும்):**
```
UI (Page) 
   → dispatches Event to BLoC
      → BLoC calls UseCase
         → UseCase calls Repository (abstract, domain layer)
            → Repository Implementation (data layer) calls DataSource
               → DataSource hits API/DB, returns raw JSON
            → converts JSON → Model → Entity
         → returns Entity back to UseCase
      → BLoC emits new State
   → UI rebuilds based on State
```

இந்த flow-ஐ தலைல வச்சிக்கிட்டு கீழ features பாருங்க, easy-ஆ புரியும்.

---

## 📁 lib/core/ — எல்லா features-உம் share பண்ணிக்கிற common code

| Folder/File | என்ன வேலை |
|---|---|
| `core/constants/app_colors.dart` | App முழுசுக்கும் Color constants — Primary Purple `#5B3DF5`, Gold `#FFC83D` etc. இதை direct-ஆ hex code type பண்றதுக்கு பதிலா `AppColors.primaryPurple` mாதிரி use பண்ணலாம். |
| `core/constants/app_strings.dart` | App-ல தெரியற text strings எல்லாம் ஒரே இடத்துல — "Sign Up", "Continue", error messages etc. (later multi-language add பண்ணனும்னா இதுவே helpful) |
| `core/constants/app_sizes.dart` | Spacing, padding, radius values — 8pt grid system (`8.0, 16.0, 24.0`), card radius `20.0`, button radius `18.0` etc. |
| `core/theme/app_theme.dart` | Flutter `ThemeData` object — MaterialApp-ல `theme:` property-ல இது pass பண்றது. Dark theme, button styles, input decoration theme எல்லாம் இங்க define பண்ணுவோம். |
| `core/theme/app_text_styles.dart` | Poppins/Inter font styles — H1, H2, H3, Body Large, Body Small, Caption — Design system-ல mention பண்ணின typography scale. |
| `core/widgets/primary_button.dart` | Reusable Gold/Purple button widget — app முழுசும் இதே button-ஐ reuse பண்றோம் (design system-ல "Component Library" mention பண்ணது). |
| `core/widgets/glass_card.dart` | Reusable glassmorphism card widget — Balance Card, Budget Card, Lesson Card எல்லாம் இந்த base widget-ஐ use பண்ணும். |
| `core/widgets/app_bottom_nav.dart` | Bottom Navigation Bar widget (Home, Budget, Learn, Challenge, Profile) — app-ல எல்லா main screens-லயும் இதே nav bar reuse ஆகும். |
| `core/utils/validators.dart` | Form validation functions — email valid-ஆ இருக்கானு, password strong-ஆ இருக்கானு check பண்ற functions. |
| `core/utils/formatters.dart` | Currency format (`₹1,250.50`), date format, number format functions. |
| `core/services/local_storage_service.dart` | Phone-ல data save பண்ற service (SharedPreferences/Hive) — login token, user preferences local-ஆ store பண்ணுறதுக்கு. |
| `core/services/api_service.dart` | Backend API-க்கு network calls pண்ற base service (Dio/http package wrap பண்ணி) — GET, POST, PUT, DELETE base functions. |
| `core/router/app_router.dart` | App navigation/routing setup — Splash → Onboarding → Home, screen-க்கு screen navigate பண்ற logic (go_router/auto_route use பண்ணலாம்). |
| `core/errors/failures.dart` | Domain layer-ல use ஆகற error classes — `ServerFailure`, `CacheFailure`, `NetworkFailure` etc. (Either<Failure, Success> pattern-க்கு). |
| `core/errors/exceptions.dart` | Data layer-ல use ஆகற exception classes — `ServerException`, `CacheException` — API/DB fail ஆனா throw பண்ண. |

---

## 📁 lib/features/ — ஒவ்வொரு feature module

கீழ ஒவ்வொரு feature-க்கும் **அதே 3-layer pattern** repeat ஆகுது. ஒரு feature (`expense`) example வச்சு விளக்கமா சொல்றேன், மத்த 15 features-லயும் இதே logic தான்.

### Example: `features/expense/` (Add Expense screen-ஓட logic)

#### `data/` layer — Raw data handling
| File | வேலை |
|---|---|
| `data/datasources/expense_remote_datasource.dart` | Backend API call — "add expense", "get expense list" API hit பண்ற class. Raw JSON response திருப்பும். |
| `data/models/expense_model.dart` | JSON-ஐ Dart object-ஆ convert பண்ற model class — `ExpenseModel.fromJson()`, `toJson()` methods இருக்கும். `ExpenseEntity`-ஐ extend பண்ணும். |
| `data/repositories/expense_repository_impl.dart` | `domain/repositories/expense_repository.dart`-ல define பண்ண abstract contract-ஐ **implement** பண்ற class. DataSource-ஐ call பண்ணி, error handle பண்ணி, Entity திருப்பும். |

#### `domain/` layer — Business logic (pure, no Flutter/API dependency)
| File | வேலை |
|---|---|
| `domain/entities/expense_entity.dart` | Pure Dart class — `amount`, `category`, `description`, `date` fields. இது UI அல்லது API-ஐ சாராது, business object மட்டும். |
| `domain/repositories/expense_repository.dart` | **Abstract class** (contract) — "எந்த methods இருக்கணும்"-னு மட்டும் சொல்லும் (`addExpense()`, `getExpenses()`), implementation இல்ல. இது data layer-க்கும் domain layer-க்கும் இடையில ஒரு "boundary". |
| `domain/usecases/get_expense_usecase.dart` | ஒரே ஒரு specific task pண்ற class — "get all expenses" use case. BLoC இதை call பண்ணும், இது repository-ஐ call பண்ணும். (Single Responsibility Principle) |

#### `presentation/` layer — UI + State Management
| File | வேலை |
|---|---|
| `presentation/bloc/expense_bloc.dart` | **Business Logic Component** — Events வந்தா, UseCase call பண்ணி, States emit பண்ணும். இதுவே "brain" of the screen. |
| `presentation/bloc/expense_event.dart` | User actions — `AddExpenseEvent`, `LoadExpensesEvent`, `DeleteExpenseEvent` — "என்ன நடக்குது" describe பண்ணும். |
| `presentation/bloc/expense_state.dart` | UI states — `ExpenseLoading`, `ExpenseLoaded`, `ExpenseError` — "screen எப்படி காமிக்கணும்" describe பண்ணும். |
| `presentation/pages/expense_page.dart` | Actual UI screen (Widget) — `BlocBuilder`/`BlocListener` use பண்ணி state-ஐ கேட்டு UI காமிக்கும். |
| `presentation/widgets/` | இந்த feature-க்கு மட்டும் specific-ஆ இருக்குற small reusable widgets (e.g., `expense_list_item.dart`, `category_chip.dart`) |

---

## 📋 All 16 Features — என்னென்ன வேலை

| Feature Folder | இது எதுக்கு |
|---|---|
| `splash` | App open ஆனதும் காமிக்குற logo/loading screen. Login status check பண்ணி எங்க navigate பண்றதுன்னு decide பண்ணும் logic இங்க இருக்கும். |
| `onboarding` | முதல்முறை app open பண்ணும்போது காமிக்குற 3 intro slides (Problem → Learn → Save). |
| `auth` | Sign Up, Login, Logout — user authentication முழுசும் இதுல handle ஆகும். |
| `age_selection` | 13–15 அல்லது 16–18 age group select பண்ற screen + logic. இதுவே எந்த mascot/tone/content காமிக்கணும்-ன்னு decide பண்ணும். |
| `home` | Main Dashboard — Balance card, quick actions, recent expenses, savings goal preview. |
| `expense` | Expense add பண்றது, expense history பாக்குறது, category picker, spending analytics. |
| `budget` | Budget set பண்றது, category limits, budget progress tracking. |
| `savings` | Savings goals create பண்றது, goal progress track பண்றது, savings add பண்றது. |
| `learn` | Financial literacy lessons — lesson list, lesson content, lesson complete tracking. |
| `quiz` | Lesson-க்கு அப்புறம் வர quiz questions, answer submit, result காமிக்குறது. |
| `challenges` | Gamified savings/learning challenges — active/completed challenges list. |
| `leaderboard` | XP-based ranking — top users, "you" position காமிக்குறது. |
| `ai_chat` | AI Money Assistant chat interface — Premium feature, user questions-க்கு AI reply. |
| `monthly_report` | Month-end progress summary — spending, saving, learning, engagement stats + AI summary. |
| `profile` | User profile info, badges, settings, account management. |
| `parent_dashboard` | Parent-side view — child's spending/savings/learning progress overview + detailed report. |

---

## 🔑 lib/ root files

| File | வேலை |
|---|---|
| `lib/main.dart` | App entry point — `void main()` இங்க இருக்கும், `runApp()` call பண்றது இங்க தான். BLoC providers, dependency injection setup (get_it) இங்க initialize ஆகும். |
| `lib/app.dart` | `MaterialApp` widget wrap பண்ற root widget — theme, router, title எல்லாம் இங்க set ஆகும். `main.dart` இதை call பண்ணும். |

---

## 📁 assets/

| Folder | வேலை |
|---|---|
| `assets/images/` | Mascot illustrations, backgrounds, PNG/JPG images. |
| `assets/icons/` | Custom SVG/PNG icons (Material Symbols இல்லாத custom icons இருந்தா). |
| `assets/animations/` | Lottie JSON animation files — confetti, coin drop, XP bar fill animations. |
| `assets/fonts/` | Poppins, Inter font `.ttf` files — `pubspec.yaml`-ல register பண்ணணும். |

---

## ✅ Quick Reference — "இந்த வேலைக்கு எந்த file போகணும்?"

| நான் என்ன pண்ண வேணும் | எந்த file-ல pண்ணணும் |
|---|---|
| புது API endpoint call பண்ணணும் | `data/datasources/xxx_remote_datasource.dart` |
| JSON response-ஐ Dart object ஆக்கணும் | `data/models/xxx_model.dart` |
| புது business rule add பண்ணணும் | `domain/usecases/xxx_usecase.dart` |
| புது UI screen add பண்ணணும் | `presentation/pages/xxx_page.dart` |
| Screen-ல புது button/card design பண்ணணும் | `presentation/widgets/` |
| User action-க்கு (button click) response pண்ணணும் | `presentation/bloc/xxx_event.dart` + `xxx_bloc.dart` |
| Loading/Success/Error UI காமிக்கணும் | `presentation/bloc/xxx_state.dart` |
| App-முழுசும் use ஆகற color/font மாத்தணும் | `core/theme/` அல்லது `core/constants/` |
| App-முழுசும் use ஆகற button/card design மாத்தணும் | `core/widgets/` |
| Navigation/routing மாத்தணும் | `core/router/app_router.dart` |

---

## 🚀 அடுத்தபடி என்ன pண்ணலாம்?

1. `pubspec.yaml`-ல dependencies add பண்ணணும் (`flutter_bloc`, `equatable`, `get_it`, `dio`, `go_router` etc.)
2. `core/theme/`, `core/constants/` files-ல actual content நிரப்பணும் (colors, text styles)
3. ஒரு feature (e.g., `splash` அல்லது `onboarding`) முதல்ல end-to-end complete பண்ணி, அதை மாதிரி வச்சு மத்த features-க்கும் pattern follow பண்ணலாம்

வேணுமா, இதுக்கு அடுத்து **`pubspec.yaml` dependencies list** + **core files-ல actual code** (app_colors.dart, app_theme.dart) பண்ணி தரவா?
